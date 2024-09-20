// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
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
import 'package:pwa_sales2go_flutter/src/widgets/appbar/notification_bell.dart';

class AppBarNavigation extends StatelessWidget implements PreferredSizeWidget {
  AppBarNavigation({
    Key? key,
    required this.message,
    required this.userZoneDocument,
  }) : super(key: key);

  final String message;
  final userZoneDocument;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    // print('userRole IN APPBAR NAVIGATION: $userRole');

    final orderActive = Provider.of<OrderProvider>(context);
    final user = Provider.of<UserModel>(context);
    final currentClientForTheOrder =
        Provider.of<OrderProvider>(context).clientForTheOrder;
    // print('userZoneDocument: $userZoneDocument');
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return AppBar(
      foregroundColor: Colors.white,
      title: orderActive.orderActive == true
          ? Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              height: 50,
              width: 120,
              child: Image.asset(
                'assets/images/prosa_blanco.png',
                fit: BoxFit.contain,
              ),
            )
          : Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              height: 50,
              width: 120,
              child: Image.asset(
                'assets/images/prosa_blanco.png',
                fit: BoxFit.contain,
              ),
            ),
      // title: Text(
      //   message,
      //   style: TextStyle(
      //     letterSpacing: 0,
      //     fontSize: 22,
      //     fontFamily: 'Poppins-Regular',
      //   ),
      // ),
      elevation: 0,
      leadingWidth: 24.0,
      backgroundColor: themeProvider.myTheme.colorScheme.primary,
      actions: [
        globalRemoteConfig.conversionKiosko == true
            ? Container()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  orderActive.orderActive == false
                      // TODO: Buscar una mejor manera de identificar si es admin
                      ? IconButton(
                          constraints: const BoxConstraints(),
                          splashRadius: 20.0,
                          icon: const Icon(
                            MdiIcons.cartOutline,
                            size: 24,
                            color: Color.fromARGB(255, 196, 196, 196),
                          ),
                          onPressed: () async {
                            bool internet =
                                await checkInternetConnection(context);
                            if (globalRemoteConfig.clientesEnabled == true &&
                                internet) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: SingleChildScrollView(
                                      child: AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        title: Center(
                                          child: Text(
                                            '¿Desea registrar el cliente?',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Poppins-regular',
                                              color: themeProvider
                                                  .myTheme
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        content: Container(
                                          // color: Colors.grey,
                                          // height: 30,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            // crossAxisAlignment:
                                            //     CrossAxisAlignment.start,
                                            children: [
                                              TextButton(
                                                style: ButtonStyle(
                                                  overlayColor:
                                                      MaterialStateColor
                                                          .resolveWith(
                                                              (states) => Colors
                                                                  .transparent),
                                                ),
                                                onPressed: () {
                                                  // Escoger lista de clientes
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          PlaceOrderPage(
                                                        userZoneDocument:
                                                            userZoneDocument,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5, 0, 0),
                                                  child: Text(
                                                    'Si',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                style: ButtonStyle(
                                                  overlayColor:
                                                      MaterialStateColor
                                                          .resolveWith(
                                                              (states) => Colors
                                                                  .transparent),
                                                ),
                                                onPressed: () async {
                                                  // Escoger lista de clientes
                                                  // var client =
                                                  print(
                                                      'SELECTING DEFAULT CLIENT');
                                                  Clients? defaultClient =
                                                      genericClients;
                                                  await clientsCollection
                                                      .where('zona',
                                                          isEqualTo:
                                                              userZoneDocument)
                                                      .where('numeroId',
                                                          isEqualTo: 0)
                                                      .get()
                                                      .then(
                                                    (value) {
                                                      return value.docs.map(
                                                        (snapshot) {
                                                          if (snapshot
                                                              .get('nombre')
                                                              .toString()
                                                              .contains(
                                                                  '000A Cliente Default')) {
                                                            print(
                                                                'SENDING DATA BASE DEFAULT CLIENT');
                                                            defaultClient =
                                                                genericClients;
                                                          } else {
                                                            print(
                                                                'SENDING ERROR DEFAULT CLIENT');
                                                            defaultClient =
                                                                genericClients;
                                                          }
                                                        },
                                                      ).toList();
                                                    },
                                                  ).catchError(
                                                    (e) {
                                                      print(
                                                          'ERROR ON GETTING CLIENT DEFAULT ON APPBAR NAVIGATION');
                                                      print(e);
                                                      print(
                                                          'SENDING ERROR DEFAULT CLIENT');
                                                      return <Null>[];
                                                    },
                                                  );

                                                  print(
                                                      'defaultClient?.zone: ${defaultClient?.zone}');
                                                  orderActive.setOrder(
                                                      true, defaultClient);
                                                  Navigator.pop(context);
                                                  if (defaultClient == null) {
                                                    print(
                                                        'ERROR ON GETTING DEFAULT CLIENT');
                                                  } else {
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        settings:
                                                            const RouteSettings(
                                                          name: "ORDER",
                                                        ),
                                                        builder: (context) =>
                                                            StreamProvider<
                                                                CurrentUserInfo?>.value(
                                                          value: usersCollection
                                                              .doc(user.uid)
                                                              .snapshots()
                                                              .map(
                                                                AuthService()
                                                                    .userDataFromsnapshot,
                                                              ),
                                                          initialData:
                                                              CurrentUserInfo(
                                                            name: '',
                                                            dni: '',
                                                            zone: '',
                                                            zoneDocument: '',
                                                            email: '',
                                                            role: '',
                                                            uid: '',
                                                          ),
                                                          catchError:
                                                              (context, error) {
                                                            print(error);
                                                            return;
                                                          },
                                                          // builder: (context, child) {

                                                          //   return NavigationPages();
                                                          // });
                                                          child:
                                                              const OrderPage(),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5, 0, 0),
                                                  child: Text(
                                                    'No',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-regular',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (internet) {
                              print('CLIENTS OFF, selecting default');
                              Clients? defaultClient = genericClients;
                              await clientsCollection
                                  .where('zona', isEqualTo: userZoneDocument)
                                  .where('numeroId', isEqualTo: 0)
                                  .get()
                                  .then(
                                (value) {
                                  return value.docs.map(
                                    (snapshot) {
                                      if (snapshot
                                          .get('nombre')
                                          .toString()
                                          .contains('000A Cliente Default')) {
                                        print(
                                            'SENDING DATA BASE DEFAULT CLIENT');
                                        defaultClient = genericClients;
                                      } else {
                                        print('SENDING ERROR DEFAULT CLIENT');
                                        defaultClient = genericClients;
                                      }
                                    },
                                  ).toList();
                                },
                              ).catchError(
                                (e) {
                                  print(
                                      'ERROR ON GETTING CLIENT DEFAULT ON APPBAR NAVIGATION');
                                  print(e);
                                  print('SENDING ERROR DEFAULT CLIENT');
                                  return <Null>[];
                                },
                              );

                              print(
                                  'defaultClient?.zone: ${defaultClient?.zone}');
                              orderActive.setOrder(true, defaultClient);
                              if (defaultClient == null) {
                                print('ERROR ON GETTING DEFAULT CLIENT');
                              } else {
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    settings: const RouteSettings(
                                      name: "ORDER",
                                    ),
                                    builder: (context) =>
                                        StreamProvider<CurrentUserInfo?>.value(
                                      value: usersCollection
                                          .doc(user.uid)
                                          .snapshots()
                                          .map(
                                            AuthService().userDataFromsnapshot,
                                          ),
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
                            }
                          },
                        )
                      : ElevatedButton.icon(
                          onPressed: () async {
                            bool internet =
                                await checkInternetConnection(context);
                            if (internet) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  settings: const RouteSettings(name: "ORDER"),
                                  builder: (context) =>
                                      StreamProvider<CurrentUserInfo?>.value(
                                    value: usersCollection
                                        .doc(user.uid)
                                        .snapshots()
                                        .map(
                                            AuthService().userDataFromsnapshot),
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
                                      print(
                                          'ERROR GETTING CURRENT USER INFO IN APPBAR NAVIGATION');
                                      print(error);
                                      return;
                                    },
                                    child: const OrderPage(),
                                  ),
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
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      currentClientForTheOrder!.name,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'Poppins-Regular',
                                        color:
                                            Color.fromARGB(255, 196, 196, 196),
                                      ),
                                    ),
                                    Text(
                                      currentClientForTheOrder.prices,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'Poppins-Regular',
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
                                        color:
                                            Color.fromARGB(255, 196, 196, 196),
                                      ),
                                    ),
                                  ],
                                ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                themeProvider.myTheme.colorScheme.primary,
                          ),
                        ),
                  NotificationBell()
                ],
              ),
      ],
    );
  }
}
