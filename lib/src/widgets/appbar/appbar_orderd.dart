// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppBarOrder extends StatelessWidget implements PreferredSizeWidget {
  const AppBarOrder({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return AppBar(
      foregroundColor: Colors.white,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(
      //     bottom: Radius.circular(20),
      //   ),
      // ),
      automaticallyImplyLeading: false,
      title: Text(
        AppLocalizations.of(context)!.order,
        style: TextStyle(
          fontFamily: 'Poppins-regular',
          fontSize: 21,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
      backgroundColor: themeProvider.myTheme.colorScheme.primary,
      elevation: 0,
    );
  }
}
