import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/checkout_retail_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/place_oder_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

selectClientDialog(BuildContext context, products, subTotal) {
  final orderActive = Provider.of<OrderProvider>(context, listen: false);
  final clientForTheOrder =
      Provider.of<OrderProvider>(context, listen: false).clientForTheOrder;
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final userZoneDocument =
      Provider.of<CurrentUserInfo>(context, listen: false).zoneDocument;

  showDialog(
    barrierDismissible: false,
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
                'Personalizar el carrito de compras con tu nombre ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  color: themeProvider.myTheme.colorScheme.onPrimaryContainer,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Container(
              // color: Colors.grey,
              // height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment:
                //     CrossAxisAlignment.start,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.transparent),
                    ),
                    onPressed: () {
                      // Escoger lista de clientes
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => PlaceOrderPage(
                            userZoneDocument: userZoneDocument,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        'Si',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.transparent),
                    ),
                    onPressed: () async {
                      // Escoger lista de clientes
                      // var client =
                      print('SELECTING DEFAULT CLIENT');
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
                                print('SENDING DATA BASE DEFAULT CLIENT');
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

                      print('defaultClient?.zone: ${defaultClient?.zone}');
                      orderActive.setOrder(true, defaultClient);
                      Navigator.pop(context);
                      if (defaultClient == null) {
                        print('ERROR ON GETTING DEFAULT CLIENT');
                      } else {
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutRetailPage(
                              client: clientForTheOrder,
                              cart: products,
                              subTotal: double.parse(
                                subTotal.toString(),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        'No',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
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
}
