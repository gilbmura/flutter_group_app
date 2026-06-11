import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/campus.dart';
import '../../models/community.dart';
import '../../providers/communities_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});
  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  bool _myClubsOnly = false;

  Future<void> _toggleJoin(Community c) async {
    final wasJoined = c.joined;
    await context.read<CommunitiesProvider>().toggleJoin(c.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(wasJoined ? 'Left ${c.name}' : 'Joined ${c.name}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final all = context.watch<CommunitiesProvider>().communities;
    final list =
        _myClubsOnly ? all.where((c) => c.joined).toList() : all;

    return Scaffold(
      appBar: AppBar(title: const Text('Communities')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Column(
          children: [
            Row(children: [
              _Tab(
                  label: 'All Clubs',
                  selected: !_myClubsOnly,
                  onTap: () => setState(() => _myClubsOnly = false)),
              const SizedBox(width: 8),
              _Tab(
                  label: 'My Clubs',
                  selected: _myClubsOnly,
                  onTap: () => setState(() => _myClubsOnly = true)),
            ]),
            const SizedBox(height: 16),
            Expanded(
              child: list.isEmpty
                  ? EmptyState(
                      icon: _myClubsOnly
                          ? Icons.diversity_3_outlined
                          : Icons.groups_outlined,
                      title: _myClubsOnly
                          ? 'No clubs joined yet'
                          : 'No communities',
                      message: _myClubsOnly
                          ? 'Browse All Clubs and join communities that match your interests.'
                          : 'Communities will appear here when available.',
                    )
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final c = list[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(children: [
                            CircleAvatar(
                              backgroundColor:
                                  c.campus.color.withOpacity(0.2),
                              child: Icon(Icons.diversity_3,
                                  color: c.campus.color),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  Text(
                                      '${c.members} members • ${c.campus.label}',
                                      style: const TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 12)),
                                  if (c.description.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(c.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: AppColors.textMuted,
                                              fontSize: 12)),
                                    ),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () => _toggleJoin(c),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: c.joined
                                    ? AppColors.success
                                    : AppColors.amber,
                                side: BorderSide(
                                    color: c.joined
                                        ? AppColors.success
                                        : AppColors.amber),
                              ),
                              child: Text(c.joined ? 'Joined' : 'Join'),
                            ),
                          ]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Tab(
      {required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.amber : AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
                color: selected ? AppColors.amber : AppColors.border),
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: selected
                      ? const Color(0xFF1A1300)
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
