import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pwa_sales2go_flutter/src/utils/multitenant-config.dart';

class Notification {
  String title;
  String body;
  String? icon;

  Notification({required this.title, required this.body, this.icon});

  factory Notification.fromJson(Map<dynamic, dynamic> data) {
    return Notification(title: data['title'], body: data['body']);
  }
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  StreamSubscription<DatabaseEvent>? _notificacionStreamSubscription;

  final AndroidNotificationChannel _channel = const AndroidNotificationChannel(
    'field_sales_notifications', // id
    'Field Sales Notificationes', // title
    description: 'Notification channel for Field Sales.', // description
    importance: Importance.max,
  );

  initialize(String notificationsGroupId) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('agn');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseDatabase database =
        FirebaseDatabase.instanceFor(app: multitenantConfig.tenantApp!);

    DatabaseReference notificationsRef =
        database.ref('notificaciones/$notificationsGroupId');

    print('notificationsGroupId $notificationsGroupId');

    if (_notificacionStreamSubscription != null) return;

    _notificacionStreamSubscription =
        notificationsRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      print('notificationData $data');
      final notification = Notification.fromJson(data.values.last);

      showNotification(notification);
    });

    /* FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        showNotification(
            notification.title, notification.body, android.smallIcon);
      }
    }); */
  }

  showNotification(Notification notification) async {
    _flutterLocalNotificationsPlugin.show(
        Random().nextInt(999),
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            icon: notification.icon,
            priority: Priority.max,
            importance: Importance.max,
            // other properties...
          ),
        ));
  }
}

/* registerDeviceToUser(String userId) async {
  final deviceToken = await FirebaseMessaging.instance.getToken(
      vapidKey:
          'BDq3VPxu0XinNqDIvfq252EsxPNO89Ns74fEtfRYiGxIYnwqXw3i6dRBL9J1zEI--alE2-7IjShWMJY5qHnq9Rw');
  print('deviceToken $deviceToken');

  final dispositivosRef =
      usuariosRef.doc(userId).collection('dispositivos').doc('dispositivos');

  final dispotivosSnapshot = await dispositivosRef.get();

  try {
    final List<String> tokens = dispotivosSnapshot.get('tokens');

    if (tokens.contains(deviceToken!)) return;

    tokens.add(deviceToken);

    await dispositivosRef.update({'tokens': tokens});
  } catch (err) {
    dispositivosRef.set({
      'tokens': [deviceToken]
    });
  }
} */

final notificationService = NotificationService();
