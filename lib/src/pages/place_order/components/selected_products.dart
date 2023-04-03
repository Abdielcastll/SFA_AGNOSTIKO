import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/models/user_rol_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_rol_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/checkout_retail_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/checkout_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/widgets/mobile_scanner/mobile_scanner.dart';

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
  String? scanResult = '';
  late String? clientPriceList = widget.client?.prices;
  late Stream<List<ShoppingCartProduct>> streamShoppingCartProducts;

  @override
  void initState() {
    super.initState();
    streamShoppingCartProducts = objectBox.getShoppingCartProducts();
  }

  Future scanBarCode2() async {
    MobileScanner(
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          print('BARCODE 2: ${barcode.rawValue.toString()}');
        }
      },
    );
  }

  Future scanBarcode() async {
    String scanResult = '';
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancelar',
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      scanResult = "Failed to get platform version.";
      print(scanResult);
    }

    if (!mounted) return;

    setState(() {
      this.scanResult = scanResult;
    });
  }

  addProductFromBarcodeResult(
      String? scanResult, List<ShoppingCartProduct>? productsInCart) async {
    print('productsInCart: $productsInCart');
    final String? productScanResult = scanResult;
    print('BARCODE SCAN RESULT: ////////////////////////');
    print('ScanResult: $scanResult');
    List<ShoppingCartProduct> scannedProducts = [];
    try {
      final stockProducts = await FirebaseFirestore.instance
          .collection('stock')
          .doc('productos')
          .get()
          .then(
        (value) {
          return value['valores'];
        },
      );
      print(stockProducts);
      final priceProducts = await FirebaseFirestore.instance
          .collection('listas_de_precios')
          .doc(clientPriceList.toString())
          .get()
          .then((value) {
        return value['precios'];
      });
      print(priceProducts);

      await FirebaseFirestore.instance
          .collection('productos')
          .doc(productScanResult)
          .get()
          .then((doc) {
        const stock = 999;
        const productQuantity = 1;
        final code = doc.data().toString().contains('codigo')
            ? doc.get('codigo')
            : 'NaN';
        final pricesList = clientPriceList;
        final name = doc.data().toString().contains('nombre')
            ? doc.get('nombre')
            : 'NaN';
        final catalogue = doc.data().toString().contains('catalogo')
            ? doc.get('catalogo').id
            : 'NaN';
        final productPrice = priceProducts[doc.get('codigo')] ?? '0';
        final productTotalAmount = productPrice * productQuantity;

        print('stock:$stock');
        print('productQuantity:$productQuantity');
        print('code:$code');
        print('pricesList:$pricesList');
        print('name:$name');
        print('catalogue:$catalogue');
        print('productPrice:$productPrice');
        print('productTotalAmount:$productTotalAmount');

        if (productsInCart!.isEmpty) {
          print('Kaede empty');
          final result = ShoppingCartProduct(
            availableStock: stock,
            productQuantity: productQuantity,
            code: code,
            listOfPricesId: pricesList,
            name: name,
            productId: code,
            unitPrice: productPrice.toString(),
            totalAmount: productTotalAmount.toString(),
            urlPicture: catalogue.toString(),
          );
          print(result);
          scannedProducts.add(result);
          objectBox.insertShoppingCartProduct(result);
        } else {
          bool isProductAlreadyInCart = false;
          print('Kaede not empty');
          productsInCart.forEach((element) {
            if (element.code == code) {
              print('Kaede is already in the cart, increasing 1');
              isProductAlreadyInCart = true;

              Fluttertoast.showToast(msg: '${element.code} + 1');
              final result = ShoppingCartProduct(
                id: element.id,
                availableStock: element.availableStock,
                productQuantity: element.productQuantity! + 1,
                code: element.code,
                listOfPricesId: element.listOfPricesId,
                name: element.name,
                productId: code,
                unitPrice: element.unitPrice.toString(),
                totalAmount: element.totalAmount.toString(),
                urlPicture: element.urlPicture.toString(),
              );
              objectBox.insertShoppingCartProduct(result);
            }
          });
          if (isProductAlreadyInCart == false) {
            print('Kaede is not in the order, adding now');

            final result = ShoppingCartProduct(
              availableStock: stock,
              productQuantity: productQuantity,
              code: code,
              listOfPricesId: pricesList,
              name: name,
              productId: code,
              unitPrice: productPrice.toString(),
              totalAmount: productTotalAmount.toString(),
              urlPicture: catalogue.toString(),
            );
            objectBox.insertShoppingCartProduct(result);
          }
        }

        // productsInCart?.forEach((element) {
        //   if (element.code == code) {
        //     print('Kaede 1');
        //   } else {
        //     print('Kaede 2');
        //   }
        // });

        // final result = ShoppingCartProduct(
        //   availableStock: stock,
        //   productQuantity: productQuantity,
        //   code: code,
        //   listOfPricesId: pricesList,
        //   name: name,
        //   productId: code,
        //   unitPrice: productPrice.toString(),
        //   totalAmount: productTotalAmount.toString(),
        //   urlPicture: catalogue.toString(),
        // );
        // print(result);
        // scannedProducts.add(result);
        // objectBox.insertManyShoppingCartProducts(scannedProducts);
      });
    } catch (e) {
      print(e);
    }

    print(scannedProducts);
  }

  @override
  Widget build(BuildContext context) {
    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    final coinName = Provider.of<Coin?>(context)?.name ?? '';
    final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 0;
    final coinExchangeRatio = Provider.of<Coin?>(context)?.exchangeRatio ?? 0;
    final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '';
    final coinCode = Provider.of<Coin?>(context)?.code ?? '';
    print(coinName);
    print('TEStiNG COIN NAME');
    print("clientPriceList: $clientPriceList");
    final userRole = Provider.of<UserRole?>(context, listen: true);
    print('User Role ${userRole?.name}');
    print("Retail: ${userRole?.isRetail}");

    priceFormat(productPrice) {
      double correctAmount = double.parse(productPrice.toStringAsFixed(4));
      double convertedAmount = double.parse(
          (correctAmount * coinExchangeRatio).toStringAsFixed(coinDecimals));
      return '$coinSymbol$convertedAmount';
      // double correctAmount = double.parse(productPrice.toStringAsFixed(4));
      // if (currentCoin!.contains('USD')) {
      //   return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
      //       .format(productPrice)
      //       .toString();
      // } else if (currentCoin.contains('VED')) {
      //   return NumberFormat.currency(
      //     locale: 'es_VE',
      //     decimalDigits: 2,
      //     symbol: "Bs.",
      //   ).format(correctAmount * 4.58).toString();
      // } else if (currentCoin.contains('EUR')) {
      //   return NumberFormat.currency(
      //     locale: 'es_ES',
      //     decimalDigits: 2,
      //     symbol: '€',
      //   ).format(correctAmount * 0.89).toString();
      // } else if (currentCoin.contains('MXN')) {
      //   return NumberFormat.currency(
      //     locale: 'es_MX',
      //     decimalDigits: 2,
      //     symbol: '\$',
      //   ).format(correctAmount * 19.43);
      // } else if (currentCoin.contains('BTC')) {
      //   return '฿ ${(correctAmount * 0.00011).toString()}';
      // } else {
      //   return NumberFormat.currency(
      //     locale: 'es_VE',
      //     decimalDigits: 2,
      //     symbol: "PPR.",
      //   ).format(correctAmount * 4.58).toString();
      // }
    }

    return Column(
      children: [
        // Container(
        //   padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
        //   alignment: Alignment.topLeft,
        //   color: Colors.amber,
        //   // child: cartStatus(),
        // ),
        StreamBuilder<List<ShoppingCartProduct>?>(
          stream: streamShoppingCartProducts,
          builder: (context, snapshot) {
            var subTotal = 0.0;
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final products = snapshot.data;

              products?.forEach((product) {
                var totalAmount = (double.parse(product.totalAmount!) *
                        product.productQuantity!)
                    .toString();
                var myInt = double.parse(totalAmount);
                subTotal += myInt;
                print(subTotal);
              });

              return SingleChildScrollView(
                child: Container(
                  // color: Colors.green,
                  // margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.only(bottom: 10),
                  // height: MediaQuery.of(context).size.height * 0.70,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      products!.isEmpty
                          ? Container(
                              // color: Colors.amber,
                              height: MediaQuery.of(context).size.height * 0.46,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: Image.asset(
                                      'assets/images/placeholder_emptyorder.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                              height: MediaQuery.of(context).size.height * 0.46,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  final double productTotalByQuantity = double
                                          .parse(product.unitPrice.toString()) *
                                      int.parse(
                                          product.productQuantity.toString());
                                  final productPrice = double.parse(
                                      product.unitPrice.toString());

                                  return Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        16, 10, 16, 0),
                                    height: 95,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: myTheme.colorScheme.background,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FutureBuilder(
                                          future: FirebaseStorage.instance
                                              .ref()
                                              .child('imagenes')
                                              .child('catalogos')
                                              .child(
                                                  product.urlPicture.toString())
                                              .child('1')
                                              .getDownloadURL()
                                              .catchError((e) {
                                            print(e);
                                            print(
                                                'ERROR OBTENIENDO IMG DE PRODUCTO EN ARRITO');
                                          }),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final url =
                                                  snapshot.data!.toString();
                                              return Container(
                                                height: 95,
                                                width: 80,
                                                decoration: const BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    bottomLeft:
                                                        Radius.circular(8),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    bottomLeft:
                                                        Radius.circular(8),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: url,
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 80,
                                                      child: const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      'assets/images/noproduct.jpg',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Container(
                                                height: 95,
                                                width: 80,
                                                decoration: const BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    bottomLeft:
                                                        Radius.circular(8),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8)),
                                                  child: Image.asset(
                                                    'assets/images/noproduct.jpg',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return const SizedBox(
                                                width: 80,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 10, 0, 0),
                                                  color: Colors.transparent,
                                                  height: 50,
                                                  width: 180,
                                                  child: Text(
                                                    '${product.name}',
                                                    style: const TextStyle(
                                                      letterSpacing: 0.4,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          'Poppins-regular',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          15, 0, 0, 0),
                                                  color: Colors.transparent,
                                                  height: 30,
                                                  width: 30,
                                                  child: Material(
                                                    child: IconButton(
                                                      onPressed: () {
                                                        objectBox
                                                            .deleteShoppingCartProduct(
                                                                product.id);
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .delete_outline_rounded,
                                                        size: 20,
                                                        color: myTheme
                                                            .colorScheme
                                                            .onBackground
                                                            .withOpacity(0.7),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Material(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      height: 30,
                                                      child: Row(
                                                        children: [
                                                          product.productQuantity! >
                                                                  1
                                                              ? SizedBox(
                                                                  width: 30,
                                                                  child:
                                                                      IconButton(
                                                                    iconSize:
                                                                        16,
                                                                    splashRadius:
                                                                        1,
                                                                    icon: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: myTheme
                                                                          .colorScheme
                                                                          .onPrimaryContainer,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        final List<ShoppingCartProduct>
                                                                            updatedList =
                                                                            [];
                                                                        final updatedProduct =
                                                                            ShoppingCartProduct(
                                                                          id: product
                                                                              .id,
                                                                          productQuantity:
                                                                              product.productQuantity! - 1,
                                                                          code: product
                                                                              .code
                                                                              .toString(),
                                                                          productId: product
                                                                              .code
                                                                              .toString(),
                                                                          listOfPricesId: product
                                                                              .listOfPricesId
                                                                              .toString(),
                                                                          totalAmount:
                                                                              productPrice.toString(),
                                                                          name:
                                                                              product.name,
                                                                          unitPrice:
                                                                              productPrice.toString(),
                                                                          availableStock:
                                                                              product.availableStock,
                                                                          urlPicture:
                                                                              product.urlPicture,
                                                                        );
                                                                        updatedList
                                                                            .add(updatedProduct);
                                                                        objectBox
                                                                            .insertManyShoppingCartProducts(updatedList);
                                                                      });
                                                                    },
                                                                  ),
                                                                )
                                                              : SizedBox(
                                                                  width: 30,
                                                                  child: IconButton(
                                                                      iconSize: 16,
                                                                      splashRadius: 1,
                                                                      icon: const Icon(
                                                                        Icons
                                                                            .remove,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      onPressed: () {
                                                                        return;
                                                                      }),
                                                                ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0, 5, 0, 0),
                                                            child: Text(
                                                              'U: ${product.productQuantity}',
                                                              style:
                                                                  const TextStyle(
                                                                letterSpacing:
                                                                    0.4,
                                                                fontSize: 10,
                                                                fontFamily:
                                                                    'Poppins-regular',
                                                              ),
                                                            ),
                                                          ),
                                                          product.productQuantity! <
                                                                  product
                                                                      .availableStock!
                                                              ? SizedBox(
                                                                  width: 30,
                                                                  child:
                                                                      IconButton(
                                                                    iconSize:
                                                                        15,
                                                                    splashRadius:
                                                                        1,
                                                                    icon: Icon(
                                                                      Icons.add,
                                                                      color: myTheme
                                                                          .colorScheme
                                                                          .primary,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        final List<ShoppingCartProduct>
                                                                            updatedList =
                                                                            [];
                                                                        final updatedProduct =
                                                                            ShoppingCartProduct(
                                                                          id: product
                                                                              .id,
                                                                          productQuantity:
                                                                              product.productQuantity! + 1,
                                                                          code: product
                                                                              .code
                                                                              .toString(),
                                                                          productId: product
                                                                              .code
                                                                              .toString(),
                                                                          listOfPricesId: product
                                                                              .listOfPricesId
                                                                              .toString(),
                                                                          totalAmount:
                                                                              productPrice.toString(),
                                                                          name:
                                                                              product.name,
                                                                          unitPrice:
                                                                              productPrice.toString(),
                                                                          availableStock:
                                                                              product.availableStock,
                                                                          urlPicture:
                                                                              product.urlPicture,
                                                                        );
                                                                        updatedList
                                                                            .add(updatedProduct);
                                                                        objectBox
                                                                            .insertManyShoppingCartProducts(updatedList);
                                                                      });
                                                                    },
                                                                  ),
                                                                )
                                                              : SizedBox(
                                                                  width: 30,
                                                                  child:
                                                                      IconButton(
                                                                    iconSize:
                                                                        15,
                                                                    splashRadius:
                                                                        1,
                                                                    icon:
                                                                        const Icon(
                                                                      Icons.add,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      return;
                                                                    },
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .fromLTRB(2, 5, 0, 0),
                                                    child: Text(
                                                      'U/P: ${priceFormat(productPrice)}',
                                                      style: const TextStyle(
                                                        letterSpacing: 0.4,
                                                        fontSize: 10,
                                                        fontFamily:
                                                            'Poppins-regular',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 60,
                                                    alignment:
                                                        Alignment.topRight,
                                                    margin: const EdgeInsets
                                                        .fromLTRB(10, 0, 0, 0),
                                                    child: Text(
                                                      '${priceFormat(productTotalByQuantity)}',
                                                      style: const TextStyle(
                                                          letterSpacing: 0.4,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'Poppins-regular',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                      Container(
                        height: 133,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.orderSubTotal,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000C99),
                                    ),
                                  ),
                                  Text(
                                    priceFormat(subTotal),
                                    style: const TextStyle(
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000C99),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  width: 250,
                                  height: 40,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        final test =
                                            Provider.of<CounterLimitFirestore>(
                                                context,
                                                listen: false);
                                        Navigator.popUntil(
                                          context,
                                          (route) => route.isFirst,
                                        );
                                        test.setNewScreen(0);
                                      },
                                      icon: const Icon(
                                        MaterialCommunityIcons.tag_plus,
                                        size: 17,
                                      ),
                                      label: Text(
                                        AppLocalizations.of(context)!
                                            .addProducts,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          fontSize: 14,
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          myTheme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  width: 80,
                                  height: 40,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: FloatingActionButton(
                                      backgroundColor:
                                          myTheme.colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        print('sfsfsfsfaf');
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  NewBardcodeScanner(
                                                clientPriceList:
                                                    clientPriceList,
                                                products: products,
                                              ),
                                            ));
                                        // scanBarCode2();

                                        // scanBarcode().whenComplete(
                                        //   () {
                                        //     if (scanResult != '-1') {
                                        //       print("scanResult: $scanResult");
                                        //       Fluttertoast.showToast(
                                        //           msg: 'scanResult: $scanResult');
                                        //     }
                                        //   },
                                        // ).whenComplete(
                                        //   () {
                                        //     try {
                                        //       print(
                                        //           'Escaneando producto de la DB: ///////////////////');
                                        addProductFromBarcodeResult(
                                            scanResult.toString(), products);
                                        //     } catch (e) {
                                        //       print('ERROR //////////////////');
                                        //       print(e);
                                        //     }
                                        //   },
                                        // );
                                      },
                                      child: const Icon(FontAwesome.barcode),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Container(
                            //   height: 10,
                            //   color: Colors.black,
                            // ),
                            products.isEmpty
                                ? Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 0),
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
                                              margin: const EdgeInsets.fromLTRB(
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
                                    margin: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    width: 340,
                                    height: 40,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // print('Selected product Test prints');
                                          // print(
                                          //     'widget.client: ${widget.client!.name}');
                                          // print(
                                          //     'products: ${products.map((e) => e.name)}');
                                          // print('subTotal: ${subTotal}');
                                          userRole?.isRetail == false
                                              ? Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        //CheckoutPage
                                                        CheckoutPage(
                                                      client: widget.client,
                                                      cart: products,
                                                      subTotal: subTotal,
                                                    ),
                                                  ),
                                                )
                                              : Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CheckoutRetailPage(
                                                      client: widget.client,
                                                      cart: products,
                                                      subTotal: subTotal,
                                                    ),
                                                  ),
                                                );
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            myTheme.colorScheme.primary,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Continuar',
                                              style: TextStyle(
                                                fontFamily: 'Poppins-regular',
                                                fontSize: 14,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
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
      ],
    );
  }
}
