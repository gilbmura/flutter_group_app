import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/notification_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../chats/chat_room_screen.dart';
import '../detail/event_detail_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final notifications = provider.notifications;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [
            if (notifications.isNotEmpty) ...[
              IconButton(
                icon: const Icon(Icons.done_all),
                tooltip: 'Mark all as read',
                onPressed: () {
                  provider.markAllAsRead();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All marked as read')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Clear all',
                onPressed: () {
                  provider.clearAll();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All notifications cleared')),
                  );
                },
              ),
            ]
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.amber,
            labelColor: AppColors.amber,
            unselectedLabelColor: AppColors.textMuted,
            tabs: [
              Tab(text: 'Inbox'),
              Tab(text: 'Settings'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _InboxTab(provider: provider),
            const _SettingsTab(),
          ],
        ),
      ),
    );
  }
}

class _InboxTab extends StatelessWidget {
  final NotificationProvider provider;
  const _InboxTab({required this.provider});

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.event:
        return Icons.event;
      case NotificationType.opportunity:
        return Icons.work_outline;
      case NotificationType.chat:
        return Icons.chat_bubble_outline;
      case NotificationType.system:
        return Icons.notifications_none;
    }
  }

  Color _getIconColor(NotificationType type) {
    switch (type) {
      case NotificationType.event:
        return AppColors.amber;
      case NotificationType.opportunity:
        return AppColors.kigali;
      case NotificationType.chat:
        return AppColors.mauritius;
      case NotificationType.system:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = provider.notifications;
    if (list.isEmpty) {
      return const EmptyState(
        icon: Icons.notifications_off_outlined,
        title: 'All caught up!',
        message: 'No new notifications right now. Check back later!',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final n = list[i];
        final timeStr = _formatTime(n.time);

        return Dismissible(
          key: Key(n.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.danger.withOpacity(0.8),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            provider.clearNotification(n.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Notification dismissed'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    // Undo is a nice mock UX addition.
                  },
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: n.isRead ? AppColors.surface.withOpacity(0.6) : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: n.isRead ? AppColors.border.withOpacity(0.5) : AppColors.border,
                width: n.isRead ? 1 : 1.5,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Stack(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: _getIconColor(n.type).withOpacity(0.12),
                    child: Icon(_getIcon(n.type), color: _getIconColor(n.type)),
                  ),
                  if (!n.isRead)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.amber,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      n.title,
                      style: TextStyle(
                        fontWeight: n.isRead ? FontWeight.w600 : FontWeight.w800,
                        fontSize: 15,
                        color: n.isRead ? AppColors.textPrimary.withOpacity(0.8) : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    timeStr,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  n.description,
                  style: TextStyle(
                    color: n.isRead ? AppColors.textMuted.withOpacity(0.8) : AppColors.textMuted,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ),
              onTap: () {
                provider.markAsRead(n.id);
                if (n.relatedId != null) {
                  if (n.type == NotificationType.chat) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatRoomScreen(conversationId: n.relatedId!),
                      ),
                    );
                  } else if (n.type == NotificationType.event || n.type == NotificationType.opportunity) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EventDetailScreen(postId: n.relatedId!),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return DateFormat('MMM d').format(time);
    }
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Push Notifications',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.amber),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Allow Push Notifications'),
                subtitle: const Text('Get real-time updates for activities'),
                value: provider.pushNotifications,
                activeColor: AppColors.amber,
                onChanged: (val) => provider.setPushNotifications(val),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Email Notifications',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.amber),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Email Digests'),
                subtitle: const Text('Receive summary of missed activities'),
                value: provider.emailDigests,
                activeColor: AppColors.amber,
                onChanged: (val) => provider.setEmailDigests(val),
              ),
              const Divider(height: 1, color: AppColors.border),
              SwitchListTile(
                title: const Text('Weekly Digest'),
                subtitle: const Text('Weekly campus updates and events'),
                value: provider.weeklyDigest,
                activeColor: AppColors.amber,
                onChanged: (val) => provider.setWeeklyDigest(val),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: Text(
            'ALU Intercampus Connect v1.0.0',
            style: TextStyle(color: AppColors.textMuted.withOpacity(0.5), fontSize: 12),
          ),
        )
      ],
    );
  }
}
