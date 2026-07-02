import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationDisplay extends StatelessWidget {
  final NotificationModel? notification;

  const NotificationDisplay({super.key, this.notification});

  @override
  Widget build(BuildContext context) {
    if (notification == null) {
      return const Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text("Belum ada notifikasi", style: TextStyle(fontSize: 16)),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      color: notification!.color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(notification!.icon, color: notification!.color, size: 35),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification!.message,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: notification!.color,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "${notification!.timestamp.hour.toString().padLeft(2, '0')}:"
                    "${notification!.timestamp.minute.toString().padLeft(2, '0')}:"
                    "${notification!.timestamp.second.toString().padLeft(2, '0')}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
