import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/utils/notifications.dart';

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationService>().notifications;

    return Stack(
      children: <Widget>[
        IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.of(context).pushNamed('notifications');
            }),
        if (notifications.where((e) => !e.read).isNotEmpty)
          Positioned(
            right: 11,
            top: 11,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(
                minWidth: 14,
                minHeight: 14,
              ),
            ),
          )
      ],
    );
  }
}
