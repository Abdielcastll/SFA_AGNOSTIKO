import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/pages/account_balance/account_balance.dart';
import 'package:pwa_sales2go_flutter/src/pages/account_balance/client_orders.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class AccountTabs extends StatelessWidget {
  const AccountTabs(
      {super.key,
      this.clientDocumentReferenceID,
      this.clientDocument,
      this.clientName});
  final clientDocument;
  final clientName;
  final clientDocumentReferenceID;

  @override
  Widget build(BuildContext context) {
    final orderActive = Provider.of<OrderProvider>(context);
    final currentClientForTheOrder =
        Provider.of<OrderProvider>(context).clientForTheOrder;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),

          title: const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              'Estado de cuenta',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w300,
                fontFamily: 'Poppins-regular',
              ),
            ),
          ),
          // centerTitle: true,
          elevation: 0,
          backgroundColor: myTheme.colorScheme.primary,

          bottom: const AccountTabBar(),
        ),
        body: Container(
          child: TabBarView(
            children: [
              ClientOrders(clientDocument: clientDocumentReferenceID),
              AccountBalancePage(
                clientDocument: clientDocument,
                clientName: clientName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountTabBar extends StatelessWidget implements PreferredSizeWidget {
  const AccountTabBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      splashBorderRadius: BorderRadius.circular(20),
      splashFactory: InkSplash.splashFactory,

      labelColor: Colors.white,
      indicatorColor: myTheme.colorScheme.secondary,
      unselectedLabelColor: Colors.grey.shade400,
      indicatorWeight: 2,
      indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
      indicatorSize: TabBarIndicatorSize.tab,
      // isScrollable: true,
      // ignore: prefer_const_literals_to_create_immutables
      tabs: [
        const Tab(text: 'Pedidos'),
        const Tab(text: 'Balance'),
      ],
    );
  }
}
