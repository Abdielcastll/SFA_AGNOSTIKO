// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/dashboard/components/client_listview.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/dashboard/components/dashboard_search_buttons.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/dashboard/components/summary_data.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Usuario conectado:');
    print(sharedPreferences!.getString('uid'));
    return Scaffold(
      appBar: AppBarHome(),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            DashboardHeaderButtons(),
            SummaryData(),
            Container(
              padding: EdgeInsets.only(top: 16),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[200],
              child: Container(
                margin: EdgeInsets.only(left: 16),
                child: Text(
                  'Clientes Frecuentes',
                  style: TextStyle(
                    color: myTheme.colorScheme.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            ClientListView(),
          ],
        ),
      ),
    );
  }
}
