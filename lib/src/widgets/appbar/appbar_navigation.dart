// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/place_oder_page.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class AppBarNavigation extends StatelessWidget implements PreferredSizeWidget {
  AppBarNavigation({
    Key? key,
    required this.message,
    required this.isOrderActive,
  }) : super(key: key);

  final _auth = AuthService();
  final String message;
  final bool isOrderActive;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        message,
        style: TextStyle(
          letterSpacing: 0,
          fontSize: 22,
          fontFamily: 'Poppins-regular',
        ),
      ),
      elevation: 0,
      leadingWidth: 24.0,
      backgroundColor: myTheme.colorScheme.primary,
      actions: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 16, 8),
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
            isOrderActive
                ? Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 16, 8),
                    child: IconButton(
                      constraints: const BoxConstraints(),
                      splashRadius: 20.0,
                      icon: const Icon(Icons.shopping_cart_rounded, size: 24),
                      // Redireccion al flujo de realizar nuevos pedidos
                      onPressed: () {
                        Navigator.popUntil(
                            context, ModalRoute.withName("ORDER"));
                      },
                    ),
                  )
                : Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 16, 8),
                    child: IconButton(
                      constraints: const BoxConstraints(),
                      splashRadius: 20.0,
                      icon: const Icon(MdiIcons.cartOutline, size: 24),
                      // Redireccion al flujo de realizar nuevos pedidos
                      onPressed: () {
                        objectBox.delelteAllShoppingCart();
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
