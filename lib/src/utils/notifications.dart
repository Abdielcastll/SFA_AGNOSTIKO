import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:pwa_sales2go_flutter/src/services/cloud_functions.dart';
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
        title: data['titulo'] ?? '',
        body: data['descripcion'] ?? '',
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
/* Aqui se envia las notificaciones push a usuarios */
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
    roleNotificationRef!.child(notificationID).update({'leido': true});
    return userNotificationRef!.child(notificationID).update({'leido': true});
  }

  onListenNotifications(List<Notification>? event) {
    if (event == null) return;

    final notiAux = notifications;
    final newNots = <Notification>[];

    final notsToAdd = <Notification>[];

    for (var not in event) {
      if (not.read) continue;

      newNots.add(not);
    }

    for (var not in notiAux) {
      bool isNotPresent =
          newNots.where((oldElement) => oldElement.date == not.date).isEmpty;
      if (isNotPresent) {
        // add now
        notsToAdd.add(not);
      }
    }

    // newNots.addAll(notsToAdd);
    newNots.sort((not1, not2) => not2.date.compareTo(not1.date));

    notifications = newNots;

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

  sendNotificationToId(String subjectId, String title, [String? body]) async {
    sendNotification(subjectId, title, body ?? '');

    FirebaseDatabase database =
        FirebaseDatabase.instanceFor(app: multitenantConfig.tenantApp!);
    final notKey = DateTime.now().toIso8601String().split('.')[0];

    print({
      notKey: {"titulo": title, "descripcion": body ?? ''}
    });

    database.ref('notificaciones/$subjectId').set({
      notKey: {"titulo": title, "descripcion": body ?? ''}
    });
  }
}
