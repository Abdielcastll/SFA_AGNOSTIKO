// Se declara en el main todo el enrutamiento de la aplicación
// Paquete principal de Material
import 'package:flutter/material.dart';
// Paquetes que traen las paginas a redireccionar
import 'package:pwa_sales2go_flutter/src/pages/login_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/products_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'login': (BuildContext context) => LoginPage(),
        'product': (BuildContext context) => ProductsPage(),
        'client': (BuildContext context) => ClientsPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Apps2Go',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
