// - Main: Se usa el main para inicializar la aplicación e inicializar Firebase.
// - Posteriormente, se declaran las rutas que tendra la aplicación y se podran
// acceder a ellas desde el navegador.

// Paquetes de Firebase
//  Firebase Core: Contiene las funciones de Firebase y las opciones que se
//  usaran dependiendo del sistema operativo.
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// Paquete principal de Material de Flutter
import 'package:flutter/material.dart';
// Paquetes que traen las rutas de la aplicación.
import 'package:pwa_sales2go_flutter/src/pages/login_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/products_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/home_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/roles_page.dart';

// Funcion principal para iniciar la aplicacion.
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase inicializado');
  runApp(SfaAgnostiko());
  print('App inicializado');
}

// MyApp se utilizara para declarar las rutas de la aplicación.
class SfaAgnostiko extends StatelessWidget {
  SfaAgnostiko({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SFA Agnostiko',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'login': (BuildContext context) => LoginPage(),
        'product': (BuildContext context) => ProductsPage(),
        'client': (BuildContext context) => ClientsPage(),
        'roles': (BuildContext context) => RolesPage(),
      },
    );
  }
}
