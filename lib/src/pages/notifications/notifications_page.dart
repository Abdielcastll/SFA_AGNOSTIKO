import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/notifications.dart' as not;

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final notifications =
        context.watch<not.NotificationService>().notifications;

    print("NotificationsPage $notifications");

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: const Text(
          'Notificaciones',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            fontSize: 21,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: themeProvider.myTheme.colorScheme.primary,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: NotificationsBody(notifications: notifications),
    );
  }
}

class NotificationsBody extends StatelessWidget {
  final List<not.Notification> notifications;
  const NotificationsBody({Key? key, required this.notifications})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: notifications.length,
              itemBuilder: (BuildContext context, index) {
                final notification = notifications[index];
                return NotificationTile(
                  notification: notification,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final not.Notification notification;
  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    not.NotificationService notificationService =
        context.watch<not.NotificationService>();
    return GestureDetector(
        onTap: () =>
            notificationService.markNotificationAsRead(notification.id),
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: ListTile(
            title: Text(notification.title),
            subtitle: Row(
              children: [
                Text(notification.body),
              ],
            ),
          ),
        ));
  }
}
