// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/clients.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class AppBarPlaceOrder extends StatelessWidget implements PreferredSizeWidget {
  const AppBarPlaceOrder({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Nuevo Pedido',
        style: TextStyle(
          fontFamily: 'Poppins-regular',
          fontSize: 21,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
      backgroundColor: myTheme.colorScheme.primary,
      elevation: 0,
    );
  }
}
