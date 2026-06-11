import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../providers/feed_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/opportunity_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/tag_chip.dart';
import '../detail/event_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _query = '';
  PostType? _typeFilter;

  @override
  Widget build(BuildContext context) {
    final all = context.watch<FeedProvider>().allPosts;
    final q = _query.trim().toLowerCase();
    var results = all;
    if (_typeFilter != null) {
      results = results.where((p) => p.type == _typeFilter).toList();
    }
    if (q.isNotEmpty) {
      results = results
          .where((p) =>
              p.title.toLowerCase().contains(q) ||
              p.tags.any((t) => t.toLowerCase().contains(q)) ||
              p.authorName.toLowerCase().contains(q) ||
              p.missions.any((m) => m.toLowerCase().contains(q)))
          .toList();
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Explore',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Search opportunities, events, missions...',
                prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  TagChip(
                    label: 'All',
                    selected: _typeFilter == null,
                    onTap: () => setState(() => _typeFilter = null),
                  ),
                  const SizedBox(width: 8),
                  TagChip(
                    label: 'Events',
                    selected: _typeFilter == PostType.event,
                    onTap: () =>
                        setState(() => _typeFilter = PostType.event),
                  ),
                  const SizedBox(width: 8),
                  TagChip(
                    label: 'Opportunities',
                    selected: _typeFilter == PostType.opportunity,
                    onTap: () =>
                        setState(() => _typeFilter = PostType.opportunity),
                  ),
                  const SizedBox(width: 8),
                  TagChip(
                    label: 'Announcements',
                    selected: _typeFilter == PostType.announcement,
                    onTap: () =>
                        setState(() => _typeFilter = PostType.announcement),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionHeader(
                title: q.isEmpty ? 'Recommended for you' : 'Results'),
            Expanded(
              child: results.isEmpty
                  ? const EmptyState(
                      icon: Icons.search_off,
                      title: 'No matches',
                      message:
                          'Try a different keyword, mission, or category.',
                    )
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, i) => OpportunityCard(
                        post: results[i],
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) =>
                                  EventDetailScreen(postId: results[i].id)),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
