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
  int index = 0;
  final screens = [
    const CataloguePage(),
    const DiaryTabs(),
    const ClientsPage(),
    const ProfilePage(),
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
            const TextStyle(
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
          animationDuration: const Duration(seconds: 1),
          selectedIndex: index,
          onDestinationSelected: (int i) {
            setState(() => index = i);
          },
          destinations: [
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
