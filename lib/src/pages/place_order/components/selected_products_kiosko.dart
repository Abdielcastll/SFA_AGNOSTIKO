// ignore_for_file: prefer_const_constructors

import 'package:agnostiko/device/src/device.dart';
import 'package:agnostiko/scanner/src/scanner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/checkout_retail_page.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/widgets/mobile_scanner/mobile_scanner.dart';

class SelectedProductsKiosko extends StatefulWidget {
  const SelectedProductsKiosko({
    Key? key,
    required this.client,
  }) : super(key: key);

  final Clients? client;

  @override
  State<SelectedProductsKiosko> createState() => _SelectedProductsKioskoState();
}

class _SelectedProductsKioskoState extends State<SelectedProductsKiosko> {
  DeviceType? deviceType;
  bool hasLaserScanner = false;
  late String? clientPriceList = widget.client?.prices;
  late Stream<List<ShoppingCartProduct>> streamShoppingCartProducts;

  @override
  void initState() {
    super.initState();
    streamShoppingCartProducts = objectBox.getShoppingCartProducts();
    localGetDeviceType();
  }

  localGetDeviceType() async {
    final dType = await getDeviceType();
    final platformInfo = await getPlatformInfo();
    setState(() {
      hasLaserScanner = platformInfo.hasScannerHw;
      deviceType = dType;
    });
  }

  addProductFromBarcodeResult(
      String? scanResult, List<ShoppingCartProduct>? productsInCart) async {
    print('productsInCart: $productsInCart');
    final String? productScanResult = scanResult;
    print('BARCODE SCAN RESULT: ////////////////////////');
    print('ScanResult: $scanResult');
    List<ShoppingCartProduct> scannedProducts = [];

    if (scanResult == '') return;

    Fluttertoast.showToast(msg: 'Cargando producto $scanResult', fontSize: 20);

    try {
      // print(stockProducts);
      final priceProducts = await listaDePreciosRef
          .doc(clientPriceList.toString())
          .get()
          .then((value) {
        return value['precios'];
      });
      print(priceProducts);

      await productosRef.doc(productScanResult).get().then((doc) {
        if (!doc.exists) {
          Fluttertoast.showToast(
              msg: 'Producto no encontrado $scanResult',
              fontSize: 20,
              backgroundColor: Colors.red.shade700);
        }
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
          print('cart is not empty');
          productsInCart.forEach((element) {
            if (element.code == code) {
              print('product is already in the cart, increasing 1');
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
            print('product is not in the order, adding now');

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
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Producto no encontrado $scanResult',
          fontSize: 20,
          backgroundColor: Colors.red.shade700);
      print(e);
    }

    print(scannedProducts);
  }

  @override
  Widget build(BuildContext context) {
    final coinName = Provider.of<Coin?>(context)?.name ?? '';
    final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 2;
    final coinExchangeRatio = Provider.of<Coin?>(context)?.exchangeRatio ?? 1;
    final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '';

    return coinName == '' || deviceType == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              SizedBox(height: 100),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          )
        : Column(
            children: [
              StreamBuilder<List<ShoppingCartProduct>?>(
                stream: streamShoppingCartProducts,
                builder: (context, snapshot) {
                  var subTotal = Decimal.parse('0.00');

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final products = snapshot.data;
                    products?.forEach((product) {
                      var totalAmount =
                          Decimal.parse(product.totalAmount.toString()) *
                              Decimal.parse(product.productQuantity.toString());
                      subTotal += totalAmount;
                    });

                    var subTotalConverted = priceMultipliedByItsExchangeRatio2(
                        productPrice: subTotal,
                        coinDecimals: coinDecimals,
                        coinExchangeRatio: coinExchangeRatio);

                    var subTotalFormatted =
                        formatDecimalPriceByRegion(price: subTotalConverted);

                    return BarcodeKeyboardListener(
                      bufferDuration: Duration(milliseconds: 500),
                      onBarcodeScanned: (barcode) {
                        print(barcode);
                        addProductFromBarcodeResult(barcode, products);
                      },
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              products!.isEmpty
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.40,
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                deviceType != DeviceType.PINPAD
                                                    ? 'Inicia un escaneo dando click en el botón'
                                                    : 'Acerca el código de barras al escáner.',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-medium',
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Image.asset(
                                              'assets/images/scan_barcode.png',
                                              height: 150,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.45,
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: products.length,
                                        itemBuilder: (context, index) {
                                          final ShoppingCartProduct product =
                                              products[index];
                                          var productPrice = Decimal.parse(
                                            product.unitPrice.toString(),
                                          );

                                          var productPriceConverted =
                                              // final double productPriceConverted =
                                              priceMultipliedByItsExchangeRatio2(
                                                  productPrice: productPrice,
                                                  coinDecimals: coinDecimals,
                                                  coinExchangeRatio:
                                                      coinExchangeRatio);

                                          var productPriceConvertedFormatted =
                                              formatDecimalPriceByRegion(
                                                  price: productPriceConverted);

                                          var productTotalByQuantity =
                                              Decimal.parse(
                                                    product.unitPrice
                                                        .toString(),
                                                  ) *
                                                  Decimal.parse(
                                                    product.productQuantity
                                                        .toString(),
                                                  );

                                          var productTotalByQuantityConverted =
                                              priceMultipliedByItsExchangeRatio2(
                                            productPrice:
                                                productTotalByQuantity,
                                            coinDecimals: coinDecimals,
                                            coinExchangeRatio:
                                                coinExchangeRatio,
                                          );

                                          var productTotalByQuantityConvertedFormatted =
                                              formatDecimalPriceByRegion(
                                            price:
                                                productTotalByQuantityConverted,
                                          );

                                          return Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                16, 10, 16, 0),
                                            height: 95,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: myTheme
                                                  .colorScheme.background,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FutureBuilder(
                                                  future: storage
                                                      .ref()
                                                      .child('imagenes')
                                                      .child('catalogos')
                                                      .child(product.urlPicture
                                                          .toString())
                                                      .child('1')
                                                      .getDownloadURL()
                                                      .catchError((e) {
                                                    print(e);
                                                    print(
                                                        'ERROR OBTENIENDO IMG DE PRODUCTO EN ARRITO');
                                                    return e.message;
                                                  }),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      final url = snapshot.data!
                                                          .toString();
                                                      return Container(
                                                        height: 95,
                                                        width: 80,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    8),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    8),
                                                          ),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    8),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    8),
                                                          ),
                                                          child:
                                                              CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            imageUrl: url,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 80,
                                                              child:
                                                                  const Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              ),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Image.asset(
                                                              'assets/images/noproduct.jpg',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Container(
                                                        height: 95,
                                                        width: 80,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    8),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    8),
                                                          ),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          8),
                                                                  bottomLeft: Radius
                                                                      .circular(
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
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  10, 10, 0, 0),
                                                          color: Colors
                                                              .transparent,
                                                          height: 50,
                                                          width: 180,
                                                          child: Text(
                                                            '${product.name}',
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
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  15, 0, 0, 0),
                                                          height: 30,
                                                          width: 30,
                                                          child: Material(
                                                            child: IconButton(
                                                              onPressed: () {
                                                                objectBox
                                                                    .deleteShoppingCartProduct(
                                                                        product
                                                                            .id);
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .delete_outline_rounded,
                                                                size: 20,
                                                                color: myTheme
                                                                    .colorScheme
                                                                    .error,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Material(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              height: 30,
                                                              child: Row(
                                                                children: [
                                                                  product.productQuantity! >
                                                                          1
                                                                      ? Container(
                                                                          width:
                                                                              30,
                                                                          margin:
                                                                              EdgeInsets.fromLTRB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            0,
                                                                          ),
                                                                          // color: Colors
                                                                          //     .red,
                                                                          child:
                                                                              IconButton(
                                                                            iconSize:
                                                                                15,
                                                                            splashRadius:
                                                                                15,
                                                                            icon:
                                                                                Icon(
                                                                              Icons.remove,
                                                                              color: myTheme.colorScheme.onPrimaryContainer,
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                final List<ShoppingCartProduct> updatedList = [];
                                                                                final updatedProduct = ShoppingCartProduct(
                                                                                  id: product.id,
                                                                                  productQuantity: product.productQuantity! - 1,
                                                                                  code: product.code.toString(),
                                                                                  productId: product.code.toString(),
                                                                                  listOfPricesId: product.listOfPricesId.toString(),
                                                                                  totalAmount: productPrice.toString(),
                                                                                  name: product.name,
                                                                                  unitPrice: productPrice.toString(),
                                                                                  availableStock: product.availableStock,
                                                                                  urlPicture: product.urlPicture,
                                                                                );
                                                                                updatedList.add(updatedProduct);
                                                                                objectBox.insertManyShoppingCartProducts(updatedList);
                                                                              });
                                                                            },
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          margin:
                                                                              EdgeInsets.fromLTRB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            0,
                                                                          ),
                                                                          width:
                                                                              30,
                                                                          child: IconButton(
                                                                              iconSize: 15,
                                                                              splashRadius: 15,
                                                                              icon: const Icon(
                                                                                Icons.remove,
                                                                                color: Colors.grey,
                                                                              ),
                                                                              onPressed: () {
                                                                                return;
                                                                              }),
                                                                        ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    margin: const EdgeInsets
                                                                        .fromLTRB(
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0,
                                                                    ),
                                                                    width: 30,
                                                                    child: Text(
                                                                      '${product.productQuantity}',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'Poppins-regular',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  product.productQuantity! <
                                                                          product
                                                                              .availableStock!
                                                                      ? Container(
                                                                          margin:
                                                                              EdgeInsets.fromLTRB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            0,
                                                                          ),
                                                                          width:
                                                                              30,
                                                                          // color: Colors
                                                                          //     .red,
                                                                          child:
                                                                              IconButton(
                                                                            iconSize:
                                                                                15,
                                                                            splashRadius:
                                                                                15,
                                                                            icon:
                                                                                Icon(
                                                                              Icons.add,
                                                                              color: myTheme.colorScheme.primary,
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                final List<ShoppingCartProduct> updatedList = [];
                                                                                final updatedProduct = ShoppingCartProduct(
                                                                                  id: product.id,
                                                                                  productQuantity: product.productQuantity! + 1,
                                                                                  code: product.code.toString(),
                                                                                  productId: product.code.toString(),
                                                                                  listOfPricesId: product.listOfPricesId.toString(),
                                                                                  totalAmount: productPrice.toString(),
                                                                                  name: product.name,
                                                                                  unitPrice: productPrice.toString(),
                                                                                  availableStock: product.availableStock,
                                                                                  urlPicture: product.urlPicture,
                                                                                );
                                                                                updatedList.add(updatedProduct);
                                                                                objectBox.insertManyShoppingCartProducts(updatedList);
                                                                              });
                                                                            },
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          margin:
                                                                              EdgeInsets.fromLTRB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            0,
                                                                          ),
                                                                          width:
                                                                              30,
                                                                          child:
                                                                              IconButton(
                                                                            iconSize:
                                                                                15,
                                                                            splashRadius:
                                                                                15,
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.add,
                                                                              color: Colors.grey,
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
                                                            margin:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 0, 0, 0),
                                                            child: Text(
                                                              'U/P:$coinSymbol $productPriceConvertedFormatted',
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
                                                          Container(
                                                            width: 60,
                                                            alignment: Alignment
                                                                .centerRight,
                                                            margin:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    10,
                                                                    0,
                                                                    0,
                                                                    0),
                                                            child: Text(
                                                              '$coinSymbol $productTotalByQuantityConvertedFormatted',
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: const TextStyle(
                                                                  letterSpacing:
                                                                      0.4,
                                                                  fontSize: 10,
                                                                  fontFamily:
                                                                      'Poppins-regular',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
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
                                alignment: Alignment.bottomCenter,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(height: 10),
                                    /* Quitar boton de scaner para el apk del pinpad */

                                    if (deviceType != DeviceType.PINPAD)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            width: 160,
                                            height: 56,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: ElevatedButton.icon(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          myTheme.colorScheme
                                                              .primary),
                                                  foregroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white),
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  if (hasLaserScanner) {
                                                    final content =
                                                        await startScannerHw(
                                                            timeout: 30);
                                                    var scanResult =
                                                        content?.trim();
                                                    addProductFromBarcodeResult(
                                                      scanResult,
                                                      products,
                                                    );
                                                  } else {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            NewBardcodeScanner(
                                                          clientPriceList:
                                                              clientPriceList,
                                                          products: products,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                label: Text(
                                                  'Escanear código',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        'Poppins-medium',
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                icon: const Icon(
                                                  MaterialCommunityIcons
                                                      .barcode_scan,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    /* Aqui termina el row del escaner a comentar para pinpad */
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      margin: const EdgeInsets.fromLTRB(
                                          16, 16, 16, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            // AppLocalizations.of(context)!
                                            //     .orderSubTotal,
                                            'Subtotal',
                                            style: const TextStyle(
                                              fontFamily: 'Poppins-regular',
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '$coinSymbol $subTotalFormatted',
                                            style: const TextStyle(
                                              fontFamily: 'Poppins-regular',
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      height: 52,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: ElevatedButton(
                                          onPressed: products.isEmpty
                                              ? null
                                              : () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CheckoutRetailPage(
                                                        client: widget.client,
                                                        cart: products,
                                                        subTotal: double.parse(
                                                          subTotal.toString(),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.pressed)) {
                                                  return myTheme
                                                      .colorScheme.primary
                                                      .withOpacity(0.8);
                                                } else if (states.contains(
                                                    MaterialState.disabled)) {
                                                  return Colors.grey.shade500;
                                                } else {
                                                  return myTheme
                                                      .colorScheme.primary;
                                                }
                                              },
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(),
                                              Text(
                                                'Continuar',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-medium',
                                                  fontSize: 14,
                                                  color: products.isEmpty
                                                      ? Colors.grey.shade700
                                                      : Colors.white,
                                                ),
                                              ),
                                              Icon(
                                                SimpleLineIcons.arrow_right,
                                                size: 14,
                                                color: products.isEmpty
                                                    ? Colors.grey.shade700
                                                    : Colors.grey.shade300,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
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
