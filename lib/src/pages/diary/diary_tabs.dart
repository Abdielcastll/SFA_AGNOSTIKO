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

class DiaryBody extends StatefulWidget {
  const DiaryBody({
    Key? key,
  }) : super(key: key);

  @override
  State<DiaryBody> createState() => _DiaryBodyState();
}

class _DiaryBodyState extends State<DiaryBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBarView(
        children: const [
          VisitsPage(),
          OrdersPage(),
          InvoicesPage(),
        ],
      ),
    );
  }
}
