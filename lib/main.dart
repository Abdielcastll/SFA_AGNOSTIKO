//Firebase
// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/catalogue/catalogue_page.dart';
import 'firebase_options.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth_pages/login/forgot_password_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth_pages/login/login_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth_pages/splashscreen/splashscreen.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/cart/cart_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/cart/checkout_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/clients/clients_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/dashboard/dashboard_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/records/invoices/invoices_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/records/orders/orders_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/records/records_tabs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/navi_pages.dart';

import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';

import 'package:pwa_sales2go_flutter/src/pages/notifications/notifications_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/visits/visits_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase inicializado');
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const SfaAgnostiko());
  print('App inicializado');
}

class SfaAgnostiko extends StatelessWidget {
  const SfaAgnostiko({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SFA Agnostiko',
      theme: myTheme,
      initialRoute: 'splashscreen',
      routes: {
        'splashscreen': (BuildContext context) => SplashScreenWidget(),
        'tabs': (BuildContext context) => NaviPages(),
        'dashboard': (BuildContext context) => DashboardPage(),
        'login': (BuildContext context) => LoginPage(),
        'password_reset': (BuildContext context) => ForgotPasswordPage(),
        'cart': (BuildContext context) => CartPage(),
        'checkout': (BuildContext context) => CheckoutPage(),
        'notifications': (BuildContext context) => NotificationsPage(),
        'catalogue': (BuildContext context) => CataloguePage(),
        'products': (BuildContext context) => ProductsPage(),
        'clients': (BuildContext context) => ClientsPage(),
        'orders': (BuildContext context) => OrdersPage(),
        'invoices': (BuildContext context) => InvoicesPage(),
        'visits': (BuildContext context) => VisitsPage(),
        'records': (BuildContext context) => RecordTabs(),
      },
    );
  }
}
