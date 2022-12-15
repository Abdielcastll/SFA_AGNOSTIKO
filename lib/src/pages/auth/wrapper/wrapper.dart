// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth/login/login_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation/navigation.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final orderActive = Provider.of<OrderProvider>(context);

    if (user == null) {
      return LoginPage();
    } else {
      if (orderActive.orderActive == false) {
        objectBox.delelteAllShoppingCart();
      }
      return NavigationPages();
    }
  }
}
