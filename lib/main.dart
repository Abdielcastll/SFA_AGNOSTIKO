import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/helper/object_box.dart';
import 'package:pwa_sales2go_flutter/l10n/l10n.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth/wrapper/wrapper.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/catalogue_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/diary_tabs.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation/navigation.dart';
import 'package:pwa_sales2go_flutter/src/pages/notifications/notifications_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/place_oder_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/profile/profile_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/locale_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'firebase_options.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late ObjectBox objectBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const SfaAgnostiko());
}

class SfaAgnostiko extends StatelessWidget {
  const SfaAgnostiko({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthService().user,
      initialData: null,
      child: ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          final localeProvider = Provider.of<LocaleProvider>(context);
          return ChangeNotifierProvider(
            create: (context) => CurrencyProvider(),
            builder: (context, child) {
              return ChangeNotifierProvider(
                create: (context) => OrderProvider(),
                builder: (context, child) {
                  return ChangeNotifierProvider(
                    create: (context) => CounterLimitFirestore(),
                    builder: (context, child) {
                      final productsLimit =
                          Provider.of<CounterLimitFirestore>(context)
                              .getProductsLimit;
                      // final productsScrollLimit =
                      //     Provider.of<CounterLimitFirestore>(context)
                      //         .getScrollProductLimit;
                      return StreamProvider<List<Products>?>.value(
                        value: productsLimit == 0
                            ? productsCollection
                                .orderBy('codigo')
                                .snapshots()
                                .map(productsListFromSnapshot)
                            : productsCollection
                                .orderBy('codigo')
                                .limit(productsLimit)
                                .snapshots()
                                .map(productsListFromSnapshot),
                        initialData: const [],
                        catchError: (context, error) {
                          print(error);
                          return;
                        },
                        child: MaterialApp(
                          debugShowCheckedModeBanner: false,
                          locale: localeProvider.locale,
                          supportedLocales: L10n.all,
                          localizationsDelegates: const [
                            AppLocalizations.delegate,
                            GlobalMaterialLocalizations.delegate,
                            GlobalWidgetsLocalizations.delegate,
                            GlobalCupertinoLocalizations.delegate,
                          ],
                          title: 'SFA Agnostiko',
                          theme: myTheme,
                          initialRoute: 'wrapper',
                          routes: {
                            'wrapper': (BuildContext context) => Wrapper(),
                            'login': (BuildContext context) =>
                                const LoginPage(),
                            'navigation': (BuildContext context) =>
                                const NavigationPages(),
                            'notifications': (BuildContext context) =>
                                const NotificationsPage(),
                            'place_order': (BuildContext context) =>
                                const PlaceOrderPage(),
                            'catalogue': (BuildContext context) =>
                                const CataloguePage(),
                            'products': (BuildContext context) =>
                                ProductsPage(),
                            'clients': (BuildContext context) =>
                                const ClientsPage(),
                            'profile': (BuildContext context) =>
                                const ProfilePage(),
                            'diary': (BuildContext context) =>
                                const DiaryTabs(),
                            'order': (BuildContext context) =>
                                const OrderPage(),
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
