// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/profile/profile_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/catalogue_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/diary_tabs.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class NavigationPages extends StatefulWidget {
  const NavigationPages({Key? key}) : super(key: key);

  @override
  State<NavigationPages> createState() => _NavigationPagesState();
}

class _NavigationPagesState extends State<NavigationPages> {
  final ValueNotifier<String> currentCoin = ValueNotifier<String>('VED');
  int index = 0;
  final screens = [
    CataloguePage(
      listOfPrices: 'GENER-03',
      isOrderActive: false,
    ),
    DiaryTabs(),
    ClientsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: currentCoin,
      builder: (BuildContext context, String value, Widget? child) {
        return Scaffold(
          body: screens[index],
          bottomNavigationBar: Stack(
            children: [
              NavigationBarTheme(
                data: NavigationBarThemeData(
                  indicatorColor: myTheme.colorScheme.tertiary.withOpacity(0.2),
                  labelTextStyle: MaterialStateProperty.all(
                    TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Poppins-regular',
                    ),
                  ),
                ),
                child: NavigationBar(
                  height: 56.0,
                  backgroundColor: myTheme.colorScheme.primary,
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
            ],
          ),
        );
      },
    );
  }
}
