// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/place_oder_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppBarDiary extends StatelessWidget implements PreferredSizeWidget {
  const AppBarDiary({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(110);

  @override
  Widget build(BuildContext context) {
    final orderActive = Provider.of<OrderProvider>(context);
    final currentClientForTheOrder =
        Provider.of<OrderProvider>(context).clientForTheOrder;

    return AppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),

      title: Padding(
        padding: EdgeInsets.only(left: 5),
        child: Text(
          AppLocalizations.of(context)!.diary,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w300,
            fontFamily: 'Poppins-regular',
          ),
        ),
      ),
      // centerTitle: true,
      elevation: 0,
      backgroundColor: myTheme.colorScheme.primary,
      actions: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: IconButton(
                constraints: const BoxConstraints(),
                splashRadius: 20.0,
                icon: const Icon(MdiIcons.bellOutline, size: 25),
                // Redireccionar a la pantalla de notificaciones
                onPressed: () {
                  Navigator.pushNamed(context, 'notifications');
                },
              ),
            ),
            orderActive.orderActive == false
                ? Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 16, 8),
                    child: IconButton(
                      constraints: const BoxConstraints(),
                      splashRadius: 20.0,
                      icon: const Icon(MdiIcons.cartOutline, size: 24),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => PlaceOrderPage(),
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 8),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings: const RouteSettings(name: "ORDER"),
                            builder: (context) => const OrderPage(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.shopping_cart_rounded,
                        size: 24,
                      ),
                      label: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            currentClientForTheOrder!.name,
                            style: TextStyle(fontSize: 11),
                          ),
                          Text(
                            currentClientForTheOrder.prices,
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(elevation: 0),
                    ),
                    // child: IconButton(
                    //   constraints: const BoxConstraints(),
                    //   splashRadius: 20.0,
                    //   icon:
                    //       const Icon(Icons.shopping_cart_rounded, size: 24),
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         settings: const RouteSettings(name: "ORDER"),
                    //         builder: (context) => const OrderPage(),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ),
          ],
        ),
      ],
      bottom: DiaryTabBar(),
    );
  }
}

class DiaryTabBar extends StatelessWidget implements PreferredSizeWidget {
  const DiaryTabBar({
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
      indicatorWeight: 3,
      indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
      indicatorSize: TabBarIndicatorSize.tab,
      // isScrollable: true,
      // ignore: prefer_const_literals_to_create_immutables
      tabs: [
        Tab(text: AppLocalizations.of(context)!.visits),
        Tab(text: AppLocalizations.of(context)!.orders),
        Tab(text: AppLocalizations.of(context)!.invoices),
      ],
    );
  }
}
