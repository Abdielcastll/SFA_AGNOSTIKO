//Firebase
// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth/wrapper/wrapper.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/catalogue_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/diary_tabs.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation/navigation.dart';
import 'package:pwa_sales2go_flutter/src/pages/notifications/notifications_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/place_oder_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/profile/profile_page.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'firebase_options.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // print('Firebase inicializado');
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const SfaAgnostiko());
  print('App inicializado');
}

class SfaAgnostiko extends StatelessWidget {
  const SfaAgnostiko({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SFA Agnostiko',
        theme: myTheme,
        initialRoute: 'wrapper',
        routes: {
          'wrapper': (BuildContext context) => Wrapper(),
          'login': (BuildContext context) => LoginPage(),
          'navigation': (BuildContext context) => NavigationPages(),
          'notifications': (BuildContext context) => NotificationsPage(),
          'place_order': (BuildContext context) => PlaceOrderPage(),
          'catalogue': (BuildContext context) => CataloguePage(),
          'products': (BuildContext context) => ProductsPage(),
          'clients': (BuildContext context) => ClientsPage(),
          'profile': (BuildContext context) => ProfilePage(),
          'diary': (BuildContext context) => DiaryTabs(),
        },
      ),
    );
  }
}
