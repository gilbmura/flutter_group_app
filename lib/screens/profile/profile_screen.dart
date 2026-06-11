import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../models/campus.dart';
import '../../providers/auth_provider.dart';
import '../../providers/rsvp_provider.dart';
import '../../theme/app_theme.dart';
import '../communities/communities_screen.dart';
import '../rsvps/my_rsvps_screen.dart';

/// Profile leads with the leadership footprint (events organized, attended,
/// communities led) — reflecting ALU's leadership-first culture, not vanity
/// follower counts.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final attended = context.watch<RsvpProvider>().goingIds.length;
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
                onPressed: () {},
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
                  color: AppColors.amber.withValues(alpha: 0.18),
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
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Stat(value: '${user.eventsOrganized}', label: 'Organized'),
                _divider(),
                _Stat(value: '$attended', label: 'Attending'),
                _divider(),
                _Stat(value: '${user.communitiesLed}', label: 'Leading'),
              ],
            ),
          ),
          if (user.missions.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text('My missions',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: user.missions
                  .map((m) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(m,
                            style: const TextStyle(
                                color: AppColors.amber,
                                fontWeight: FontWeight.w600)),
                      ))
                  .toList(),
            ),
          ],
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
          _MenuItem(icon: Icons.bookmark_border, label: 'Saved', onTap: () {}),
          _MenuItem(
              icon: Icons.notifications_none,
              label: 'Notifications',
              onTap: () {}),
          _MenuItem(
              icon: Icons.help_outline, label: 'Help & Support', onTap: () {}),
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
