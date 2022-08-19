// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth/login/login_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation/navigation.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if (user == null) {
      return LoginPage();
    } else {
      // print('instancia de user detectada');
      // print(user);
      // print('/////////////////////////////////////////////////');
      // print('Data in shared preferences');
      // print(sharedPreferences!.getString('uid'));
      // print(sharedPreferences!.getString('email'));
      // print(sharedPreferences!.getString('nombre'));
      // print(sharedPreferences!.getInt('nro_cedula'));
      // print(sharedPreferences!.getStringList('indice'));
      // print(sharedPreferences!.getString('cargo'));
      // print('/////////////////////////////////////////////////');
      return NavigationPages();
    }
  }
}
