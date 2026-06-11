import 'campus.dart';

/// Who may post what. The brief explicitly asks "who should be allowed to post
/// opportunities" — we answer it in the type system, not just the UI.
enum UserRole { student, organizer }

extension UserRoleX on UserRole {
  String get label =>
      this == UserRole.organizer ? 'Organizer / Club Leader' : 'Student';
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final Campus campus;
  final UserRole role;

  /// ALU students declare a mission / Grand Challenge they care about.
  /// We use these to personalise the feed.
  final List<String> missions;

  // Leadership footprint — ALU culture is leadership-first, so the profile
  // leads with contribution, not vanity follower counts.
  final int eventsOrganized;
  final int communitiesLed;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.campus,
    required this.role,
    this.missions = const [],
    this.eventsOrganized = 0,
    this.communitiesLed = 0,
  });

  /// Single source of truth for the posting permission gate.
  bool get canPostOpportunities => role == UserRole.organizer;

  String get initials {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  AppUser copyWith({List<String>? missions}) => AppUser(
        id: id,
        name: name,
        email: email,
        campus: campus,
        role: role,
        missions: missions ?? this.missions,
        eventsOrganized: eventsOrganized,
        communitiesLed: communitiesLed,
      );
}
