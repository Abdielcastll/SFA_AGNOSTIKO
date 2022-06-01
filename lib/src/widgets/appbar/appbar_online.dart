import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppBarOnline extends StatefulWidget {
  const AppBarOnline({Key? key}) : super(key: key);

  @override
  State<AppBarOnline> createState() => _AppBarOnlineState();
}

class _AppBarOnlineState extends State<AppBarOnline> {
  @override
  Widget build(BuildContext context) {
    // Extraer ruta actual mientras esta appbar se esta utilizando
    final String? route = ModalRoute.of(context)!.settings.name;
    print('Online - Ruta: $route');

    return AppBar(
      automaticallyImplyLeading: false,
      title: Container(
        padding: const EdgeInsets.only(top: 10),
        child: const Text('Online'),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF106cc8),
      actions: [
        Container(
          width: 120,
          padding: const EdgeInsets.only(top: 10, right: 10),
          // child: Image.asset('/images/apps2go.png'),
        ),
      ],
    );
  }
}
