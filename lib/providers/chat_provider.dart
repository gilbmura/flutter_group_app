import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/chat.dart';

/// Local chat state with message persistence across app restarts.
class ChatProvider extends ChangeNotifier {
  final List<Conversation> _conversations;
  bool _loaded = false;

  static const _kExtraMessages = 'chat_extra_messages';

  ChatProvider(List<Conversation> seed)
      : _conversations = seed
            .map((c) => Conversation(
                  id: c.id,
                  title: c.title,
                  members: c.members,
                  messages: List.of(c.messages),
                ))
            .toList();

  bool get loaded => _loaded;
  List<Conversation> get conversations => _conversations;

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kExtraMessages);
      if (raw != null) {
        final extras = jsonDecode(raw) as List<dynamic>;
        for (final item in extras) {
          final map = item as Map<String, dynamic>;
          final convoId = map['conversationId'] as String;
          final msg = ChatMessage.fromJson(
              map['message'] as Map<String, dynamic>);
          final convo = byId(convoId);
          convo?.messages.add(msg);
        }
      }
    } catch (_) {
      // Keep seed messages if persistence fails.
    }
    _loaded = true;
    notifyListeners();
  }

  Conversation? byId(String id) {
    for (final c in _conversations) {
      if (c.id == id) return c;
    }
    return null;
  }

  Future<void> sendMessage(String conversationId, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final convo = byId(conversationId);
    if (convo == null) return;
    final msg = ChatMessage(
      id: const Uuid().v4(),
      senderName: 'You',
      text: trimmed,
      time: DateTime.now(),
      isMe: true,
    );
    convo.messages.add(msg);
    await _persistMessage(conversationId, msg);
    notifyListeners();
  }

  Future<void> _persistMessage(
      String conversationId, ChatMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kExtraMessages);
    final list = raw == null
        ? <dynamic>[]
        : List<dynamic>.from(jsonDecode(raw) as List<dynamic>);
    list.add({
      'conversationId': conversationId,
      'message': message.toJson(),
    });
    await prefs.setString(_kExtraMessages, jsonEncode(list));
  }
}
