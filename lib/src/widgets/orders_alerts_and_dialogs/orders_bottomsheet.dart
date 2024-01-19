// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';

void modalBottomSheetForOrders(
  bool completed,
  context,
  commentary,
  clientID,
  products,
  subTotal,
  discountMaster,
  tax,
  total,
  currentClientName,
  idType,
  id,
  specialContributor,
  currentClientPhone,
  currentClientEmail,
  currentClientAddress,
  currentClientDispatchAdress,
  currentClientZones,
  currentClientPrices,
  currentDiscountMaster,
  clientReferenceId,
  userUID,
  orderDocumentId,
  currentClientId,
  currentClientIdType,
  client,
  orderDate,
  correlativeNumber, {
  isRetail,
  showButton,
  coinExchangeRateFromDB,
}) {
  print('Print data de orderCard');
  print('+++++++++++++++++++++++++');
  print('completed: $completed,');
  print('  commentary: $commentary,');
  print('  clientID: $clientID,');
  print('  products: $products,');
  print('  subTotal: $subTotal,');
  print('  discountMaster: $discountMaster,');
  print('  tax: $tax,');
  print('  total: $total,');
  print('  currentClientName: $currentClientName,');
  print('  idType: $idType,');
  print('  id: $id,');
  print('  specialContributor: $specialContributor,');
  print('  currentClientPhone: $currentClientPhone,');
  print('  currentClientEmail: $currentClientEmail,');
  print('  currentClientAddress: $currentClientAddress,');
  print('  currentClientDispatchAdress: $currentClientDispatchAdress,');
  print('  currentClientZones: $currentClientZones,');
  print('  currentClientPrices: $currentClientPrices,');
  print('  currentDiscountMaster: $currentDiscountMaster,');
  print('  clientReferenceId: $clientReferenceId,');
  print('  userUID: $userUID,');
  print('  orderDocumentId: $orderDocumentId,');
  print('  currentClientId: $currentClientId,');
  print('  currentClientIdType: $currentClientIdType,');
  print('  client: $client,');
  print('  orderDate: $orderDate,');
  print('  correlativeNumber: $correlativeNumber,');
  // print('isRetai: $isRetail');
  // print(showButton);
  showModalBottomSheet(
    elevation: 0,
    backgroundColor: Colors.white,
    barrierColor: myTheme.colorScheme.secondary.withOpacity(0.5),
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    builder: (context) {
      final currentCoin =
          Provider.of<CurrencyProvider>(context).currentCurrency;
      List<String> currentCoinSplit = currentCoin!.split(' ');
      String currentCoinSelectedCode = currentCoinSplit.last;

      return MultiProvider(
        providers: [
          StreamProvider<Coin?>.value(
            initialData: Coin(),
            catchError: (context, error) {
              print(
                  'ERROR ON STREAM PROVIDER OF COINEXCHANGE RATES IN ADD CLIENT');
              print(error);
              return;
            },
            value: coinCollection
                .doc(currentCoinSelectedCode)
                .snapshots()
                .map(coinFromSnapshot),
          ),
        ],
        child: StatefulBuilder(
          builder: (context, setState) {
            final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 0;
            final coinExchangeRatio =
                Provider.of<Coin?>(context)?.exchangeRatio ?? 0;
            final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '';

            doublePop() {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }

            print('Is user retail when opening this menu: $isRetail');
            return SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        // margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: Text(
                          AppLocalizations.of(context)!.commentary,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: myTheme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      Container(
                        // width: 350,
                        height: 40,
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          border: Border.all(
                            color: myTheme.colorScheme.primary.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          commentary.toString().isNotEmpty
                              ? commentary.toString()
                              : AppLocalizations.of(context)!
                                  .commentaryUnavaliable,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 14,
                            color: myTheme.colorScheme.primary.withOpacity(0.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        child: Column(
                          children: [
                            Container(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ClientDetails(
                                          specialContribuyer:
                                              specialContributor,
                                          masterDiscount: currentDiscountMaster,
                                          fiscalAddress: currentClientAddress,
                                          email: currentClientEmail,
                                          listOfPrices: currentClientPrices,
                                          name: currentClientName,
                                          tlf1: currentClientPhone,
                                          tlf2: currentClientPhone,
                                          zone: currentClientZones,
                                          nameId: currentClientId,
                                          typeId: currentClientIdType,
                                          clientDocumentReferenceID:
                                              clientReferenceId,
                                          dispatchAddress:
                                              currentClientDispatchAdress,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.person),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      myTheme.colorScheme.primary,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                  ),
                                  label: Text(
                                    AppLocalizations.of(context)!.seeClient,
                                    style: TextStyle(
                                      fontFamily: 'Poppins-regular',
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // const SizedBox(width: 15),
                                Container(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SeeProductsAlertDialog(
                                              products: products,
                                              discountMaster: discountMaster,
                                              subTotal: subTotal,
                                              tax: tax,
                                              total: total,
                                              coinDecimals: coinDecimals,
                                              coinExchangeRatio: double.parse(
                                                  coinExchangeRatio.toString()),
                                              coinSymbol: coinSymbol,
                                              coinExchangeRateFromDB:
                                                  coinExchangeRateFromDB,
                                            );
                                          });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        myTheme.colorScheme.primary,
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                      ),
                                    ),
                                    icon: Icon(Icons.shopping_basket_rounded),
                                    label: Text(
                                      AppLocalizations.of(context)!.seeProducts,
                                      style: TextStyle(
                                        fontFamily: 'Poppins-regular',
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  // color: Colors.red,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      completed
                                          ? Container()
                                          : !showButton
                                              ? Container()
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.75,
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 0),
                                                  child: ElevatedButton.icon(
                                                    onPressed: () {
                                                      isRetail
                                                          ? showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                print(
                                                                    'Retomar proceso de Retail');
                                                                return AlertDialog(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  title: Text(
                                                                    '¿Quiere volver a activar el pedido?',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Poppins-regular',
                                                                      color: myTheme
                                                                          .colorScheme
                                                                          .onPrimaryContainer,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  content: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          AppLocalizations.of(context)!
                                                                              .goBack,
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Poppins-regular',
                                                                            color:
                                                                                myTheme.colorScheme.primary,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            150,
                                                                        height:
                                                                            40,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                            color: myTheme.colorScheme.primary),
                                                                        child:
                                                                            TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            // Mandar pedido a proceso de pago retail una vez mas
                                                                            final orderActive =
                                                                                Provider.of<OrderProvider>(context, listen: false);
                                                                            List<ShoppingCartProduct>
                                                                                savedProducts =
                                                                                [];
                                                                            print('Activando pedido');
                                                                            print(products);
                                                                            Clients?
                                                                                oldClient =
                                                                                Clients(
                                                                              active: client.active,
                                                                              clientDocumentId: client.clientDocumentId,
                                                                              dispatchAdress: client.dispatchAdress,
                                                                              email: client.email,
                                                                              fiscalAdress: client.fiscalAdress,
                                                                              id: client.id,
                                                                              idType: client.idType,
                                                                              madeBy: client.madeBy,
                                                                              masterDiscount: client.masterDiscount,
                                                                              modified: client.modified,
                                                                              name: client.name,
                                                                              phone1: client.phone1,
                                                                              phone2: client.phone2,
                                                                              prices: client.prices,
                                                                              prospect: client.prospect,
                                                                              specialContributor: client.specialContributor,
                                                                              zone: client.zone,
                                                                            );
                                                                            await products.forEach((productValue) async {
                                                                              // print(value[
                                                                              //     'codigo']);
                                                                              String? productCatalogueId;
                                                                              String? promotion;
                                                                              int? productAvaliableStock;
                                                                              await productsCollection.where('codigo', isEqualTo: productValue['codigo']).get().then((productDoc) {
                                                                                for (var element in productDoc.docs) {
                                                                                  productCatalogueId = element.data().toString().contains('catalogo') ? element.get('catalogo').id : '';
                                                                                  promotion = element.data().toString().contains('promocion') ? element.get('promocion').id : '';
                                                                                }
                                                                              });
                                                                              print('test result $productCatalogueId');
                                                                              print('test result $promotion');
                                                                              await stockCollection.doc('productos').get().then((stock) {
                                                                                productAvaliableStock = stock.data().toString().contains('valores') ? stock.get('valores')['${productValue['codigo']}'] : 0;
                                                                              });
                                                                              print('test result: $productAvaliableStock');
                                                                              ShoppingCartProduct productForCart = ShoppingCartProduct(
                                                                                availableStock: productAvaliableStock,
                                                                                code: productValue['codigo'],
                                                                                listOfPricesId: productValue['idListaDePrecios'],
                                                                                name: productValue['nombre'],
                                                                                productId: productValue['codigo'],
                                                                                productQuantity: productValue['cantidad'],
                                                                                promotion: promotion,
                                                                                totalAmount: productValue['precioUnitario']
                                                                                    // productValue[
                                                                                    //         'monto']
                                                                                    .toString(),
                                                                                unitPrice: productValue['precioUnitario'].toString(),
                                                                                urlPicture: productCatalogueId,
                                                                              );
                                                                              print('Producto en carro creado');
                                                                              print(productForCart.name);
                                                                              objectBox.insertShoppingCartProduct(productForCart);
                                                                              savedProducts.add(productForCart);
                                                                            });
                                                                            print('LISTA DE PRODUCTOS $savedProducts');
                                                                            orderActive.setOrder(true,
                                                                                oldClient);
                                                                            deleteOrder(orderDocumentId,
                                                                                client.clientDocumentId);
                                                                            ScaffoldMessenger.of(context)
                                                                              ..removeCurrentSnackBar()
                                                                              ..showSnackBar(
                                                                                SnackBar(
                                                                                  backgroundColor: myTheme.colorScheme.primary,
                                                                                  duration: const Duration(seconds: 2),
                                                                                  content: const Text(
                                                                                    "Orden retomada dentro del carrito",
                                                                                    style: TextStyle(
                                                                                      fontFamily: 'Poppins-regular',
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            doublePop();
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                settings: const RouteSettings(name: "ORDER"),
                                                                                builder: (context) => const OrderPage(),
                                                                              ),
                                                                            );
                                                                          },
                                                                          style:
                                                                              TextButton.styleFrom(
                                                                            foregroundColor:
                                                                                myTheme.colorScheme.primary,
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            'Aceptar',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Poppins-regular',
                                                                              color: Colors.white,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              })
                                                          : showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  title: Text(
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .createInvoice,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Poppins-regular',
                                                                      color: myTheme
                                                                          .colorScheme
                                                                          .primary,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  content: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .arrow_back_ios,
                                                                          size:
                                                                              15,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(
                                                                            myTheme.colorScheme.onPrimaryContainer,
                                                                          ),
                                                                          shape:
                                                                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(18.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child: ElevatedButton
                                                                            .icon(
                                                                          onPressed:
                                                                              () async {
                                                                            // Mandar pedido a Facturar
                                                                            await createInvoice(
                                                                              client,
                                                                              discountMaster,
                                                                              orderDate,
                                                                              tax,
                                                                              total,
                                                                              orderDocumentId,
                                                                              subTotal,
                                                                              userUID,
                                                                            );
                                                                            doublePop();
                                                                          },
                                                                          style:
                                                                              ButtonStyle(
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(
                                                                              myTheme.colorScheme.onPrimaryContainer,
                                                                            ),
                                                                            shape:
                                                                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                              RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(18.0),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          icon:
                                                                              Icon(Icons.inventory_outlined),
                                                                          label:
                                                                              Text(
                                                                            AppLocalizations.of(context)!.createInvoiceConfirmation,
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Poppins-regular',
                                                                              color: Colors.white,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                    },
                                                    icon: Icon(Icons
                                                        .inventory_outlined),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        myTheme.colorScheme
                                                            .onPrimaryContainer,
                                                      ),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      18.0),
                                                        ),
                                                      ),
                                                    ),
                                                    label: Text(
                                                      isRetail
                                                          ? "Retomar pedido"
                                                          : "Aprobar pedido",
                                                      // AppLocalizations.of(
                                                      //         context)!
                                                      //     .createInvoiceConfirmation,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-regular',
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                completed
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            // margin: const EdgeInsets.only(right: 20),
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  myTheme.colorScheme.error,
                                              child: IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return DeleteOrderAlertDialog(
                                                          clientReferenceId:
                                                              clientReferenceId,
                                                          orderDocumentId:
                                                              orderDocumentId,
                                                          coinExchangeRateFromDB:
                                                              coinExchangeRateFromDB,
                                                        );
                                                      });
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                    ),
                                                  ),
                                                ),
                                                icon: const Icon(
                                                    MaterialCommunityIcons
                                                        .delete_circle_outline,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

class DeleteOrderAlertDialog extends StatelessWidget {
  const DeleteOrderAlertDialog({
    super.key,
    required this.orderDocumentId,
    required this.clientReferenceId,
    required this.coinExchangeRateFromDB,
  });

  final orderDocumentId;
  final clientReferenceId;
  final coinExchangeRateFromDB;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        AppLocalizations.of(context)!.orderDelete,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Poppins-regular',
          color: myTheme.colorScheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                myTheme.colorScheme.primary,
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            icon: Icon(
              Icons.arrow_back_ios,
              size: 15,
              color: Colors.white,
            ),
          ),
          Container(
            child: ElevatedButton(
              onPressed: () async {
                // Eliminar Visita en proceso de DB
                await deleteOrder(
                  orderDocumentId,
                  clientReferenceId,
                );
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      backgroundColor: myTheme.colorScheme.onPrimaryContainer,
                      duration: const Duration(seconds: 2),
                      content: const Text(
                        "Pedido seleccionado eliminado",
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                        ),
                      ),
                    ),
                  );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  myTheme.colorScheme.onPrimaryContainer,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.visitDelete,
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SeeProductsAlertDialog extends StatelessWidget {
  const SeeProductsAlertDialog({
    super.key,
    required this.products,
    required this.subTotal,
    required this.discountMaster,
    required this.tax,
    required this.total,
    required this.coinDecimals,
    required this.coinExchangeRatio,
    required this.coinSymbol,
    required this.coinExchangeRateFromDB,
  });
  final products;
  final double subTotal;
  final double discountMaster;
  final double tax;
  final double total;
  final int coinDecimals;
  final double coinExchangeRatio;
  final String coinSymbol;
  final coinExchangeRateFromDB;

  @override
  Widget build(BuildContext context) {
    var subTotalConverted = priceMultipliedByItsExchangeRatio2(
        productPrice: subTotal,
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRateFromDB);
    var subTotalFormatted =
        formatDecimalPriceByRegion(price: subTotalConverted);

    var discountConverted = priceMultipliedByItsExchangeRatio2(
        productPrice: discountMaster,
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRateFromDB);
    var discountFormatted =
        formatDecimalPriceByRegion(price: discountConverted);

    var taxConverted = priceMultipliedByItsExchangeRatio2(
        productPrice: tax,
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRateFromDB);
    var taxFormatted = formatDecimalPriceByRegion(price: taxConverted);

    var totalConverted = priceMultipliedByItsExchangeRatio2(
        productPrice: total,
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRateFromDB);
    var totalFormatted = formatDecimalPriceByRegion(price: totalConverted);

    return AlertDialog(
      actionsOverflowButtonSpacing: 1,
      actionsPadding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        AppLocalizations.of(context)!.order,
        style: TextStyle(
          fontFamily: 'Poppins-regular',
          color: myTheme.colorScheme.onPrimaryContainer,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            child: Container(
              // color: Colors.red,
              width: 300,
              // height: 200,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    var priceConverted = priceMultipliedByItsExchangeRatio2(
                        productPrice: product['monto'],
                        coinDecimals: coinDecimals,
                        coinExchangeRatio: coinExchangeRateFromDB);
                    var priceFormatted =
                        formatDecimalPriceByRegion(price: priceConverted);

                    return ListTile(
                      leading: Icon(
                        Icons.photo,
                        color: myTheme.colorScheme.secondary,
                      ),
                      title: Text(
                        '${product['nombre']}',
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          color: myTheme.colorScheme.secondary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Text(
                                    '${product['codigo']} x ${product['cantidad']}',
                                    style: TextStyle(
                                      fontFamily: 'Poppins-regular',
                                      color: myTheme.colorScheme.secondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${AppLocalizations.of(context)!.payable}:',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    color: myTheme.colorScheme.secondary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '$coinSymbol $priceFormatted',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    color: myTheme.colorScheme.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context)!.subtotal}: ',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$coinSymbol $subTotalFormatted',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context)!.masterDiscount}: ',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$coinSymbol $discountFormatted',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context)!.tax}: ',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$coinSymbol $taxFormatted',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total a Pagar',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$coinSymbol $totalFormatted',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // SizedBox(height: 30),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  myTheme.colorScheme.primary,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              icon: Icon(
                Icons.arrow_back_ios,
                size: 15,
                color: Colors.white,
              ),
              label: Text(
                AppLocalizations.of(context)!.goBack,
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TextBoxWidget extends StatelessWidget {
  const TextBoxWidget({
    Key? key,
    this.message,
  }) : super(key: key);

  final message;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(10, 15, 0, 10),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(
          color: myTheme.colorScheme.primary.withOpacity(0.5),
        ),
      ),
      child: Text(
        '$message',
        style: TextStyle(
          fontFamily: 'Poppins-regular',
          fontSize: 14,
          color: myTheme.colorScheme.primary.withOpacity(0.5),
        ),
      ),
    );
  }
}
