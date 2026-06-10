import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/campus.dart';
import '../../models/post.dart';
import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/rsvp_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/campus_chip.dart';
import '../../widgets/primary_button.dart';

class EventDetailScreen extends StatelessWidget {
  final String postId;
  const EventDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final post = context.watch<FeedProvider>().byId(postId);
    if (post == null) {
      return const Scaffold(body: Center(child: Text('Post not found')));
    }
    final rsvp = context.watch<RsvpProvider>();
    final auth = context.watch<AuthProvider>();
    final going = rsvp.isGoing(post.id);
    final interested = rsvp.isInterested(post.id);

    // Cross-campus nudge: tell remote students they can join a hybrid event.
    final crossCampus = auth.user != null &&
        post.isHybrid &&
        post.campus != Campus.all &&
        post.campus != auth.user!.campus;

    return Scaffold(
      appBar: AppBar(title: Text(post.type.label)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              gradient: LinearGradient(
                colors: [
                  post.campus.color.withOpacity(0.6),
                  AppColors.amber.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
                child: Icon(Icons.groups, size: 64, color: Colors.white)),
          ),
          const SizedBox(height: 16),
          Text(post.title,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final t in post.tags)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(t, style: const TextStyle(fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 14),
          CampusChip(campus: post.campus, hybrid: post.isHybrid),
          if (crossCampus) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.amber.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Row(children: [
                Icon(Icons.travel_explore, color: AppColors.amber, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Hosted on another campus — you can join this one remotely.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ]),
            ),
          ],
          const SizedBox(height: 18),
          if (post.startTime != null)
            _MetaRow(
              icon: Icons.schedule,
              text: DateFormat('EEEE, MMM d • h:mm a').format(post.startTime!) +
                  (post.endTime != null
                      ? ' - ${DateFormat('h:mm a').format(post.endTime!)}'
                      : ''),
            ),
          if (post.location != null)
            _MetaRow(icon: Icons.place, text: post.location!),
          if (post.applyBy != null)
            _MetaRow(icon: Icons.event_available, text: post.applyBy!),
          _MetaRow(icon: Icons.person, text: 'Posted by ${post.authorName}'),
          const SizedBox(height: 18),
          const Text('About',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(post.description,
              style: const TextStyle(
                  color: AppColors.textMuted, height: 1.5, fontSize: 14)),
          const SizedBox(height: 18),
          Row(children: [
            _Stat(value: '${post.goingCount + (going ? 1 : 0)}', label: 'going'),
            const SizedBox(width: 24),
            _Stat(
                value: '${post.interestedCount + (interested ? 1 : 0)}',
                label: 'interested'),
          ]),
          const SizedBox(height: 24),
          PrimaryButton(
            label: going ? '✓ You\'re going' : 'RSVP',
            onPressed: () async {
              await context.read<RsvpProvider>().toggleGoing(post.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(going
                          ? 'RSVP removed'
                          : 'You\'re going to "${post.title}"')),
                );
              }
            },
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: interested ? '✓ Interested' : 'Interested',
            outlined: true,
            onPressed: () =>
                context.read<RsvpProvider>().toggleInterested(post.id),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaRow({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Icon(icon, size: 18, color: AppColors.amber),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(color: AppColors.textMuted)),
    ]);
  }
}
