import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar_widgets/appbar_offline.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar_widgets/appbar_online.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final route = ModalRoute.of(context)!.settings.name;
    final User? firebaseGetAuth = FirebaseAuth.instance.currentUser;
    // print(route);
    if (firebaseGetAuth != null) {
      return AppBarOnline();
    }
    return AppBarOffline();
  }
}
