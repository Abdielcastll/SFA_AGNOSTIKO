// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/place_oder_page.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class AppBarNavigation extends StatelessWidget implements PreferredSizeWidget {
  AppBarNavigation({
    Key? key,
    required this.message,
  }) : super(key: key);

  final _auth = AuthService();
  final String message;

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      title: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w300,
            fontFamily: 'Poppins-regular',
          ),
        ),
      ),
      elevation: 0,
      backgroundColor: myTheme.colorScheme.primary,
      actions: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: IconButton(
                constraints: const BoxConstraints(),
                splashRadius: 20.0,
                icon: const Icon(MdiIcons.bellOutline, size: 25),
                // Redireccionar a la pantalla de notificaciones
                onPressed: () {
                  Navigator.pushNamed(context, 'notifications');
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: IconButton(
                constraints: const BoxConstraints(),
                splashRadius: 20.0,
                icon: const Icon(MdiIcons.cartOutline, size: 25),
                // Redireccion al flujo de realizar nuevos pedidos
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => PlaceOrderPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
