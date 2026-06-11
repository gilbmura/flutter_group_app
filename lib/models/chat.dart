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

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderName': senderName,
        'text': text,
        'time': time.toIso8601String(),
        'isMe': isMe,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        senderName: json['senderName'] as String,
        text: json['text'] as String,
        time: DateTime.parse(json['time'] as String),
        isMe: json['isMe'] as bool? ?? false,
      );
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
