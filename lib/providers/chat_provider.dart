import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/chat.dart';

/// Minimal local chat state. Sending a message appends to the conversation and
/// notifies listeners so the room and the chat list both update.
class ChatProvider extends ChangeNotifier {
  final List<Conversation> _conversations;
  ChatProvider(List<Conversation> seed) : _conversations = List.of(seed);

  List<Conversation> get conversations => _conversations;

  Conversation? byId(String id) {
    for (final c in _conversations) {
      if (c.id == id) return c;
    }
    return null;
  }

  void sendMessage(String conversationId, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final convo = byId(conversationId);
    if (convo == null) return;
    convo.messages.add(
      ChatMessage(
        id: const Uuid().v4(),
        senderName: 'You',
        text: trimmed,
        time: DateTime.now(),
        isMe: true,
      ),
    );
    notifyListeners();
  }
}
