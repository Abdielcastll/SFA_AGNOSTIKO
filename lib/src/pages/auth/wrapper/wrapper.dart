// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth/login/login_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation/navigation.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final orderActive = Provider.of<OrderProvider>(context);
    //TODO si existe user iniciar tennantApp aqui
    if (user == null) {
      return LoginPage();
    } else {
      if (orderActive.orderActive == false) {
        objectBox.delelteAllShoppingCart();
      }

      return StreamProvider<CurrentUserInfo?>.value(
        value: usersCollection
            .doc(user.uid)
            .snapshots()
            .map(AuthService().userDataFromsnapshot),
        initialData: CurrentUserInfo(
          name: '',
          dni: '',
          zone: '',
          zoneDocument: '',
          email: '',
          role: '',
          uid: '',
        ),
        catchError: (context, error) {
          print(error);
          return;
        },
        // builder: (context, child) {

        //   return NavigationPages();
        // });
        child: NavigationPages(),
      );
    }
  }
}
