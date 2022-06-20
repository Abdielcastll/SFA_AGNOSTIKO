// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/cart_tabs/invoices/invoices_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/cart_tabs/orders/orders_page.dart';

import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/cart_tabs/visits/visits_page.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class CartTabs extends StatelessWidget {
  const CartTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: TabsBar(),
        ),
        body: Container(
          child: TabBarView(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              VisitsPage(),
              OrdersPage(),
              InvoicesPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class TabsBar extends StatelessWidget {
  const TabsBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 0,
      backgroundColor: const Color(0xFFF8F8F8),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: SizedBox(
          height: 40,
          child: TabBar(
            splashBorderRadius: BorderRadius.circular(10),
            splashFactory: InkSplash.splashFactory,
            labelColor: myTheme.colorScheme.secondary,
            indicatorColor: myTheme.colorScheme.secondary,
            unselectedLabelColor: Colors.grey.shade300,
            indicatorWeight: 4,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
            indicatorSize: TabBarIndicatorSize.tab,
            // isScrollable: true,
            // ignore: prefer_const_literals_to_create_immutables
            tabs: [
              Tab(text: 'Visitas'),
              Tab(text: 'Pedidos'),
              Tab(text: 'Facturas'),
            ],
          ),
        ),
      ),
    );
  }
}
