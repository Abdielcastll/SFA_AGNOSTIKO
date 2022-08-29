// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/examples/notificacions_example.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/bottom_decoratior.dart/bottom_decoration.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomDecoration(),
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: Text(
          'Notificaciones',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            fontSize: 21,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        backgroundColor: myTheme.colorScheme.primary,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: NotificationsBody(),
    );
  }
}

class NotificationsBody extends StatefulWidget {
  const NotificationsBody({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationsBody> createState() => _NotificationsBodyState();
}

class _NotificationsBodyState extends State<NotificationsBody> {
  final List<NotificacionsExample> notifications = allNotifications;

  identifyTypeIcon(notificationType) {
    if (notificationType == 'pedido') {
      return Icons.shopping_cart_outlined;
    } else if (notificationType == 'visita') {
      return Icons.calendar_today_outlined;
    }
  }

  identifyStatusColor(notificationStatus) {
    if (notificationStatus == 'Completada') {
      return Colors.green;
    } else if (notificationStatus == 'Pendiente') {
      return Colors.orange;
    } else if (notificationStatus == 'Cancelada') {
      return Colors.red;
    }
  }

  identifyStatusBGColor(notificationStatus) {
    if (notificationStatus == 'Completada') {
      return Colors.green.shade100;
    } else if (notificationStatus == 'Pendiente') {
      return Colors.orange.shade100;
    } else if (notificationStatus == 'Cancelada') {
      return Colors.red.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: notifications.length,
              itemBuilder: (BuildContext context, index) {
                final notification = notifications[index];
                return Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: ListTile(
                    leading: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: identifyStatusBGColor(notification.status),
                      ),
                      child: Icon(
                        identifyTypeIcon(
                          notification.type,
                        ),
                        size: 20,
                        color: identifyStatusColor(notification.status),
                      ),
                    ),
                    title: Text(notification.message),
                    subtitle: Row(
                      children: [
                        Text(notification.brand),
                        notification.place == null
                            ? Text('')
                            : Text('- ${notification.place}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
