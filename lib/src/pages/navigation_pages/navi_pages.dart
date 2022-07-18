// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/examples/profile_example.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/clients/clients_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/diary/diary_tabs.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/catalogue/catalogue_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/dashboard/dashboard_page.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';
import 'package:pwa_sales2go_flutter/src/widgets/bottom_decoratior.dart/bottom_decoration.dart';

class NaviPages extends StatefulWidget {
  const NaviPages({Key? key}) : super(key: key);

  @override
  State<NaviPages> createState() => _NaviPagesState();
}

class _NaviPagesState extends State<NaviPages> {
  int index = 0;
  final screens = [
    DashboardPage(),
    CataloguePage(),
    DiaryTabs(),
    ClientsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                ///////////////////////////////////// 1 ///////////////////////////////

                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined,
                      color: myTheme.colorScheme.tertiary),
                  selectedIcon: Icon(
                    Icons.dashboard_rounded,
                    color: Colors.white,
                  ),
                  label: 'Inicio',
                ),
                ///////////////////////////////////// 2 ///////////////////////////////

                NavigationDestination(
                  icon: Icon(
                    Icons.sell_outlined,
                    color: myTheme.colorScheme.tertiary,
                  ),
                  selectedIcon: Icon(
                    Icons.sell_rounded,
                    color: Colors.white,
                  ),
                  label: 'Catalogo',
                ),
                ///////////////////////////////////// 3 ///////////////////////////////

                NavigationDestination(
                  icon: Icon(
                    Icons.receipt_outlined,
                    color: myTheme.colorScheme.tertiary,
                  ),
                  selectedIcon: Icon(
                    Icons.receipt_rounded,
                    color: Colors.white,
                  ),
                  label: 'Agenda',
                ),
                ///////////////////////////////////// 4 ///////////////////////////////

                NavigationDestination(
                  icon: Icon(
                    Icons.store_outlined,
                    color: myTheme.colorScheme.tertiary,
                  ),
                  selectedIcon: Icon(
                    Icons.store_rounded,
                    color: Colors.white,
                  ),
                  label: 'Clientes',
                ),
                ///////////////////////////////////// 5 ///////////////////////////////

                NavigationDestination(
                  icon: Icon(
                    Icons.person_outline_rounded,
                    color: myTheme.colorScheme.tertiary,
                  ),
                  selectedIcon: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                  ),
                  label: 'Perfil',
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
