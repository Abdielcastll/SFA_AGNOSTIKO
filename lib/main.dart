// Paquetes de Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//Test
import 'package:pwa_sales2go_flutter/src/test/test_get_info_device.dart';
// Paquete principal de Material
import 'package:flutter/material.dart';
// Paquetes que traen las paginas a redireccionar
import 'package:pwa_sales2go_flutter/src/pages/login_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/products_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/home_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/roles_page.dart';

// Se declara en el main todo el enrutamiento de la aplicación
Future main() async {
  print('Inicializando Firebase...');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase inicializado');
  runApp(MyApp());
  print('App inicializado');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'login': (BuildContext context) => LoginPage(),
        'product': (BuildContext context) => ProductsPage(),
        'client': (BuildContext context) => ClientsPage(),
        'roles': (BuildContext context) => RolesPage(),
        //Rutas para probar cosas
        'test': (BuildContext context) => LoadInfo(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Apps2Go',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
    );
  }
}
