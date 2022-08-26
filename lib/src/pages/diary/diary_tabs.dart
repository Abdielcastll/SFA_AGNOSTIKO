// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/invoices/invoices_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/orders_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/visits_page.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_diary.dart';

class DiaryTabs extends StatelessWidget {
  const DiaryTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBarDiary(),
        body: DiaryBody(),
      ),
    );
  }
}

class DiaryBody extends StatelessWidget {
  const DiaryBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBarView(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          VisitsPage(),
          OrdersPage(),
          InvoicesPage(),
        ],
      ),
    );
  }
}
