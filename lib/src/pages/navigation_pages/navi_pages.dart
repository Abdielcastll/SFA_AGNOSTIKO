// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/cart/cart_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/catalogue/catalogue_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/clients/clients_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/dashboard/dashboard_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/records/records_tabs.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/bottom_decoration.dart';

class NaviPages extends StatefulWidget {
  const NaviPages({Key? key}) : super(key: key);

  @override
  State<NaviPages> createState() => _NaviPagesState();
}

class _NaviPagesState extends State<NaviPages> {
  int index = 0;
  final screens = [
    DashboardPage(),
    ClientsPage(),
    CataloguePage(),
    CartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHome(
        backgroundColor: myTheme.colorScheme.secondary,
        title: 'SFA Agnostiko',
      ),
      body: screens[index],
      bottomNavigationBar: Stack(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: Colors.white.withOpacity(0.2),
              labelTextStyle: MaterialStateProperty.all(
                TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            child: NavigationBar(
              height: 56.0,
              backgroundColor: myTheme.colorScheme.secondary,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              animationDuration: Duration(seconds: 2),
              selectedIndex: index,
              onDestinationSelected: (int i) {
                setState(() => index = i);
              },
              // ignore: prefer_const_literals_to_create_immutables
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined,
                      color: myTheme.colorScheme.tertiary),
                  selectedIcon: Icon(
                    Icons.dashboard_rounded,
                    color: Colors.white,
                  ),
                  label: 'Inicio',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.storefront_outlined,
                    color: myTheme.colorScheme.tertiary,
                  ),
                  selectedIcon: Icon(
                    Icons.storefront_rounded,
                    color: Colors.white,
                  ),
                  label: 'Clientes',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    color: myTheme.colorScheme.tertiary,
                  ),
                  selectedIcon: Icon(
                    Icons.shopping_bag_rounded,
                    color: Colors.white,
                  ),
                  label: 'Catalogo',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: myTheme.colorScheme.tertiary,
                  ),
                  selectedIcon: Icon(
                    Icons.shopping_cart_rounded,
                    color: Colors.white,
                  ),
                  label: 'Carrito',
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 56.0),
            child: BottomDecoration(),
          ),
        ],
      ),
    );
  }
}
