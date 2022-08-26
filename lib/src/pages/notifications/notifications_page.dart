import 'package:flutter/material.dart';
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
      backgroundColor: Colors.white,
      body: notificationBody(),
    );
  }

  Widget notificationBody() {
    return SingleChildScrollView(
      child: Column(
        children: [],
      ),
    );
  }
}
