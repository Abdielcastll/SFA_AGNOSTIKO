// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/place_oder_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: SingleChildScrollView(
                                child: AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Center(
                                    child: Text(
                                      'Tipo de cliente a utilizar',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Poppins-regular',
                                        color: myTheme.colorScheme.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  content: Container(
                                    // color: Colors.grey,
                                    height: 150,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 120,
                                          width: 100,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Escoger lista de clientes
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      PlaceOrderPage(
                                                          userZoneDocument:
                                                              userZoneDocument),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: myTheme
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.list,
                                                ),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5, 0, 0),
                                                  child: Text(
                                                    'Lista de Clientes',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-regular',
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 120,
                                          width: 100,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              // Escoger lista de clientes
                                              // var client =
                                              Clients? defaultClient;
                                              await clientsCollection
                                                  .where('zona',
                                                      isEqualTo:
                                                          userZoneDocument)
                                                  .where('numeroId',
                                                      isEqualTo: 0)
                                                  .get()
                                                  .then((value) {
                                                return value.docs
                                                    .map((snapshot) {
                                                  if (snapshot
                                                      .get('nombre')
                                                      .toString()
                                                      .contains(
                                                          '000A Cliente Default')) {
                                                    defaultClient = Clients(
                                                      active: snapshot
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'activo')
                                                          ? snapshot
                                                              .get('activo')
                                                          : 'NaN',
                                                      specialContributor: snapshot
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'contribuyenteEspecial')
                                                          ? snapshot.get(
                                                              'contribuyenteEspecial')
                                                          : false,
                                                      madeBy: snapshot
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'creadoPor')
                                                          ? snapshot
                                                              .get('creadoPor')
                                                              .id
                                                          : 'NaN',
                                                      masterDiscount: snapshot
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'descuentoMaestro')
                                                          ? snapshot.get(
                                                              'descuentoMaestro')
                                                          : 'NaN',
                                                      fiscalAdress: snapshot
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'direccionFiscal')
                                                          ? snapshot.get(
                                                              'direccionFiscal')
                                                          : 'NaN',
                                                      dispatchAdress: snapshot
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'direccionDespacho')
                                                          ? snapshot.get(
                                                              'direccionDespacho')
                                                          : 'No hay direccion de despacho',
                                                      email: snapshot
                                                              .data()
                                                              .toString()
                                                              .contains('email')
                                                          ? snapshot
                                                              .get('email')
                                                          : 'NaN',
                                                      prices: snapshot
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'listaDePrecios')
                                                          ? snapshot
                                                              .get(
                                                                  'listaDePrecios')
                                                              .id
                                                          : 'NaN',
                                                      modified: snapshot
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'modificado')
                                                          ? snapshot
                                                              .get('modificado')
                                                          : 'NaN',
                                                      name: snapshot
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'nombre')
                                                          ? snapshot
                                                              .get('nombre')
                                                          : 'NaN',
                                                      id: snapshot
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'numeroId')
                                                          ? snapshot
                                                              .get('numeroId')
                                                          : 'NaN',
                                                      prospect: snapshot
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'prospecto')
                                                          ? snapshot
                                                              .get('prospecto')
                                                          : false,
                                                      phone1: snapshot
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'telefono')
                                                          ? snapshot
                                                              .get('telefono')
                                                          : 'NaN',
                                                      phone2: snapshot
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'telefono2')
                                                          ? snapshot
                                                              .get('telefono2')
                                                          : 'NaN',
                                                      idType: snapshot
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'tipoId')
                                                          ? snapshot
                                                              .get('tipoId')
                                                              .id
                                                          : 'NaN',
                                                      zone: snapshot
                                                              .data()
                                                              .toString()
                                                              .contains('zona')
                                                          ? snapshot
                                                              .get('zona')
                                                              .id
                                                          : 'NaN',
                                                      clientDocumentId:
                                                          snapshot.reference.id,
                                                    );
                                                  }
                                                }).toList();
                                              });

                                              print(defaultClient?.zone);
                                              orderActive.setOrder(
                                                  true, defaultClient);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  settings: const RouteSettings(
                                                      name: "ORDER"),
                                                  builder: (context) =>
                                                      const OrderPage(),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  myTheme.colorScheme.primary,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.login_rounded,
                                                ),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5, 0, 0),
                                                  child: Text(
                                                    'Venta Retail',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-regular',
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                )
                                              ],
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
            // orderActive.orderActive == false
            //     ? Container(
            //         margin: EdgeInsets.fromLTRB(0, 0, 16, 8),
            //         child: IconButton(
            //           constraints: const BoxConstraints(),
            //           splashRadius: 20.0,
            //           icon: const Icon(MdiIcons.cartOutline, size: 24),
            //           onPressed: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (BuildContext context) => PlaceOrderPage(
            //                     userZoneDocument: userZoneDocument),
            //               ),
            //             );
            //           },
            //         ),
            //       )
            //     : Container(
            //         margin: EdgeInsets.fromLTRB(0, 10, 0, 8),
            //         child: ElevatedButton.icon(
            //           onPressed: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 settings: const RouteSettings(name: "ORDER"),
            //                 builder: (context) => const OrderPage(),
            //               ),
            //             );
            //           },
            //           icon: const Icon(
            //             Icons.shopping_cart_rounded,
            //             size: 24,
            //           ),
            //           label: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               Text(
            //                 currentClientForTheOrder!.name,
            //                 style: TextStyle(fontSize: 11),
            //               ),
            //               Text(
            //                 currentClientForTheOrder.prices,
            //                 style: TextStyle(fontSize: 11),
            //               ),
            //             ],
            //           ),
            //           style: ElevatedButton.styleFrom(elevation: 0),
            //         ),
            //       ),
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
