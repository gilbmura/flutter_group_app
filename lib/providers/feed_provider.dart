import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/campus.dart';
import '../models/post.dart';

/// Owns the list of posts and all the discovery filters. The UI just reads
/// `posts` (the computed, filtered+sorted view) and flips filters via setters —
/// classic single-source-of-truth state handling.
class FeedProvider extends ChangeNotifier {
  final List<Post> _seed;
  final List<Post> _userPosts = [];
  bool _loaded = false;

  PostType? _typeFilter;
  Campus _campusFilter = Campus.all;
  bool _missionOnly = false;
  List<String> _myMissions = const [];

  static const _kUserPosts = 'feed_user_posts';

  FeedProvider(List<Post> seed) : _seed = List.of(seed);

  bool get loaded => _loaded;
  PostType? get typeFilter => _typeFilter;
  Campus get campusFilter => _campusFilter;
  bool get missionOnly => _missionOnly;

  /// Posts created by the signed-in user (always surfaced on Home).
  List<Post> get userPosts => List.unmodifiable(_userPosts);

  List<Post> get _allPosts => [..._userPosts, ..._seed];

  int get totalPostCount => _allPosts.length;

  /// Clears filters so a newly published post is visible on Home immediately.
  void resetFilters() {
    _typeFilter = null;
    _campusFilter = Campus.all;
    _missionOnly = false;
    notifyListeners();
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kUserPosts);
      if (raw != null) {
        final list = jsonDecode(raw) as List<dynamic>;
        _userPosts
          ..clear()
          ..addAll(
            list.map((e) => Post.fromJson(e as Map<String, dynamic>)),
          );
      }
    } catch (_) {
      _userPosts.clear();
    }
    _loaded = true;
    notifyListeners();
  }

  void setMyMissions(List<String> missions) {
    _myMissions = missions;
    notifyListeners();
  }

  void setType(PostType? type) {
    _typeFilter = type;
    notifyListeners();
  }

  void setCampus(Campus campus) {
    _campusFilter = campus;
    notifyListeners();
  }

  void toggleMissionOnly() {
    _missionOnly = !_missionOnly;
    notifyListeners();
  }

  /// Unfiltered catalog — used by Explore so Home filters do not shrink search.
  List<Post> get allPosts {
    final copy = List<Post>.of(_allPosts);
    copy.sort((a, b) {
      final at = a.startTime ?? DateTime(2100);
      final bt = b.startTime ?? DateTime(2100);
      return at.compareTo(bt);
    });
    return copy;
  }

  /// The visible home feed. Hybrid posts from the other campus still show when
  /// a campus filter is active.
  List<Post> get posts => _applyFilters(_allPosts);

  List<Post> _applyFilters(List<Post> source) {
    final filtered = source.where((p) {
      if (_typeFilter != null && p.type != _typeFilter) return false;
      if (_campusFilter != Campus.all) {
        final visible = p.campus == _campusFilter ||
            p.campus == Campus.all ||
            p.isHybrid;
        if (!visible) return false;
      }
      if (_missionOnly && _myMissions.isNotEmpty) {
        if (!p.missions.any(_myMissions.contains)) return false;
      }
      return true;
    }).toList();

    filtered.sort((a, b) {
      final at = a.startTime ?? DateTime(2100);
      final bt = b.startTime ?? DateTime(2100);
      return at.compareTo(bt);
    });
    return filtered;
  }

  int countByAuthor(String authorId) =>
      _allPosts.where((p) => p.authorId == authorId).length;

  Post? byId(String id) {
    for (final p in _allPosts) {
      if (p.id == id) return p;
    }
    return null;
  }

  Future<void> addPost(Post post) async {
    _userPosts.insert(0, post);
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_userPosts.map((p) => p.toJson()).toList());
    await prefs.setString(_kUserPosts, encoded);
  }
}
