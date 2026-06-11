import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../models/campus.dart';
import '../../models/post.dart';
import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/opportunity_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/tag_chip.dart';
import '../detail/event_detail_screen.dart';
import '../rsvps/my_rsvps_screen.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  void _open(BuildContext context, Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EventDetailScreen(postId: post.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final feed = context.watch<FeedProvider>();
    final user = auth.user;
    final firstName = (user?.name ?? 'there').split(' ').first;
    final posts = feed.posts;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hi, $firstName 👋',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w800)),
                        const Text("What's happening across ALU today?",
                            style: TextStyle(color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  _Avatar(user: user),
                ],
              ),
            ),
          ),

          // Cross-campus toggle — a defining feature of the app.
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: _CampusToggle(
                value: feed.campusFilter,
                onChanged: feed.setCampus,
              ),
            ),
          ),

          // Type filters + mission-only toggle.
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                children: [
                  TagChip(
                      label: 'All',
                      selected: feed.typeFilter == null,
                      onTap: () => feed.setType(null)),
                  const SizedBox(width: 8),
                  TagChip(
                      label: 'Events',
                      selected: feed.typeFilter == PostType.event,
                      onTap: () => feed.setType(PostType.event)),
                  const SizedBox(width: 8),
                  TagChip(
                      label: 'Opportunities',
                      selected: feed.typeFilter == PostType.opportunity,
                      onTap: () => feed.setType(PostType.opportunity)),
                  const SizedBox(width: 8),
                  TagChip(
                      label: 'Announcements',
                      selected: feed.typeFilter == PostType.announcement,
                      onTap: () => feed.setType(PostType.announcement)),
                  const SizedBox(width: 16),
                  TagChip(
                      label: '✨ For my mission',
                      selected: feed.missionOnly,
                      onTap: feed.toggleMissionOnly),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: SectionHeader(
                title: 'Your feed',
                actionLabel: 'My RSVPs',
                onAction: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MyRsvpsScreen()),
                ),
              ),
            ),
          ),

          if (posts.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(
                icon: Icons.filter_alt_off,
                title: 'Nothing here yet',
                message:
                    'No posts match these filters. Try switching campus or '
                    'clearing the mission filter.',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => OpportunityCard(
                    post: posts[i],
                    onTap: () => _open(context, posts[i]),
                  ),
                  childCount: posts.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}

class _CampusToggle extends StatelessWidget {
  final Campus value;
  final ValueChanged<Campus> onChanged;
  const _CampusToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget seg(Campus c, String label) {
      final selected = value == c;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(c),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.amber : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    selected ? const Color(0xFF1A1300) : AppColors.textMuted,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        seg(Campus.all, 'All'),
        seg(Campus.kigali, 'Kigali'),
        seg(Campus.mauritius, 'Mauritius'),
      ]),
    );
  }
}

class _Avatar extends StatelessWidget {
  final AppUser? user;
  const _Avatar({this.user});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.amber.withOpacity(0.18),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.amber, width: 1.5),
      ),
      child: Text(user?.initials ?? '?',
          style: const TextStyle(
              color: AppColors.amber, fontWeight: FontWeight.w800)),
    );
  }
}
