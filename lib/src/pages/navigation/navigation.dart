// ignore_for_file: prefer_const_constructors

import 'package:agnostiko/device/src/device.dart';
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

  Future<DeviceType> _getDeviceType() async {
    return await getDeviceType();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return FutureBuilder<DeviceType>(
      future: _getDeviceType(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading spinner while waiting for the device type
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle any errors
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Once we have the device type, we can build the screens
          final deviceType = snapshot.data;

          final screens = [
            if (globalRemoteConfig.visualizacionCatalogo == true)
              const CataloguePage(),
            const DiaryTabs(),
            if (globalRemoteConfig.clientesEnabled == true) const ClientsPage(),
            if (deviceType != DeviceType.PINPAD) const ProfilePage(),
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
              bottomNavigationBar: NavigationBarTheme(
                data: NavigationBarThemeData(
                  indicatorColor: themeProvider.myTheme.colorScheme.tertiary
                      .withOpacity(0.2),
                  labelTextStyle: MaterialStateProperty.all(
                    const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 196, 196, 196),
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                ),
                child: NavigationBar(
                  height: 56.0,
                  backgroundColor: themeProvider.myTheme.colorScheme.primary,
                  labelBehavior:
                      NavigationDestinationLabelBehavior.onlyShowSelected,
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
                          size: 24,
                          color: Color.fromARGB(255, 196, 196, 196),
                        ),
                        selectedIcon: Icon(
                          Icons.sell,
                          size: 24,
                          color: Color.fromARGB(255, 196, 196, 196),
                        ),
                        label: AppLocalizations.of(context)!.home,
                      ),
                    NavigationDestination(
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        size: 24,
                        color: Color.fromARGB(255, 196, 196, 196),
                      ),
                      selectedIcon: Icon(
                        Icons.calendar_today,
                        size: 24,
                        color: Color.fromARGB(255, 196, 196, 196),
                      ),
                      label: AppLocalizations.of(context)!.diary,
                    ),
                    if (globalRemoteConfig.clientesEnabled == true)
                      NavigationDestination(
                        icon: Icon(
                          Icons.store_outlined,
                          size: 24,
                          color: Color.fromARGB(255, 196, 196, 196),
                        ),
                        selectedIcon: Icon(
                          Icons.store,
                          size: 24,
                          color: Color.fromARGB(255, 196, 196, 196),
                        ),
                        label: AppLocalizations.of(context)!.clients,
                      ),
                    if (deviceType != DeviceType.PINPAD)
                      NavigationDestination(
                        icon: Icon(
                          Icons.person_outline,
                          size: 24,
                          color: Color.fromARGB(255, 196, 196, 196),
                        ),
                        selectedIcon: Icon(
                          Icons.person_outline,
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
      },
    );
  }
}
