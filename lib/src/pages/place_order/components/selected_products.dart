// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/examples/clients_example.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/catalogue_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/product_in_cart.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/checkout_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectedProducts extends StatefulWidget {
  const SelectedProducts({
    Key? key,
    required this.client,
  }) : super(key: key);

  final Clients? client;

  @override
  State<SelectedProducts> createState() => _SelectedProductsState();
}

class _SelectedProductsState extends State<SelectedProducts> {
  final currentCoin = sharedPreferences!.getString('currentCoin');
  late String? clientPriceList = widget.client?.prices;
  late Stream<List<ShoppingCartProduct>> streamShoppingCartProducts;
  final List<double> coinsExchangeRates = [0.0, 0.0, 0.0];

  getPricesExchangesRates() async {
    await FirebaseFirestore.instance
        .collection('monedas')
        .get()
        .then((document) {
      // print('Cantidad de documentos en monedas: ${document.docs.length}');
      document.docs.forEach((element) {
        // print(element.data()['tasaDeCambio']);
        coinsExchangeRates.remove(0.0);
        coinsExchangeRates.add(element.data()['tasaDeCambio']);
      });
    });
  }

  identifyPrice(price) {
    if (currentCoin == 'USD' || currentCoin == null) {
      return price.toStringAsFixed(2);
    } else if (currentCoin == 'VED') {
      return (price * coinsExchangeRates[2]).toStringAsFixed(2);
    } else if (currentCoin == 'EUR') {
      return (price * coinsExchangeRates[1]).toStringAsFixed(2);
    } else if (currentCoin == 'BTC') {
      return (price * coinsExchangeRates[0]);
    }
  }

  identifyCurrency() {
    if (currentCoin == 'USD' || currentCoin == null) {
      return '\$';
    } else if (currentCoin == 'VED') {
      return 'BS';
    } else if (currentCoin == 'EUR') {
      return '€';
    } else if (currentCoin == 'BTC') {
      return '฿';
    }
  }

  @override
  void initState() {
    super.initState();
    streamShoppingCartProducts = objectBox.getShoppingCartProducts();
    getPricesExchangesRates();
  }

  @override
  Widget build(BuildContext context) {
    String moneySymbol = identifyCurrency();
    // double subTotalPrice = totalPriceSum();
    // print(streamShoppingCartProducts);
    print(currentCoin);
    print('Tasas: $coinsExchangeRates');
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
          alignment: Alignment.topLeft,
          color: Colors.transparent,
          // child: cartStatus(),
        ),
        // ProductsInCart(
        //   products: products,
        //   client: widget.client,
        // ),
        StreamBuilder<List<ShoppingCartProduct>>(
          stream: streamShoppingCartProducts,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final products = snapshot.data!;
              var subTotal = 0.0;
              print('Lista de precios activa: $clientPriceList');
              print('Cantidad de objetos en carrito: ${products.length}');
              products.forEach((product) {
                var myInt = double.parse(product.totalAmount!);
                print('Precio de producto ${product.code}: $myInt');
                subTotal += myInt;
              });
              print('SubTotal del pedido: $subTotal');
              var test = identifyPrice(subTotal);
              print(test);

              return WillPopScope(
                onWillPop: () async {
                  print('Retroceder');
                  products.isEmpty
                      ? Navigator.pop(context)
                      : showDialog(
                          context: context,
                          barrierDismissible: false, // User must tap button
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Al cambiar el cliente la lista de precios estara cambiando, por lo que el carrito se reiniciara',
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Text('¿Esta seguro que quiere regresar?'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Regresar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Aceptar'),
                                  onPressed: () {
                                    objectBox.delelteAllShoppingCart();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );

                  return false;
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      products.isEmpty
                          ? Container(
                              height: 340,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 200,
                                    width: 200,
                                    child: Image.asset(
                                      'assets/images/placeholder_emptyorder.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Text(AppLocalizations.of(context)!
                                        .orderEmtpy),
                                  ),
                                  Container(
                                    child: Text(AppLocalizations.of(context)!
                                        .orderEmptyDesc),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              color: Colors.grey.shade100,
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  // print(product);
                                  return ListTile(
                                    leading: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 5, 0, 0),
                                        child: Icon(Icons.image_rounded)),
                                    title: Text('${product.name}'),
                                    subtitle: Text('${product.code}'),
                                    onTap: () => objectBox
                                        .deleteShoppingCartProduct(product.id),
                                  );
                                },
                              ),
                            ),
                      Container(
                        height: 133,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.orderSubTotal,
                                    style: TextStyle(
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000C99),
                                    ),
                                  ),
                                  Text(
                                    '$moneySymbol ${identifyPrice(subTotal)}',
                                    style: TextStyle(
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000C99),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: 340,
                              height: 40,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Agregar Productos
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CataloguePage(
                                          isOrderActive: true,
                                          listOfPrices: clientPriceList,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    MaterialCommunityIcons.tag_plus,
                                    size: 17,
                                  ),
                                  label: Text(
                                    AppLocalizations.of(context)!.addProducts,
                                    style: TextStyle(
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 14,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    // overlayColor: MaterialStateProperty.all(
                                    //   Colors.transparent,
                                    // ),
                                    backgroundColor: MaterialStateProperty.all(
                                      myTheme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            products.isEmpty
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    width: 340,
                                    height: 40,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          overlayColor:
                                              MaterialStateProperty.all(
                                            Colors.transparent,
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            Colors.grey.shade500,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .orderContinue,
                                              style: TextStyle(
                                                fontFamily: 'Poppins-regular',
                                                fontSize: 14,
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 4),
                                              child: Icon(
                                                SimpleLineIcons.arrow_right,
                                                size: 14,
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    width: 340,
                                    height: 40,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Continuar con la compra
                                          print('Confirmacion de info enviada');
                                          print(
                                              'Objetos en carrito: ${products.length}');
                                          print(
                                              'Cliente activo: ${widget.client!.name}');
                                          print(
                                              'Sub total del pedido: ${subTotal.toStringAsFixed(2)}');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CheckoutPage(
                                                client: widget.client,
                                                cart: products,
                                                subTotal: subTotal,
                                                coinsExchangeRates:
                                                    coinsExchangeRates,
                                              ),
                                            ),
                                          );
                                        },
                                        style: ButtonStyle(
                                          // overlayColor: MaterialStateProperty.all(
                                          //   Colors.transparent,
                                          // ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            myTheme.colorScheme.primary,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'CONTINUAR',
                                              style: TextStyle(
                                                fontFamily: 'Poppins-regular',
                                                fontSize: 14,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 4),
                                              child: Icon(
                                                SimpleLineIcons.arrow_right,
                                                size: 14,
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
        // Container(
        //   height: 133,
        //   width: MediaQuery.of(context).size.width,
        //   decoration: BoxDecoration(
        //     color: Colors.transparent,
        //   ),
        //   child: Column(
        //     children: [
        //       SizedBox(height: 10),
        //       Container(
        //         margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text(
        //               'Sub-total del pedido:',
        //               style: TextStyle(
        //                 fontFamily: 'Poppins-regular',
        //                 fontSize: 14,
        //                 fontWeight: FontWeight.bold,
        //                 color: Color(0xff000C99),
        //               ),
        //             ),
        //             Text(
        //               '$moneySymbol 000.00',
        //               style: TextStyle(
        //                 fontFamily: 'Poppins-regular',
        //                 fontSize: 14,
        //                 fontWeight: FontWeight.bold,
        //                 color: Color(0xff000C99),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //       streamShoppingCartProducts == null
        //           ? Container(
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(20),
        //               ),
        //               width: 340,
        //               height: 40,
        //               child: ClipRRect(
        //                 borderRadius: BorderRadius.circular(16),
        //                 child: ElevatedButton.icon(
        //                   onPressed: () {},
        //                   icon: Icon(
        //                     MaterialCommunityIcons.tag_plus,
        //                     size: 17,
        //                   ),
        //                   label: Text(
        //                     'Agregar productos',
        //                     style: TextStyle(
        //                         fontFamily: 'Poppins-regular',
        //                         fontSize: 14,
        //                         color: Colors.grey.shade300),
        //                   ),
        //                   style: ElevatedButton.styleFrom(
        //                       primary: Colors.grey.shade500),
        //                 ),
        //               ),
        //             )
        //           : Container(
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(20),
        //               ),
        //               width: 340,
        //               height: 40,
        //               child: ClipRRect(
        //                 borderRadius: BorderRadius.circular(16),
        //                 child: ElevatedButton.icon(
        //                   onPressed: () {
        //                     // Agregar Productos
        //                     Navigator.pushNamed(context, 'catalogue');
        //                   },
        //                   icon: Icon(
        //                     MaterialCommunityIcons.tag_plus,
        //                     size: 17,
        //                   ),
        //                   label: Text(
        //                     'Agregar productos',
        //                     style: TextStyle(
        //                       fontFamily: 'Poppins-regular',
        //                       fontSize: 14,
        //                     ),
        //                   ),
        //                   style: ElevatedButton.styleFrom(
        //                     backgroundColor: myTheme.colorScheme.primary,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //       SizedBox(height: 10),
        //       products.isEmpty
        //           ? Container(
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(20),
        //               ),
        //               width: MediaQuery.of(context).size.width,
        //               height: 40,
        //               child: ClipRRect(
        //                 borderRadius: BorderRadius.circular(16),
        //                 child: ElevatedButton(
        //                   onPressed: () {},
        //                   style: ElevatedButton.styleFrom(
        //                     backgroundColor: Colors.grey.shade500,
        //                   ),
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       Text(
        //                         'CONTINUAR',
        //                         style: TextStyle(
        //                           fontFamily: 'Poppins-regular',
        //                           fontSize: 14,
        //                           color: Colors.grey.shade300,
        //                         ),
        //                       ),
        //                       Container(
        //                         margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
        //                         child: Icon(
        //                           SimpleLineIcons.arrow_right,
        //                           size: 14,
        //                           color: Colors.grey.shade300,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             )
        //           : Container(
        //               margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(20),
        //               ),
        //               width: MediaQuery.of(context).size.width,
        //               height: 40,
        //               child: ClipRRect(
        //                 borderRadius: BorderRadius.circular(16),
        //                 child: ElevatedButton(
        //                   onPressed: () {
        //                     // Continuar con la compra
        //                     // Navigator.push(
        //                     //   context,
        //                     //   MaterialPageRoute(
        //                     //     builder: (context) => CheckoutPage(
        //                     //         client: widget.client,
        //                     //         cart: products,
        //                     //         subTotalPrice: subTotalPrice),
        //                     //   ),
        //                     // );
        //                   },
        //                   style: ElevatedButton.styleFrom(
        //                     backgroundColor: myTheme.colorScheme.primary,
        //                   ),
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       Text(
        //                         'CONTINUAR',
        //                         style: TextStyle(
        //                           fontFamily: 'Poppins-regular',
        //                           fontSize: 14,
        //                         ),
        //                       ),
        //                       Container(
        //                         margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
        //                         child: Icon(
        //                           SimpleLineIcons.arrow_right,
        //                           size: 14,
        //                           color: Colors.grey.shade300,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
