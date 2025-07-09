import 'package:flutter/material.dart';
import '../logic/notifycation.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<NotificationItem>>(
      valueListenable: notifications,
      builder: (context, notificationList, child) {
        if (notificationList.isEmpty) {
          return const SizedBox.shrink();
        }

        return Positioned(
          top: 20,
          right: 20,
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: notificationList.map((notification) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: _buildNotificationCard(notification),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset((1 - value) * 300, 0),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Notification text
                  Flexible(
                    child: Text(
                      notification.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Close button
                  GestureDetector(
                    onTap: () => removeNotification(notification.id),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Alternative simpler notification widget that matches the original more closely
class SimpleNotification extends StatelessWidget {
  const SimpleNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<NotificationItem>>(
      valueListenable: notifications,
      builder: (context, notificationList, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: notificationList.map((notification) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.text,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => removeNotification(notification.id),
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}