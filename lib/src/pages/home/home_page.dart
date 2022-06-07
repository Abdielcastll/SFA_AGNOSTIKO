//Flutter
import 'package:flutter/material.dart';
//Variable global
import 'package:pwa_sales2go_flutter/src/global/global.dart';
//Widgets
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';
import 'package:pwa_sales2go_flutter/src/widgets/drawer/drawer_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Usuario conectado:');
    print(sharedPreferences!.getString('uid'));
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: const AppBarHome(
        title: 'SFA Agnostiko',
        backgroundColor: Color(0xFF4f42ed),
      ),
      body: Container(
        child: const SingleChildScrollView(),
      ),
    );
  }
}
