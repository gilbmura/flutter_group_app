import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks which posts the user is Going to / Interested in, and persists them
/// so RSVPs survive an app restart. A post can be in exactly one state.
class RsvpProvider extends ChangeNotifier {
  final Set<String> _going = {};
  final Set<String> _interested = {};

  static const _kGoing = 'rsvp_going';
  static const _kInterested = 'rsvp_interested';

  List<String> get goingIds => _going.toList();
  List<String> get interestedIds => _interested.toList();

  bool isGoing(String id) => _going.contains(id);
  bool isInterested(String id) => _interested.contains(id);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _going
      ..clear()
      ..addAll(prefs.getStringList(_kGoing) ?? const []);
    _interested
      ..clear()
      ..addAll(prefs.getStringList(_kInterested) ?? const []);
    notifyListeners();
  }

  Future<void> toggleGoing(String id) async {
    if (_going.contains(id)) {
      _going.remove(id);
    } else {
      _going.add(id);
      _interested.remove(id); // mutually exclusive states
    }
    await _persist();
    notifyListeners();
  }

  Future<void> toggleInterested(String id) async {
    if (_interested.contains(id)) {
      _interested.remove(id);
    } else {
      _interested.add(id);
      _going.remove(id);
    }
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kGoing, _going.toList());
    await prefs.setStringList(_kInterested, _interested.toList());
  }
}
