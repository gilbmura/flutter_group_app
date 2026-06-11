import 'package:flutter/foundation.dart';
import '../models/campus.dart';
import '../models/post.dart';

/// Owns the list of posts and all the discovery filters. The UI just reads
/// `posts` (the computed, filtered+sorted view) and flips filters via setters —
/// classic single-source-of-truth state handling.
class FeedProvider extends ChangeNotifier {
  final List<Post> _posts;
  FeedProvider(List<Post> seed) : _posts = List.of(seed);

  PostType? _typeFilter; // null == all types
  Campus _campusFilter = Campus.all;
  bool _missionOnly = false;
  List<String> _myMissions = const [];

  PostType? get typeFilter => _typeFilter;
  Campus get campusFilter => _campusFilter;
  bool get missionOnly => _missionOnly;

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

  /// The visible feed. Note the cross-campus rule: when a campus is selected,
  /// hybrid posts from the *other* campus still show, because remote students
  /// can join them.
  List<Post> get posts {
    final filtered = _posts.where((p) {
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

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  List<Post> myPosts(String userId) {
    final mine = _posts.where((post) => post.authorId == userId).toList();
    mine.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return mine;
  }

  Post? byId(String id) {
    for (final p in _posts) {
      if (p.id == id) return p;
    }
    return null;
  }

  void addPost(Post post) {
    _posts.insert(0, post);
    notifyListeners();
  }
}


