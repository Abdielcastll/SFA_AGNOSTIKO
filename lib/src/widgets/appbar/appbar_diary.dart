// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/place_oder_page.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class AppBarDiary extends StatelessWidget implements PreferredSizeWidget {
  const AppBarDiary({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(110);

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
          'Tu Agenda',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => PlaceOrderPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
      bottom: DiaryTabBar(),
    );
  }
}

class DiaryTabBar extends StatelessWidget implements PreferredSizeWidget {
  const DiaryTabBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      splashBorderRadius: BorderRadius.circular(20),
      splashFactory: InkSplash.splashFactory,

      labelColor: Colors.white,
      indicatorColor: myTheme.colorScheme.secondary,
      unselectedLabelColor: Colors.grey.shade400,
      indicatorWeight: 3,
      indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
      indicatorSize: TabBarIndicatorSize.tab,
      // isScrollable: true,
      // ignore: prefer_const_literals_to_create_immutables
      tabs: [
        Tab(text: 'Visitas'),
        Tab(text: 'Pedidos'),
        Tab(text: 'Facturas'),
      ],
    );
  }
}
