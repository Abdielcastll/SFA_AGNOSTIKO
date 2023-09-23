import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/utils/multitenant-config.dart';

class Notification {
  String id;
  String title;
  String body;
  DateTime date;
  bool read;
  String? icon;

  Notification(
      {required this.title,
      required this.id,
      required this.body,
      this.icon,
      required this.date,
      this.read = false});

  factory Notification.fromJson(Map<dynamic, dynamic> data, String date) {
    return Notification(
        id: date,
        title: data['titulo'],
        body: data['descripcion'],
        date: DateTime.parse(date),
        read: data['leido'] ?? false);
  }
}

class NotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  StreamSubscription<DatabaseEvent>? _notificacionStreamSubscription;
  StreamSubscription? roleNotificationStream;
  StreamSubscription? userNotificationStream;

  DatabaseReference? roleNotificationRef;
  DatabaseReference? userNotificationRef;

  final AndroidNotificationChannel _channel = const AndroidNotificationChannel(
    'field_sales_notifications', // id
    'Field Sales Notificationes', // title
    description: 'Notification channel for Field Sales.', // description
    importance: Importance.max,
  );

  List<Notification> notifications = [];

  initialize(String userID) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('agn');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseDatabase database =
        FirebaseDatabase.instanceFor(app: multitenantConfig.tenantApp!);

    DatabaseReference notificationsRef = database.ref('notificaciones/$userID');

    print('notificationsGroupId $userID');

    if (_notificacionStreamSubscription != null) return;

    _notificacionStreamSubscription =
        notificationsRef.onChildAdded.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      print('notificationData $data');
      final notification = Notification.fromJson(data, event.snapshot.key!);

      if (!notification.read) {
        showNotification(notification);
      }
    });

    usersCollection.doc(userID).get().then((value) {
      final userData = AuthService().userDataFromsnapshot(value);

      userNotificationRef = database.ref('notificaciones/${userData.uid}');
      roleNotificationRef = database.ref('notificaciones/${userData.role}');

      roleNotificationStream = streamNotificationsGroupId(userData.uid)
          .listen(onListenNotifications);

      userNotificationStream = streamNotificationsGroupId(userData.role)
          .listen(onListenNotifications);
    });
  }

  Future markNotificationAsRead(String notificationID) {
    return roleNotificationRef!.child(notificationID).update({'leido': true});
  }

  onListenNotifications(List<Notification>? event) {
    final notiAux = notifications;

    for (var not in notiAux) {
      if (event?.firstWhereOrNull((element) => element.date == not.date) !=
          null) {
        continue;
      }

      event?.add(not);
    }

    event?.sort((not1, not2) => not2.date.compareTo(not1.date));

    notifications = event ?? [];

    print("onlistenNoti ${notifications}");

    notifyListeners();
  }

  Stream<List<Notification>?> streamNotificationsGroupId(String groupId) {
    FirebaseDatabase database =
        FirebaseDatabase.instanceFor(app: multitenantConfig.tenantApp!);

    return database.ref('notificaciones/$groupId').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      print('notificationData $data');
      final notifications = data?.entries
          .map((e) => Notification.fromJson(e.value, e.key))
          .sorted((a, b) => b.date.compareTo(a.date))
          .toList();

      return notifications;
    });
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
