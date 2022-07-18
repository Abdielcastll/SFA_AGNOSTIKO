// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/search/search_delegate.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class AppBarProducts extends StatelessWidget implements PreferredSizeWidget {
  const AppBarProducts({
    Key? key,
  }) : super(key: key);

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
          'Productos',
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: myTheme.colorScheme.secondary,
      actions: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              constraints: const BoxConstraints(),
              splashRadius: 20.0,
              icon: const Icon(Icons.add_shopping_cart_rounded, size: 25),
              onPressed: () {
                print('New order button pressed');
                // redireccion a nueva orden
              },
            ),
          ],
        )
      ],
    );
  }
}
