import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/feed_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/opportunity_card.dart';
import '../../widgets/section_header.dart';
import '../detail/event_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final all = context.watch<FeedProvider>().posts;
    final q = _query.trim().toLowerCase();
    final results = q.isEmpty
        ? all
        : all
            .where((p) =>
                p.title.toLowerCase().contains(q) ||
                p.tags.any((t) => t.toLowerCase().contains(q)) ||
                p.authorName.toLowerCase().contains(q))
            .toList();

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
                hintText: 'Search opportunities, events, people...',
                prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 20),
            SectionHeader(
                title: q.isEmpty ? 'Recommended for you' : 'Results'),
            Expanded(
              child: results.isEmpty
                  ? const EmptyState(
                      icon: Icons.search_off,
                      title: 'No matches',
                      message: 'Try a different keyword or tag.',
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
