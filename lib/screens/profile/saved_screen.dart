import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../providers/feed_provider.dart';
import '../../providers/rsvp_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/opportunity_card.dart';
import '../detail/event_detail_screen.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final feed = context.watch<FeedProvider>();
    final rsvp = context.watch<RsvpProvider>();
    final savedIds = rsvp.interestedIds;
    final posts = savedIds.map(feed.byId).whereType<Post>().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Items'),
      ),
      body: posts.isEmpty
          ? const EmptyState(
              icon: Icons.bookmark_border,
              title: 'Nothing saved yet',
              message: 'Mark events or opportunities as Interested to keep an eye on them.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: posts.length,
              itemBuilder: (context, i) => OpportunityCard(
                post: posts[i],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EventDetailScreen(postId: posts[i].id),
                  ),
                ),
              ),
            ),
    );
  }
}
