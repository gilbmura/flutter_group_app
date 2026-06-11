import 'campus.dart';

/// One model covers the three things people publish. Keeping them in one type
/// (with a discriminator) lets the feed mix them and filter cheaply.
enum PostType { event, opportunity, announcement }

extension PostTypeX on PostType {
  String get label {
    switch (this) {
      case PostType.event:
        return 'Event';
      case PostType.opportunity:
        return 'Opportunity';
      case PostType.announcement:
        return 'Announcement';
    }
  }
}

class Post {
  final String id;
  final PostType type;
  final String title;
  final String description;
  final String authorName;
  final String authorRole;
  final Campus campus;
  final String authorId;
  final DateTime createdAt;
  /// If true, students on the *other* campus can join remotely. This is the
  /// mechanism behind cross-campus RSVP — a Mauritius student joining a Kigali
  /// pitch night.
  final bool isHybrid;

  final DateTime? startTime;
  final DateTime? endTime;
  final String? location;
  final List<String> tags;

  /// Which Grand Challenges / missions this serves (drives mission-matching).
  final List<String> missions;
  final String? applyBy; // opportunities only

  // Mock social proof for the detail screen.
  final int goingCount;
  final int interestedCount;

  Post({
    required this.id,
    required this.authorId,
    required this.type,
    required this.title,
    required this.description,
    required this.authorName,
    required this.authorRole,
    required this.campus,
    this.isHybrid = false,
    this.startTime,
    this.endTime,
    this.location,
    this.tags = const [],
    this.missions = const [],
    this.applyBy,
    this.goingCount = 0,
    this.interestedCount = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
