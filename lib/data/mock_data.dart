import '../models/campus.dart';
import '../models/community.dart';
import '../models/chat.dart';
import '../models/post.dart';

/// Static seed data so the app is fully functional with no backend.
/// All dates are relative to "now" so the feed never looks stale during a demo.
class MockData {
  static final DateTime _now = DateTime.now();

  /// The ALU Grand Challenges / mission areas students can tag themselves with.
  static const List<String> missions = [
    'Education',
    'Healthcare',
    'Climate & Energy',
    'Governance',
    'Conservation & Wildlife',
    'Cities & Infrastructure',
  ];

  static List<Post> posts() => [
        Post(
          id: 'p1',
          type: PostType.event,
          title: 'AI for Social Impact Workshop',
          description:
              'Learn how AI tools can be used to drive social impact across '
              'Africa. Hands-on session plus group projects with mentors from '
              'both campuses.',
          authorName: 'Tech & Innovation Hub',
          authorRole: 'Organizer / Club Leader',
          campus: Campus.mauritius,
          isHybrid: true,
          startTime: _now.add(const Duration(days: 3, hours: 2)),
          endTime: _now.add(const Duration(days: 3, hours: 6)),
          location: 'Innovation Lab + Live stream',
          tags: ['Workshop', 'Tech', 'AI'],
          missions: ['Education', 'Healthcare'],
          goingCount: 48,
          interestedCount: 12,
        ),
        Post(
          id: 'p2',
          type: PostType.event,
          title: 'ALU Entrepreneurship Pitch Night',
          description:
              'Showcase your idea, get feedback, and connect with mentors and '
              'investors. Open to founders from Kigali and Mauritius.',
          authorName: 'Entrepreneurship Club',
          authorRole: 'Organizer / Club Leader',
          campus: Campus.kigali,
          isHybrid: true,
          startTime: _now.add(const Duration(days: 6, hours: 5)),
          endTime: _now.add(const Duration(days: 6, hours: 8)),
          location: 'Kigali Campus Auditorium',
          tags: ['Entrepreneurship', 'Pitch'],
          missions: ['Cities & Infrastructure', 'Governance'],
          goingCount: 92,
          interestedCount: 31,
        ),
        Post(
          id: 'p3',
          type: PostType.opportunity,
          title: 'Sustainable Solutions Challenge',
          description:
              'A cross-campus hackathon tackling climate resilience. Form a '
              'team, build a prototype in 48 hours, win seed funding.',
          authorName: 'Climate Action Society',
          authorRole: 'Organizer / Club Leader',
          campus: Campus.mauritius,
          isHybrid: true,
          startTime: _now.add(const Duration(days: 10)),
          location: 'Mauritius Campus',
          tags: ['Competition', 'Hackathon'],
          missions: ['Climate & Energy', 'Conservation & Wildlife'],
          applyBy: 'Apply by ${_fmt(_now.add(const Duration(days: 8)))}',
          goingCount: 24,
          interestedCount: 40,
        ),
        Post(
          id: 'p4',
          type: PostType.opportunity,
          title: 'Campus Ambassador Program',
          description:
              'Represent ALU, lead campus initiatives, and build your '
              'leadership portfolio. Great for students who love community '
              'building.',
          authorName: 'Student Life Office',
          authorRole: 'Academic Team',
          campus: Campus.all,
          isHybrid: true,
          tags: ['Leadership', 'Program'],
          missions: ['Education', 'Governance'],
          applyBy: 'Apply by ${_fmt(_now.add(const Duration(days: 14)))}',
          goingCount: 18,
          interestedCount: 55,
        ),
        Post(
          id: 'p5',
          type: PostType.announcement,
          title: 'Library extended hours during exams',
          description:
              'The Kigali library will stay open until midnight for the next '
              'two weeks. Bring your student ID.',
          authorName: 'Aline Umuhoza',
          authorRole: 'Student',
          campus: Campus.kigali,
          startTime: _now.add(const Duration(days: 1)),
          tags: ['Campus', 'Notice'],
        ),
        Post(
          id: 'p6',
          type: PostType.event,
          title: 'Community Clean-Up Drive',
          description:
              'Join fellow students to clean and green the campus surroundings. '
              'Gloves and refreshments provided.',
          authorName: 'Women in Leadership',
          authorRole: 'Organizer / Club Leader',
          campus: Campus.mauritius,
          startTime: _now.add(const Duration(days: 4, hours: 3)),
          location: 'Mauritius Campus Grounds',
          tags: ['Community', 'Volunteer'],
          missions: ['Conservation & Wildlife'],
          goingCount: 33,
          interestedCount: 9,
        ),
      ];

  static List<Community> communities() => const [
        Community(
          id: 'c1',
          name: 'ALU Debate Society',
          members: 124,
          campus: Campus.kigali,
          description: 'Sharpen your argument and public speaking skills.',
        ),
        Community(
          id: 'c2',
          name: 'Entrepreneurship Club',
          members: 250,
          campus: Campus.all,
          description: 'For builders, founders, and intrapreneurs.',
          joined: true,
        ),
        Community(
          id: 'c3',
          name: 'Women in Leadership',
          members: 180,
          campus: Campus.mauritius,
          description: 'Mentorship and leadership development.',
        ),
        Community(
          id: 'c4',
          name: 'Tech & Innovation Hub',
          members: 210,
          campus: Campus.all,
          description: 'Hackathons, workshops, and build sessions.',
        ),
      ];

  static List<Conversation> conversations() {
    final base = DateTime.now();
    return [
      Conversation(
        id: 'g1',
        title: 'AI Workshop Group',
        members: 32,
        messages: [
          ChatMessage(
            id: 'm1',
            senderName: 'Fatima',
            text: 'Hey team! Don\'t forget our session tomorrow at 9am. '
                'See you there!',
            time: base.subtract(const Duration(hours: 3)),
          ),
          ChatMessage(
            id: 'm2',
            senderName: 'David',
            text: 'Got it! I\'ll bring my laptop.',
            time: base.subtract(const Duration(hours: 2, minutes: 50)),
          ),
          ChatMessage(
            id: 'm3',
            senderName: 'You',
            text: 'Can\'t wait!',
            time: base.subtract(const Duration(hours: 2, minutes: 40)),
            isMe: true,
          ),
        ],
      ),
      Conversation(
        id: 'g2',
        title: 'Entrepreneurship Club',
        members: 250,
        messages: [
          ChatMessage(
            id: 'm4',
            senderName: 'David',
            text: 'Don\'t forget the meeting on Friday.',
            time: base.subtract(const Duration(hours: 6)),
          ),
        ],
      ),
      Conversation(
        id: 'g3',
        title: 'Travel Buddies (Kigali ↔ Mauritius)',
        members: 18,
        messages: [
          ChatMessage(
            id: 'm5',
            senderName: 'Sarah',
            text: 'Any updates on the cross-campus trip?',
            time: base.subtract(const Duration(days: 1)),
          ),
        ],
      ),
    ];
  }

  static String _fmt(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}
