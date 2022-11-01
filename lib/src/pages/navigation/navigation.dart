// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/profile/profile_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/catalogue_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/diary_tabs.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar: NavigationBarTheme(
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
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          animationDuration: Duration(seconds: 1),
          selectedIndex: index,
          onDestinationSelected: (int i) {
            setState(() => index = i);
          },
          // ignore: prefer_const_literals_to_create_immutables
          destinations: [
            ///////////////////////////////////// 1 ///////////////////////////////

            NavigationDestination(
              icon: Icon(
                Icons.sell_outlined,
                color: myTheme.colorScheme.background,
                size: 24,
              ),
              selectedIcon: Icon(
                Icons.sell,
                color: myTheme.colorScheme.background,
                size: 24,
              ),
              label: AppLocalizations.of(context)!.home,
            ),
            ///////////////////////////////////// 2 ///////////////////////////////

            NavigationDestination(
              icon: Icon(
                Icons.calendar_today_outlined,
                color: myTheme.colorScheme.background,
                size: 24,
              ),
              selectedIcon: Icon(
                Icons.calendar_today,
                color: myTheme.colorScheme.background,
                size: 24,
              ),
              label: AppLocalizations.of(context)!.diary,
            ),
            ///////////////////////////////////// 3 ///////////////////////////////

            NavigationDestination(
              icon: Icon(
                Icons.store_outlined,
                color: myTheme.colorScheme.background,
                size: 24,
              ),
              selectedIcon: Icon(
                Icons.store,
                color: myTheme.colorScheme.background,
                size: 24,
              ),
              label: AppLocalizations.of(context)!.clients,
            ),
            ///////////////////////////////////// 4 ///////////////////////////////

            NavigationDestination(
              icon: Icon(
                Icons.person_outline,
                color: myTheme.colorScheme.background,
                size: 24,
              ),
              selectedIcon: Icon(
                Icons.person_outline,
                color: myTheme.colorScheme.background,
                size: 24,
              ),
              label: AppLocalizations.of(context)!.profile,
            ),
          ],
        ),
      ),
    );
  }
}
