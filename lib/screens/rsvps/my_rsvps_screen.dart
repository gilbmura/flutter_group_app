import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../providers/feed_provider.dart';
import '../../providers/rsvp_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/opportunity_card.dart';
import '../detail/event_detail_screen.dart';

class MyRsvpsScreen extends StatelessWidget {
  const MyRsvpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My RSVPs'),
          bottom: const TabBar(
            indicatorColor: Color(0xFFF5B301),
            labelColor: Color(0xFFF5B301),
            tabs: [Tab(text: 'Going'), Tab(text: 'Interested')],
          ),
        ),
        body: TabBarView(children: [
          _RsvpList(going: true),
          _RsvpList(going: false),
        ]),
      ),
    );
  }
}

class _RsvpList extends StatelessWidget {
  final bool going;
  const _RsvpList({required this.going});

  @override
  Widget build(BuildContext context) {
    final feed = context.watch<FeedProvider>();
    final rsvp = context.watch<RsvpProvider>();
    final ids = going ? rsvp.goingIds : rsvp.interestedIds;
    final posts =
        ids.map(feed.byId).whereType<Post>().toList();

    if (posts.isEmpty) {
      return EmptyState(
        icon: going ? Icons.event_busy : Icons.bookmark_border,
        title: going ? 'No RSVPs yet' : 'Nothing saved yet',
        message: going
            ? 'Tap RSVP on an event and it will show up here.'
            : 'Mark events as Interested to keep an eye on them.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: posts.length,
      itemBuilder: (context, i) => OpportunityCard(
        post: posts[i],
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => EventDetailScreen(postId: posts[i].id)),
        ),
      ),
    );
  }
}
