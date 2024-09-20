import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/pages/account_balance/account_balance.dart';
import 'package:pwa_sales2go_flutter/src/pages/account_balance/client_orders.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(
            '$clientName',
            // 'Estado de cuenta',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins-Medium',
            ),
          ),
          // centerTitle: true,
          elevation: 0,
          backgroundColor: themeProvider.myTheme.colorScheme.primary,

          bottom: const AccountTabBar(),
        ),
        body: TabBarView(
          children: [
            ClientOrders(clientDocument: clientDocumentReferenceID),
            AccountBalancePage(
              clientDocument: clientDocument,
              clientName: clientName,
            ),
          ],
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
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      splashBorderRadius: BorderRadius.circular(20),
      splashFactory: InkSplash.splashFactory,
      labelColor: Colors.white,
      indicatorColor: Colors.white,
      unselectedLabelColor: Colors.grey.shade400,

      indicatorWeight: 2,
      indicatorPadding: const EdgeInsets.symmetric(horizontal: 30),
      indicatorSize: TabBarIndicatorSize.tab,
      // isScrollable: true,
      // ignore: prefer_const_literals_to_create_immutables
      tabs: [
        const Tab(text: 'Pedidos'),
        const Tab(text: 'Tickets'),
      ],
    );
  }
}
