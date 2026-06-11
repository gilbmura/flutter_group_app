import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/mock_data.dart';
import '../../models/app_user.dart';
import '../../models/campus.dart';
import '../../providers/auth_provider.dart';
import '../../providers/communities_provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/rsvp_provider.dart';
import '../../theme/app_theme.dart';
import '../communities/communities_screen.dart';
import '../rsvps/my_rsvps_screen.dart';

/// Profile leads with the leadership footprint — contribution over vanity metrics.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showInfo(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(title),
        content: Text(body, style: const TextStyle(color: AppColors.textMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _editMissions(BuildContext context, AppUser user) async {
    final selected = Set<String>.from(user.missions);
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 20, 20, 20 + MediaQuery.of(ctx).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('My missions',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  const Text(
                    'Pick the Grand Challenges you care about. This powers the '
                    '"For my mission" feed filter.',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: MockData.missions.map((m) {
                      final sel = selected.contains(m);
                      return FilterChip(
                        label: Text(m),
                        selected: sel,
                        onSelected: (_) => setModalState(() {
                          sel ? selected.remove(m) : selected.add(m);
                        }),
                        selectedColor: AppColors.amber,
                        backgroundColor: AppColors.surfaceAlt,
                        labelStyle: TextStyle(
                            color: sel
                                ? const Color(0xFF1A1300)
                                : AppColors.textPrimary),
                        checkmarkColor: const Color(0xFF1A1300),
                        side: const BorderSide(color: AppColors.border),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    if (saved != true || !context.mounted) return;
    final missions = selected.toList();
    await context.read<AuthProvider>().updateMissions(missions);
    if (!context.mounted) return;
    context.read<FeedProvider>().setMyMissions(missions);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Missions updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final attended = context.watch<RsvpProvider>().goingIds.length;
    final organized = user == null
        ? 0
        : context.watch<FeedProvider>().countByAuthor(user.id);
    final communities =
        context.watch<CommunitiesProvider>().joinedCount;
    if (user == null) return const SizedBox.shrink();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => _showInfo(
                  context,
                  'Account settings',
                  'This prototype uses mock authentication. In a production '
                  'build, settings would link to ALU SSO, notification '
                  'preferences, and privacy controls.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Column(children: [
              Container(
                width: 88,
                height: 88,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.amber.withOpacity(0.18),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.amber, width: 2),
                ),
                child: Text(user.initials,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.amber)),
              ),
              const SizedBox(height: 12),
              Text(user.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800)),
              Text('${user.role.label} • ${user.campus.label} Campus',
                  style: const TextStyle(color: AppColors.textMuted)),
            ]),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: AppDecorations.card(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Stat(value: '$organized', label: 'Organized'),
                _divider(),
                _Stat(value: '$attended', label: 'Attending'),
                _divider(),
                _Stat(value: '$communities', label: 'Communities'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('My missions',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              TextButton(
                onPressed: () => _editMissions(context, user),
                child: const Text('Edit'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (user.missions.isEmpty)
            GestureDetector(
              onTap: () => _editMissions(context, user),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  'Tap to add missions and personalize your feed.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: user.missions
                  .map((m) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.amber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(m,
                            style: const TextStyle(
                                color: AppColors.amber,
                                fontWeight: FontWeight.w600)),
                      ))
                  .toList(),
            ),
          const SizedBox(height: 24),
          _MenuItem(
              icon: Icons.event,
              label: 'My RSVPs',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const MyRsvpsScreen()))),
          _MenuItem(
              icon: Icons.diversity_3,
              label: 'My Communities',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const CommunitiesScreen()))),
          _MenuItem(
              icon: Icons.bookmark_border,
              label: 'Saved',
              onTap: () => _showInfo(
                    context,
                    'Saved items',
                    'Bookmarking is planned for a future release. For now, '
                    'use RSVPs and community joins to track what matters.',
                  )),
          _MenuItem(
              icon: Icons.notifications_none,
              label: 'Notifications',
              onTap: () => _showInfo(
                    context,
                    'Notifications',
                    'Push notifications for new events on your campus and '
                    'mission would be delivered via Firebase in production.',
                  )),
          _MenuItem(
              icon: Icons.help_outline,
              label: 'Help & Support',
              onTap: () => _showInfo(
                    context,
                    'Help & Support',
                    'Contact your campus student success team or email '
                    'support@alu.education for account issues.',
                  )),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => context.read<AuthProvider>().signOut(),
            icon: const Icon(Icons.logout, color: AppColors.danger),
            label: const Text('Sign out',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 32, color: AppColors.border);
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
      Text(label, style: const TextStyle(color: AppColors.textMuted)),
    ]);
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem(
      {required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, color: AppColors.amber),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: onTap,
    );
  }
}
