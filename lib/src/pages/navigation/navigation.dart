// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/catalogue_page_kiosko.dart';
import 'package:pwa_sales2go_flutter/src/pages/profile/profile_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/catalogue_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/diary_tabs.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/utils/notifications.dart';

class NavigationPages extends StatelessWidget {
  const NavigationPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screens = [
      if (globalRemoteConfig.visualizacionCatalogo == true)
        const CataloguePage(),
      const DiaryTabs(),
      if (globalRemoteConfig.clientesEnabled == true) const ClientsPage(),
      const ProfilePage(),
    ];

    CounterLimitFirestore counterLimitFirestore =
        Provider.of<CounterLimitFirestore>(context);
    CurrentUserInfo user = Provider.of<CurrentUserInfo>(context);
    NotificationService notificationService =
        context.watch<NotificationService>();

    if (user.role != null && user.role != '') {
      notificationService.initialize(user.uid);
    }

    if (globalRemoteConfig.conversionKiosko == true) {
      return Scaffold(
        body: const CataloguePageKiosko(),
      );
    } else {
      return Scaffold(
        body: IndexedStack(
          index: counterLimitFirestore.currentScreen,
          children: screens,
        ),
        // screens[index],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: myTheme.colorScheme.tertiary.withOpacity(0.2),
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 196, 196, 196),

                // color: Colors.white,
                fontFamily: 'Poppins-regular',
              ),
            ),
          ),
          child: NavigationBar(
            height: 56.0,
            backgroundColor: myTheme.colorScheme.primary,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            animationDuration: const Duration(seconds: 1),
            selectedIndex: counterLimitFirestore.currentScreen,
            onDestinationSelected: (int i) {
              counterLimitFirestore.setNewScreen(i);
            },
            destinations: [
              if (globalRemoteConfig.visualizacionCatalogo == true)
                NavigationDestination(
                  icon: Icon(
                    Icons.sell_outlined,
                    // color: myTheme.colorScheme.background,
                    size: 24,
                    color: Color.fromARGB(255, 196, 196, 196),
                  ),
                  selectedIcon: Icon(
                    Icons.sell,
                    // color: myTheme.colorScheme.background,
                    size: 24,
                    color: Color.fromARGB(255, 196, 196, 196),
                  ),
                  label: AppLocalizations.of(context)!.home,
                ),
              NavigationDestination(
                icon: Icon(
                  Icons.calendar_today_outlined,
                  // color: myTheme.colorScheme.background,
                  size: 24,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                selectedIcon: Icon(
                  Icons.calendar_today,
                  // color: myTheme.colorScheme.background,
                  size: 24,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                label: AppLocalizations.of(context)!.diary,
              ),
              if (globalRemoteConfig.clientesEnabled == true)
                NavigationDestination(
                  icon: Icon(
                    Icons.store_outlined,
                    // color: myTheme.colorScheme.background,
                    size: 24,
                    color: Color.fromARGB(255, 196, 196, 196),
                  ),
                  selectedIcon: Icon(
                    Icons.store,
                    // color: myTheme.colorScheme.background,
                    size: 24,
                    color: Color.fromARGB(255, 196, 196, 196),
                  ),
                  label: AppLocalizations.of(context)!.clients,
                ),
              NavigationDestination(
                icon: Icon(
                  Icons.person_outline,
                  // color: myTheme.colorScheme.background,
                  size: 24,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                selectedIcon: Icon(
                  Icons.person_outline,
                  // color: myTheme.colorScheme.background,
                  size: 24,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                label: AppLocalizations.of(context)!.profile,
              ),
            ],
          ),
        ),
      );
    }
  }
}
