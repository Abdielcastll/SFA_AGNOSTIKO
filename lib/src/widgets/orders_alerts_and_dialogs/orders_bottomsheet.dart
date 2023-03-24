// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_rol_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
}) {
  showModalBottomSheet(
    elevation: 0,
    backgroundColor: Colors.white,
    barrierColor: myTheme.colorScheme.secondary.withOpacity(0.5),
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      final currentCoin =
          Provider.of<CurrencyProvider>(context).currentCurrency;

      priceFormat(productPrice) {
        double correctAmount = double.parse(productPrice.toStringAsFixed(4));
        if (currentCoin!.contains('USD')) {
          return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
              .format(productPrice)
              .toString();
        } else if (currentCoin.contains('VED')) {
          return NumberFormat.currency(
            locale: 'es_VE',
            decimalDigits: 2,
            symbol: "Bs.",
          ).format(correctAmount * 4.58).toString();
        } else if (currentCoin.contains('EUR')) {
          return NumberFormat.currency(
            locale: 'es_ES',
            decimalDigits: 2,
            symbol: '€',
          ).format(correctAmount * 0.89).toString();
        } else if (currentCoin.contains('MXN')) {
          return NumberFormat.currency(
            locale: 'es_MX',
            decimalDigits: 2,
            symbol: '\$',
          ).format(correctAmount * 19.43);
        } else if (currentCoin.contains('BTC')) {
          return '฿ ${(correctAmount * 0.00011).toStringAsFixed(3)}';
        } else {
          return NumberFormat.currency(
            locale: 'es_VE',
            decimalDigits: 2,
            symbol: "PPR.",
          ).format(correctAmount * 4.58).toString();
        }
      }

      return StatefulBuilder(
        builder: (context, setState) {
          doublePop() {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }

          print('Is user retail when opening this menu: $isRetail');

          // final userRole = Provider.of<UserRole?>(context, listen: true);
          // print(userRole);
          // print('User Role on Orders bottomSheet');

          return SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                      child: Text(
                        AppLocalizations.of(context)!.commentary,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: myTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Container(
                      width: 350,
                      height: 40,
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.fromLTRB(10, 15, 0, 10),
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: myTheme.colorScheme.primary),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ClientDetails(
                                        specialContribuyer: specialContributor,
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
                                style: TextButton.styleFrom(
                                  foregroundColor: myTheme.colorScheme.primary,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.seeClient,
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: myTheme.colorScheme.primary,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          title: Text(
                                            AppLocalizations.of(context)!.order,
                                            style: TextStyle(
                                              fontFamily: 'Poppins-regular',
                                              color:
                                                  myTheme.colorScheme.secondary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Column(
                                            children: [
                                              SingleChildScrollView(
                                                child: Container(
                                                  width: 300,
                                                  height: 300,
                                                  child: Scrollbar(
                                                    child: ListView.builder(
                                                      itemCount:
                                                          products.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final product =
                                                            products[index];
                                                        return ListTile(
                                                          leading: Icon(
                                                            Icons.photo,
                                                            color: Colors
                                                                .grey.shade400,
                                                          ),
                                                          title: Text(
                                                            '${product['nombre']}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-regular',
                                                              color: Colors.grey
                                                                  .shade400,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          subtitle: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                      '${product['codigo']} x ${product['cantidad']}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Poppins-regular',
                                                                        color: Colors
                                                                            .grey
                                                                            .shade400,
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      '${AppLocalizations.of(context)!.payable}:',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Poppins-regular',
                                                                        color: Colors
                                                                            .grey
                                                                            .shade400,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      priceFormat(
                                                                          product[
                                                                              'monto']),
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Poppins-regular',
                                                                        color: Colors
                                                                            .grey
                                                                            .shade400,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.bold,
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
                                              SizedBox(height: 30),
                                              Text(
                                                '${AppLocalizations.of(context)!.subtotal}: ${priceFormat(subTotal)}',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '${AppLocalizations.of(context)!.masterDiscount}: ${priceFormat(discountMaster)}',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '${AppLocalizations.of(context)!.tax}: ${priceFormat(tax)}',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '${AppLocalizations.of(context)!.totalToPay}: ${priceFormat(total)}',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  color: Colors.green,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 30),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .goBack,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-regular',
                                                        color: myTheme
                                                            .colorScheme
                                                            .primary,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: myTheme.colorScheme.primary,
                                ),
                                child: Text(
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
                            completed
                                ? Container()
                                : Container(
                                    width: 260,
                                    height: 40,
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: myTheme.colorScheme.primary),
                                    child: TextButton(
                                      onPressed: () {
                                        isRetail
                                            ? showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
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
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-regular',
                                                        color: myTheme
                                                            .colorScheme
                                                            .onPrimaryContainer,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    content: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .goBack,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-regular',
                                                              color: myTheme
                                                                  .colorScheme
                                                                  .primary,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 150,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                              color: myTheme
                                                                  .colorScheme
                                                                  .primary),
                                                          child: TextButton(
                                                            onPressed:
                                                                () async {
                                                              // Mandar pedido a proceso de pago retail una vez mas
                                                              final orderActive =
                                                                  Provider.of<
                                                                          OrderProvider>(
                                                                      context,
                                                                      listen:
                                                                          false);
                                                              List<ShoppingCartProduct>
                                                                  savedProducts =
                                                                  [];
                                                              print(
                                                                  'Activando pedido');
                                                              print(products);
                                                              Clients?
                                                                  oldClient =
                                                                  Clients(
                                                                active: client
                                                                    .active,
                                                                clientDocumentId:
                                                                    client
                                                                        .clientDocumentId,
                                                                dispatchAdress:
                                                                    client
                                                                        .dispatchAdress,
                                                                email: client
                                                                    .email,
                                                                fiscalAdress: client
                                                                    .fiscalAdress,
                                                                id: client.id,
                                                                idType: client
                                                                    .idType,
                                                                madeBy: client
                                                                    .madeBy,
                                                                masterDiscount:
                                                                    client
                                                                        .masterDiscount,
                                                                modified: client
                                                                    .modified,
                                                                name:
                                                                    client.name,
                                                                phone1: client
                                                                    .phone1,
                                                                phone2: client
                                                                    .phone2,
                                                                prices: client
                                                                    .prices,
                                                                prospect: client
                                                                    .prospect,
                                                                specialContributor:
                                                                    client
                                                                        .specialContributor,
                                                                zone:
                                                                    client.zone,
                                                              );

                                                              await products
                                                                  .forEach(
                                                                      (productValue) async {
                                                                // print(value[
                                                                //     'codigo']);
                                                                String?
                                                                    productCatalogueId;
                                                                String?
                                                                    promotion;
                                                                int?
                                                                    productAvaliableStock;
                                                                await productsCollection
                                                                    .where(
                                                                        'codigo',
                                                                        isEqualTo:
                                                                            productValue[
                                                                                'codigo'])
                                                                    .get()
                                                                    .then(
                                                                        (productDoc) {
                                                                  for (var element
                                                                      in productDoc
                                                                          .docs) {
                                                                    productCatalogueId = element
                                                                            .data()
                                                                            .toString()
                                                                            .contains(
                                                                                'catalogo')
                                                                        ? element
                                                                            .get('catalogo')
                                                                            .id
                                                                        : '';
                                                                    promotion = element
                                                                            .data()
                                                                            .toString()
                                                                            .contains(
                                                                                'promocion')
                                                                        ? element
                                                                            .get('promocion')
                                                                            .id
                                                                        : '';
                                                                  }
                                                                });
                                                                print(
                                                                    'test result $productCatalogueId');
                                                                print(
                                                                    'test result $promotion');
                                                                await stockCollection
                                                                    .doc(
                                                                        'productos')
                                                                    .get()
                                                                    .then(
                                                                        (stock) {
                                                                  productAvaliableStock = stock
                                                                          .data()
                                                                          .toString()
                                                                          .contains(
                                                                              'valores')
                                                                      ? stock.get(
                                                                              'valores')[
                                                                          '${productValue['codigo']}']
                                                                      : 0;
                                                                });
                                                                print(
                                                                    'test result: $productAvaliableStock');
                                                                ShoppingCartProduct
                                                                    productForCart =
                                                                    ShoppingCartProduct(
                                                                  availableStock:
                                                                      productAvaliableStock,
                                                                  code: productValue[
                                                                      'codigo'],
                                                                  listOfPricesId:
                                                                      productValue[
                                                                          'idListaDePrecios'],
                                                                  name: productValue[
                                                                      'nombre'],
                                                                  productId:
                                                                      productValue[
                                                                          'codigo'],
                                                                  productQuantity:
                                                                      productValue[
                                                                          'cantidad'],
                                                                  promotion:
                                                                      promotion,
                                                                  totalAmount: productValue[
                                                                          'precioUnitario']
                                                                      // productValue[
                                                                      //         'monto']
                                                                      .toString(),
                                                                  unitPrice: productValue[
                                                                          'precioUnitario']
                                                                      .toString(),
                                                                  urlPicture:
                                                                      productCatalogueId,
                                                                );
                                                                print(
                                                                    'Producto en carro creado');
                                                                print(
                                                                    productForCart
                                                                        .name);
                                                                objectBox
                                                                    .insertShoppingCartProduct(
                                                                        productForCart);
                                                                savedProducts.add(
                                                                    productForCart);
                                                              });
                                                              print(
                                                                  'LISTA DE PRODUCTOS $savedProducts');

                                                              orderActive
                                                                  .setOrder(
                                                                      true,
                                                                      oldClient);

                                                              deleteOrder(
                                                                  orderDocumentId,
                                                                  client
                                                                      .clientDocumentId);
                                                              ScaffoldMessenger
                                                                  .of(context)
                                                                ..removeCurrentSnackBar()
                                                                ..showSnackBar(
                                                                  SnackBar(
                                                                    backgroundColor: myTheme
                                                                        .colorScheme
                                                                        .primary,
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            2),
                                                                    content:
                                                                        const Text(
                                                                      "Orden retomada dentro del carrito",
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Poppins-regular',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              doublePop();
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  settings:
                                                                      const RouteSettings(
                                                                          name:
                                                                              "ORDER"),
                                                                  builder:
                                                                      (context) =>
                                                                          const OrderPage(),
                                                                ),
                                                              );
                                                            },
                                                            style: TextButton
                                                                .styleFrom(
                                                              foregroundColor:
                                                                  myTheme
                                                                      .colorScheme
                                                                      .primary,
                                                            ),
                                                            child: Text(
                                                              'Aceptar',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-regular',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                    (BuildContext context) {
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
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-regular',
                                                        color: myTheme
                                                            .colorScheme
                                                            .secondary,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    content: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .goBack,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-regular',
                                                              color: myTheme
                                                                  .colorScheme
                                                                  .primary,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 150,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                              color: myTheme
                                                                  .colorScheme
                                                                  .primary),
                                                          child: TextButton(
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
                                                            style: TextButton
                                                                .styleFrom(
                                                              foregroundColor:
                                                                  myTheme
                                                                      .colorScheme
                                                                      .primary,
                                                            ),
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .createInvoiceConfirmation,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-regular',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            myTheme.colorScheme.primary,
                                      ),
                                      child: Text(
                                        isRetail
                                            ? "Retomar pedido"
                                            : AppLocalizations.of(context)!
                                                .createInvoiceConfirmation,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                            Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.red),
                              child: IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          title: Text(
                                            AppLocalizations.of(context)!
                                                .orderDelete,
                                            style: TextStyle(
                                              fontFamily: 'Poppins-regular',
                                              color:
                                                  myTheme.colorScheme.secondary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .goBack,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-regular',
                                                    color: myTheme
                                                        .colorScheme.primary,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 150,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: myTheme
                                                      .colorScheme.primary,
                                                ),
                                                child: TextButton(
                                                  onPressed: () async {
                                                    // Eliminar Visita en proceso de DB
                                                    var result = deleteOrder(
                                                      orderDocumentId,
                                                      clientReferenceId,
                                                    );
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: myTheme
                                                        .colorScheme.primary,
                                                  ),
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .visitDelete,
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
                                        );
                                      });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                icon: const Icon(Icons.delete_forever_outlined,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
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
