import 'package:flutter/foundation.dart';

enum NotificationType { event, opportunity, chat, system }

class AppNotification {
  final String id;
  final String title;
  final String description;
  final DateTime time;
  final NotificationType type;
  final String? relatedId; // e.g. postId or chatId
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    this.relatedId,
    this.isRead = false,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? time,
    NotificationType? type,
    String? relatedId,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      type: type ?? this.type,
      relatedId: relatedId ?? this.relatedId,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationProvider extends ChangeNotifier {
  final List<AppNotification> _notifications = [];

  bool _pushNotifications = true;
  bool _emailDigests = false;
  bool _weeklyDigest = true;

  NotificationProvider() {
    _loadMockNotifications();
  }

  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  bool get pushNotifications => _pushNotifications;
  bool get emailDigests => _emailDigests;
  bool get weeklyDigest => _weeklyDigest;

  void _loadMockNotifications() {
    final now = DateTime.now();
    _notifications.addAll([
      AppNotification(
        id: 'n1',
        title: 'Pitch Night is starting soon!',
        description: 'ALU Entrepreneurship Pitch Night is starting on Kigali Campus in 1 hour. Join in person or online.',
        time: now.subtract(const Duration(minutes: 25)),
        type: NotificationType.event,
        relatedId: 'p2',
      ),
      AppNotification(
        id: 'n2',
        title: 'New message in AI Workshop Group',
        description: 'Fatima: "Hey team! Don\'t forget our session tomorrow at 9am. See you there!"',
        time: now.subtract(const Duration(hours: 2)),
        type: NotificationType.chat,
        relatedId: 'g1',
      ),
      AppNotification(
        id: 'n3',
        title: 'New Opportunity on campus',
        description: 'Sustainable Solutions Challenge has been posted. Apply before the deadline.',
        time: now.subtract(const Duration(hours: 6)),
        type: NotificationType.opportunity,
        relatedId: 'p3',
      ),
      AppNotification(
        id: 'n4',
        title: 'Welcome to ALU Intercampus Connect',
        description: 'You\'re all set to discover events, join cross-campus clubs, and connect with peers!',
        time: now.subtract(const Duration(days: 2)),
        type: NotificationType.system,
      ),
    ]);
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    bool changed = false;
    for (var n in _notifications) {
      if (!n.isRead) {
        n.isRead = true;
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }

  void clearNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearAll() {
    if (_notifications.isNotEmpty) {
      _notifications.clear();
      notifyListeners();
    }
  }

  void setPushNotifications(bool value) {
    _pushNotifications = value;
    notifyListeners();
  }

  void setEmailDigests(bool value) {
    _emailDigests = value;
    notifyListeners();
  }

  void setWeeklyDigest(bool value) {
    _weeklyDigest = value;
    notifyListeners();
  }
}
