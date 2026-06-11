import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/app_user.dart';
import '../models/campus.dart';

/// Holds the signed-in user and persists the session with SharedPreferences,
/// so a user stays "logged in" across app launches (mock auth, real persistence).
class AuthProvider extends ChangeNotifier {
  AppUser? _user;
  bool _loaded = false;

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get loaded => _loaded;

  static const _kId = 'user_id';
  static const _kName = 'user_name';
  static const _kEmail = 'user_email';
  static const _kCampus = 'user_campus';
  static const _kRole = 'user_role';
  static const _kMissions = 'user_missions';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_kName);
    if (name != null) {
      _user = AppUser(
        id: prefs.getString(_kId) ?? 'me',
        name: name,
        email: prefs.getString(_kEmail) ?? '',
        campus: Campus.values[prefs.getInt(_kCampus) ?? 0],
        role: UserRole.values[prefs.getInt(_kRole) ?? 0],
        missions: prefs.getStringList(_kMissions) ?? const [],
      );
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> signIn({
    required String name,
    required String email,
    required Campus campus,
    required UserRole role,
    required List<String> missions,
  }) async {
    final user = AppUser(
      id: const Uuid().v4(),
      name: name.trim().isEmpty ? 'ALU Student' : name.trim(),
      email: email.trim(),
      campus: campus,
      role: role,
      missions: missions,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kId, user.id);
    await prefs.setString(_kName, user.name);
    await prefs.setString(_kEmail, user.email);
    await prefs.setInt(_kCampus, user.campus.index);
    await prefs.setInt(_kRole, user.role.index);
    await prefs.setStringList(_kMissions, user.missions);
    _user = user;
    notifyListeners();
  }

  Future<void> updateMissions(List<String> missions) async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kMissions, missions);
    _user = _user!.copyWith(missions: missions);
    notifyListeners();
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    for (final k in [_kId, _kName, _kEmail, _kCampus, _kRole, _kMissions]) {
      await prefs.remove(k);
    }
    _user = null;
    notifyListeners();
  }
}
