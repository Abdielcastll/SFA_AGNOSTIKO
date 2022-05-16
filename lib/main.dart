import 'package:pwa_sales2go_flutter/src/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/login_page.dart';

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
      },
      debugShowCheckedModeBanner: false,
      title: 'Apps2Go',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
