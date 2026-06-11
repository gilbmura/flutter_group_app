class ChatMessage {
  final String id;
  final String senderName;
  final String text;
  final DateTime time;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.senderName,
    required this.text,
    required this.time,
    this.isMe = false,
  });
}

class Conversation {
  final String id;
  final String title;
  final int members;
  final List<ChatMessage> messages;

  Conversation({
    required this.id,
    required this.title,
    required this.members,
    required this.messages,
  });

  ChatMessage? get lastMessage => messages.isEmpty ? null : messages.last;
}
