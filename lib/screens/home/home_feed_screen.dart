import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

/// Home feed. Uses ListView (not CustomScrollView) so content renders reliably
/// inside the AppShell IndexedStack.
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
    final userPosts = feed.userPosts;
    final posts = feed.posts;

    final showFeatured = feed.campusFilter == Campus.all &&
        feed.typeFilter == null &&
        !feed.missionOnly;
    final featured = showFeatured
        ? feed.allPosts.where((p) => p.type == PostType.event).take(2).toList()
        : <Post>[];
    final pinnedIds = {
      ...userPosts.map((p) => p.id),
      ...featured.map((p) => p.id),
    };
    final feedRest = posts.where((p) => !pinnedIds.contains(p.id)).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
            decoration: BoxDecoration(
              gradient: AppDecorations.backgroundGlow,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.border.withOpacity(0.6)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi, $firstName 👋',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5)),
                      const SizedBox(height: 4),
                      const Text("What's happening across ALU today?",
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 14)),
                    ],
                  ),
                ),
                _Avatar(user: user),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: _CampusToggle(
              value: feed.campusFilter,
              onChanged: feed.setCampus,
            ),
          ),

          SizedBox(
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
                    onTap: () {
                      final missions = user?.missions ?? const [];
                      if (missions.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Add missions on your Profile to use this filter.',
                            ),
                          ),
                        );
                        return;
                      }
                      feed.toggleMissionOnly();
                    }),
              ],
            ),
          ),

          if (userPosts.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: SectionHeader(
                title: 'Your posts',
                actionLabel: '${userPosts.length}',
              ),
            ),
            ...userPosts.map(
              (p) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OpportunityCard(
                  post: p,
                  onTap: () => _open(context, p),
                ),
              ),
            ),
          ],

          if (featured.length >= 2) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: SectionHeader(title: 'Featured'),
            ),
            ...featured.map(
              (p) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _FeaturedCard(
                  post: p,
                  onTap: () => _open(context, p),
                ),
              ),
            ),
          ],

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: SectionHeader(
              title: 'Your feed',
              actionLabel: 'My RSVPs',
              onAction: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MyRsvpsScreen()),
              ),
            ),
          ),

          if (posts.isEmpty && userPosts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: EmptyState(
                icon: Icons.filter_alt_off,
                title: 'Nothing here yet',
                message:
                    'No posts match these filters. Tap All campus and All '
                    'type chips above to see everything.',
              ),
            )
          else if (feedRest.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'All matching posts are shown above.',
                style: TextStyle(color: AppColors.textMuted),
              ),
            )
          else
            ...feedRest.map(
              (p) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OpportunityCard(
                  post: p,
                  onTap: () => _open(context, p),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;
  const _FeaturedCard({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateStr = post.startTime != null
        ? DateFormat('EEE, MMM d • h:mm a').format(post.startTime!)
        : 'Soon';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          gradient: LinearGradient(
            colors: [
              post.campus.color.withOpacity(0.7),
              AppColors.amber.withOpacity(0.45),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(post.type.label,
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 8),
                  Text(post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(dateStr,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.85), fontSize: 12)),
                ],
              ),
            ),
            if (post.isHybrid)
              const Positioned(
                top: 12,
                right: 12,
                child: Icon(Icons.travel_explore,
                    color: Colors.white70, size: 20),
              ),
          ],
        ),
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
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
