//Firebase
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
import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/home/home_page.dart';

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
        'splashscreen': (BuildContext context) => SplashScreenWidget(),
        'home': (BuildContext context) => HomePage(),
        'login': (BuildContext context) => LoginPage(),
        'catalogue': (BuildContext context) => CataloguePage(),
        'products': (BuildContext context) => ProductsPage(),
        'clients': (BuildContext context) => ClientsPage(),
        // 'orders': (BuildContext context) => OrdersPage(),
        // 'invoice': (BuildContext context) => InvoicePage(),
        // 'roles': (BuildContext context) => RolesPage(),
      },
    );
  }
}
