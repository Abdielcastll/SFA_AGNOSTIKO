//Firebase
// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
//Flutter
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
//Routes
import 'package:pwa_sales2go_flutter/src/pages/Catalogue/catalogue_page.dart';
import 'package:pwa_sales2go_flutter/src/widgets/splashscreen/splashscreen_widget.dart';
import 'package:pwa_sales2go_flutter/src/pages/login/login_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/login/forgot_password_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/cart/cart_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/cart/checkout_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/dashboard/dashboard_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/invoices/invoices_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/notifications/notifications_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/orders/orders_page.dart';
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
      theme: ThemeData(
        primaryColor: const Color(0xFF4f42ed),
      ),
      initialRoute: 'splashscreen',
      routes: {
        //
        'splashscreen': (BuildContext context) => SplashScreenWidget(),
        'dashboard': (BuildContext context) => DashboardPage(),
        //
        'login': (BuildContext context) => LoginPage(),
        'password_reset': (BuildContext context) => ForgotPasswordPage(),
        //
        'cart': (BuildContext context) => CartPage(),
        'checkout': (BuildContext context) => CheckoutPage(),
        'notifications': (BuildContext context) => NotificationsPage(),
        //
        'catalogue': (BuildContext context) => CataloguePage(),
        'products': (BuildContext context) => ProductsPage(),
        'clients': (BuildContext context) => ClientsPage(),
        'orders': (BuildContext context) => OrdersPage(),
        'invoices': (BuildContext context) => InvoicesPage(),
        'visits': (BuildContext context) => VisitsPage(),
      },
    );
  }
}
