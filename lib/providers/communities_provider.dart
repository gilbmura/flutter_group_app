import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/community.dart';

/// Community join state with SharedPreferences persistence.
class CommunitiesProvider extends ChangeNotifier {
  List<Community> _communities = [];
  bool _loaded = false;

  static const _kJoined = 'communities_joined';

  bool get loaded => _loaded;
  List<Community> get communities => _communities;
  int get joinedCount => _communities.where((c) => c.joined).length;

  Future<void> load(List<Community> seed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final joined = (prefs.getStringList(_kJoined) ?? const []).toSet();
      _communities = seed
          .map((c) => c.copyWith(joined: joined.contains(c.id)))
          .toList();
    } catch (_) {
      _communities = List.of(seed);
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> toggleJoin(String id) async {
    final index = _communities.indexWhere((c) => c.id == id);
    if (index < 0) return;
    final c = _communities[index];
    _communities[index] = c.copyWith(
      joined: !c.joined,
      members: c.joined ? c.members - 1 : c.members + 1,
    );
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final joined =
        _communities.where((c) => c.joined).map((c) => c.id).toList();
    await prefs.setStringList(_kJoined, joined);
  }
}
