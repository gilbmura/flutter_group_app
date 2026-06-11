import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/chat.dart';
import '../../providers/chat_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';

class ChatRoomScreen extends StatefulWidget {
  final String conversationId;
  const ChatRoomScreen({super.key, required this.conversationId});
  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text;
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Type a message before sending')),
      );
      return;
    }
    context.read<ChatProvider>().sendMessage(widget.conversationId, text);
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final convo = context.watch<ChatProvider>().byId(widget.conversationId);
    if (convo == null) {
      return Scaffold(
        appBar: AppBar(),
        body: EmptyState(
          icon: Icons.chat_bubble_outline,
          title: 'Conversation not found',
          message: 'This chat may no longer be available.',
          actionLabel: 'Go back',
          onAction: () => Navigator.of(context).pop(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(convo.title, style: const TextStyle(fontSize: 16)),
            Text('${convo.members} members',
                style:
                    const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(16),
              itemCount: convo.messages.length,
              itemBuilder: (context, i) => _Bubble(msg: convo.messages[i]),
            ),
          ),
          _Composer(controller: _controller, onSend: _send),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final ChatMessage msg;
  const _Bubble({required this.msg});
  @override
  Widget build(BuildContext context) {
    final me = msg.isMe;
    return Align(
      alignment: me ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72),
        decoration: BoxDecoration(
          color: me ? AppColors.amber : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(me ? 16 : 4),
            bottomRight: Radius.circular(me ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!me)
              Text(msg.senderName,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.amberSoft)),
            Text(msg.text,
                style: TextStyle(
                    color:
                        me ? const Color(0xFF1A1300) : AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(DateFormat('h:mm a').format(msg.time),
                style: TextStyle(
                    fontSize: 10,
                    color: me
                        ? const Color(0xFF1A1300).withOpacity(0.6)
                        : AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const _Composer({required this.controller, required this.onSend});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: const InputDecoration(hintText: 'Type a message...'),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                  color: AppColors.amber, shape: BoxShape.circle),
              child: const Icon(Icons.send, color: Color(0xFF1A1300)),
            ),
          ),
        ]),
      ),
    );
  }
}
