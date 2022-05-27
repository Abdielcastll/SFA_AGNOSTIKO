// + AppBarWidget: se usa para cambiar el Appbar en caso de que haya
// un usuario conectado.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar_widgets/appbar_offline.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar_widgets/appbar_online.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tomar la instancia de firebase auth en caso de que haya un usuario
    // conectado.
    final User? firebaseGetAuth = FirebaseAuth.instance.currentUser;

    // Si hay un usuario conectado, se usara el AppbarOnline, en caso contrario,
    // se usara el AppbarOffline.

    if (firebaseGetAuth != null) {
      return AppBarOnline();
    } else {
      return AppBarOffline();
    }
  }
}
