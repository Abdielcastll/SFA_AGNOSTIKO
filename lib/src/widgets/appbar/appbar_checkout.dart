// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class AppBarCheckout extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCheckout({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return AppBar(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(
      //     bottom: Radius.circular(20),
      //   ),
      // ),
      title: Text(
        'Checkout',
        style: TextStyle(
          fontFamily: 'Poppins-regular',
          fontSize: 21,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
      backgroundColor: themeProvider.myTheme.colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    );
  }
}
