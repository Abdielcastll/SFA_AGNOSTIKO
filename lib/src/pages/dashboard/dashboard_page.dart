//Flutter
import 'package:flutter/material.dart';
//Variable global
import 'package:pwa_sales2go_flutter/src/global/global.dart';
//Widgets
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/bottom_decoration.dart';
import 'package:pwa_sales2go_flutter/src/widgets/drawer/drawer_widget.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Usuario conectado:');
    print(sharedPreferences!.getString('uid'));
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: const AppBarHome(
        title: 'Dashboard',
        backgroundColor: Color(0xFF4f42ed),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomDecoration(),
      body: Container(
        child: const SingleChildScrollView(),
      ),
    );
  }
}
