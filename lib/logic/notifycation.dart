import 'dart:async';
import 'package:flutter/foundation.dart';

class NotificationItem {
  final int id;
  final String text;

  const NotificationItem({
    required this.id,
    required this.text,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationItem &&
        other.id == id &&
        other.text == text;
  }

  @override
  int get hashCode => id.hashCode ^ text.hashCode;
}

final ValueNotifier<List<NotificationItem>> notifications =
ValueNotifier<List<NotificationItem>>([]);

void addNotification(String text, int duration) {
  final id = (DateTime.now().millisecondsSinceEpoch * 1000 +
      (DateTime.now().microsecond ~/ 1000)) % 1000000;

  notifications.value = [
    ...notifications.value,
    NotificationItem(id: id, text: text)
  ];

  if (duration > 0) {
    Timer(Duration(milliseconds: duration), () {
      removeNotification(id);
    });
  }
}

void removeNotification(int id) {
  notifications.value = notifications.value
      .where((x) => x.id != id)
      .toList();
}