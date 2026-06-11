import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/chat.dart';
import '../../providers/chat_provider.dart';
import '../../theme/app_theme.dart';
import 'chat_room_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final convos = context.watch<ChatProvider>().conversations;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chats',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: convos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, i) => _ChatTile(convo: convos[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final Conversation convo;
  const _ChatTile({required this.convo});
  @override
  Widget build(BuildContext context) {
    final last = convo.lastMessage;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.amber.withValues(alpha: 0.18),
        child: const Icon(Icons.groups, color: AppColors.amber),
      ),
      title: Text(convo.title,
          style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(
        last == null ? 'No messages yet' : '${last.senderName}: ${last.text}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColors.textMuted),
      ),
      trailing: last == null
          ? null
          : Text(DateFormat('h:mm a').format(last.time),
              style:
                  const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => ChatRoomScreen(conversationId: convo.id)),
      ),
    );
  }
}
