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

  /// Set for user-created posts so profile stats can count them.
  final String? authorId;
  final Campus campus;

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
    required this.type,
    required this.title,
    required this.description,
    required this.authorName,
    required this.authorRole,
    this.authorId,
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
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.index,
        'title': title,
        'description': description,
        'authorName': authorName,
        'authorRole': authorRole,
        'authorId': authorId,
        'campus': campus.index,
        'isHybrid': isHybrid,
        'startTime': startTime?.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'location': location,
        'tags': tags,
        'missions': missions,
        'applyBy': applyBy,
        'goingCount': goingCount,
        'interestedCount': interestedCount,
      };

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'] as String,
        type: PostType.values[json['type'] as int],
        title: json['title'] as String,
        description: json['description'] as String,
        authorName: json['authorName'] as String,
        authorRole: json['authorRole'] as String,
        authorId: json['authorId'] as String?,
        campus: Campus.values[json['campus'] as int],
        isHybrid: json['isHybrid'] as bool? ?? false,
        startTime: json['startTime'] != null
            ? DateTime.parse(json['startTime'] as String)
            : null,
        endTime: json['endTime'] != null
            ? DateTime.parse(json['endTime'] as String)
            : null,
        location: json['location'] as String?,
        tags: (json['tags'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        missions: (json['missions'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        applyBy: json['applyBy'] as String?,
        goingCount: json['goingCount'] as int? ?? 0,
        interestedCount: json['interestedCount'] as int? ?? 0,
      );
}
