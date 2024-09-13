// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class AppBarKiosko extends StatelessWidget implements PreferredSizeWidget {
  AppBarKiosko({
    Key? key,
    required this.message,
    required this.userZoneDocument,
  }) : super(key: key);

  final String message;
  final userZoneDocument;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return AppBar(
      foregroundColor: Colors.white,
      title: Text(
        message,
        style: TextStyle(
          letterSpacing: 0,
          fontSize: 26,
          fontFamily: 'Poppins-regular',
          fontWeight: FontWeight.w800,
        ),
      ),
      elevation: 0,
      leadingWidth: 24.0,
      backgroundColor: themeProvider.myTheme.colorScheme.primary,
    );
  }
}
