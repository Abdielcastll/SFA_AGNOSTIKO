// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/global/logo_widget_dynamic.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/place_oder_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:pwa_sales2go_flutter/src/services/connection_service.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_diary_tab.dart';

class AppBarDiary extends StatelessWidget implements PreferredSizeWidget {
  const AppBarDiary({
    Key? key,
    required this.userZoneDocument,
  }) : super(key: key);

  final userZoneDocument;

  @override
  Size get preferredSize => const Size.fromHeight(110);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final user = Provider.of<UserModel>(context);

    final orderActive = Provider.of<OrderProvider>(context);
    final currentClientForTheOrder =
        Provider.of<OrderProvider>(context).clientForTheOrder;

    return AppBar(
      foregroundColor: Colors.white,
      title: orderActive.orderActive == false
          ? Padding(
              padding: EdgeInsets.only(left: 5, top: 5),
              child: Text(
                AppLocalizations.of(context)!.diary,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins-Regular',
                  color: Colors.white,
                ),
              ),
            )
          : Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              height: 50,
              width: 120,
              child: LogoFromFirebase(),
            ),
      // centerTitle: true,
      elevation: 0,
      backgroundColor: themeProvider.myTheme.colorScheme.primary,
      actions: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            orderActive.orderActive == false
                ? Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 16, 8),
                    child: IconButton(
                      constraints: const BoxConstraints(),
                      splashRadius: 20.0,
                      icon: const Icon(
                        MdiIcons.cart,
                        size: 30,
                        color: Color.fromARGB(255, 196, 196, 196),
                      ),
                      onPressed: () async {
                        bool internet = await checkInternetConnection(context);
                        if (internet) {
                          orderActive.setOrder(true, null);
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              settings: const RouteSettings(name: "ORDER"),
                              builder: (context) =>
                                  StreamProvider<CurrentUserInfo?>.value(
                                value: usersCollection
                                    .doc(user.uid)
                                    .snapshots()
                                    .map(AuthService().userDataFromsnapshot),
                                initialData: CurrentUserInfo(
                                  name: '',
                                  dni: '',
                                  zone: '',
                                  zoneDocument: '',
                                  email: '',
                                  role: '',
                                  uid: '',
                                ),
                                catchError: (context, error) {
                                  print(error);
                                  return;
                                },
                                // builder: (context, child) {

                                //   return NavigationPages();
                                // });
                                child: const OrderPage(),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  )
                : Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 8),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        bool internet = await checkInternetConnection(context);
                        if (internet) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              settings: const RouteSettings(name: "ORDER"),
                              builder: (context) => const OrderPage(),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.shopping_cart_rounded,
                        size: 24,
                        color: Color.fromARGB(255, 196, 196, 196),
                      ),
                      label: globalRemoteConfig.clientesEnabled == true
                          ? currentClientForTheOrder != null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      currentClientForTheOrder.name,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'Poppins-Regular',
                                        color:
                                            Color.fromARGB(255, 196, 196, 196),
                                      ),
                                    ),
                                    if (globalRemoteConfig
                                            .onlyFullPaymentWithCard! ==
                                        false)
                                      Text(
                                        currentClientForTheOrder.prices,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontFamily: 'Poppins-Regular',
                                          color: Color.fromARGB(
                                              255, 196, 196, 196),
                                        ),
                                      ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Volver al carrito",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'Poppins-regular',
                                        color:
                                            Color.fromARGB(255, 196, 196, 196),
                                      ),
                                    ),
                                  ],
                                )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Volver al carrito",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'Poppins-regular',
                                    color: Color.fromARGB(255, 196, 196, 196),
                                  ),
                                ),
                              ],
                            ),
                      style: ElevatedButton.styleFrom(elevation: 0),
                    ),
                  ),
          ],
        ),
      ],
      bottom: DiaryTabBar(),
    );
  }
}
