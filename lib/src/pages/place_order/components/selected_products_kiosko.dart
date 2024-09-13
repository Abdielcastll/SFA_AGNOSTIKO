// ignore_for_file: prefer_const_constructors

import 'package:agnostiko/device/src/device.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/components/product_list_button_kiosko.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/add_payment.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/payment_method_dialog_kiosko.dart';
import 'package:pwa_sales2go_flutter/src/services/connection_service.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/custom_cache_manager.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';

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
    final String? productScanResult = scanResult;
    List<ShoppingCartProduct> scannedProducts = [];

    if (scanResult == '') return;

    try {
      final priceProducts = await listaDePreciosRef
          .doc(clientPriceList.toString())
          .get()
          .then((value) {
        return value['precios'];
      });

      await productosRef
          .where('codigoBarra', isEqualTo: productScanResult)
          .get()
          .then(
        (docs) {
          var doc = docs.docs.first;
          if (!doc.exists) {
            Fluttertoast.showToast(
                gravity: ToastGravity.TOP,
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
            scannedProducts.add(result);
            objectBox.insertShoppingCartProduct(result);
            Fluttertoast.showToast(
              gravity: ToastGravity.TOP,
              msg: 'Se ha agregado exitosamente al carrito',
              fontSize: 20,
              backgroundColor: const Color.fromARGB(255, 149, 231, 184),
            );
          } else {
            bool isProductAlreadyInCart = false;
            productsInCart.forEach((element) {
              if (element.code == code) {
                isProductAlreadyInCart = true;
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
                Fluttertoast.showToast(
                  gravity: ToastGravity.TOP,
                  msg: 'Se ha agregado exitosamente al carrito',
                  fontSize: 20,
                  backgroundColor: const Color.fromARGB(255, 149, 231, 184),
                );
              }
            });
            if (isProductAlreadyInCart == false) {
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
              Fluttertoast.showToast(
                gravity: ToastGravity.TOP,
                msg: 'Se ha agregado exitosamente al carrito',
                fontSize: 20,
                backgroundColor: const Color.fromARGB(255, 149, 231, 184),
              );
            }
          }
        },
      );
    } catch (e) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
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
    final userUid = Provider.of<UserModel>(context).uid;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

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

                    Decimal tax =
                        Decimal.parse((subTotal.toDouble() * 0.16).toString());
                    Decimal total = Decimal.parse(
                        (tax.toDouble() + subTotal.toDouble()).toString());

                    var subTotalConverted = priceMultipliedByItsExchangeRatio2(
                      productPrice: subTotal,
                      coinDecimals: coinDecimals,
                      coinExchangeRatio: coinExchangeRatio,
                    );

                    var ivaConverted = priceMultipliedByItsExchangeRatio2(
                      productPrice: tax,
                      coinDecimals: coinDecimals,
                      coinExchangeRatio: coinExchangeRatio,
                    );

                    var totalConverted = priceMultipliedByItsExchangeRatio2(
                      productPrice: total,
                      coinDecimals: coinDecimals,
                      coinExchangeRatio: coinExchangeRatio,
                    );

                    var subTotalFormatted =
                        formatDecimalPriceByRegion(price: subTotalConverted);

                    var ivaFormatted =
                        formatDecimalPriceByRegion(price: ivaConverted);

                    var totalFormatted =
                        formatDecimalPriceByRegion(price: totalConverted);

                    return BarcodeKeyboardListener(
                      bufferDuration: Duration(milliseconds: 500),
                      onBarcodeScanned: (barcode) {
                        print(barcode);
                        addProductFromBarcodeResult(barcode, products);
                      },
                      child: Container(
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height - 230),
                        padding: EdgeInsets.only(bottom: 10),
                        child: SingleChildScrollView(
                          physics: deviceType == DeviceType.POS
                              ? AlwaysScrollableScrollPhysics()
                              : NeverScrollableScrollPhysics(),
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
                                                'No hay productos seleccionados',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-Medium',
                                                  fontSize: 20,
                                                  color: Color.fromARGB(
                                                      255, 90, 93, 119),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 40,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.75,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Acerca el código de barras al escáner.',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-Medium',
                                                    fontSize: 28,
                                                    color: Color.fromARGB(
                                                        255, 90, 93, 119),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.20,
                                              constraints: BoxConstraints(
                                                maxHeight: 300,
                                              ),
                                              child: Image.asset(
                                                'assets/images/acerca_codigo.gif',
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.40,
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
                                            height: 130,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: themeProvider.myTheme
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
                                                      .child('productos')
                                                      .child(product.code!)
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
                                                        height: 130,
                                                        width: 95,
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
                                                            cacheManager:
                                                                CustomCacheManager
                                                                    .instance,
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
                                                        height: 130,
                                                        width: 95,
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
                                                        width: 95,
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
                                                          height: 65,
                                                          width: 200,
                                                          child: Text(
                                                            '${product.name}',
                                                            style:
                                                                const TextStyle(
                                                              letterSpacing:
                                                                  0.4,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Poppins-Regular',
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
                                                                size: 22,
                                                                color: themeProvider
                                                                    .myTheme
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
                                                                                17,
                                                                            splashRadius:
                                                                                17,
                                                                            icon:
                                                                                Icon(
                                                                              Icons.remove,
                                                                              color: themeProvider.myTheme.colorScheme.onPrimaryContainer,
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
                                                                              iconSize: 17,
                                                                              splashRadius: 17,
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
                                                                            16,
                                                                        fontFamily:
                                                                            'Poppins-Regular',
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
                                                                                17,
                                                                            splashRadius:
                                                                                17,
                                                                            icon:
                                                                                Icon(
                                                                              Icons.add,
                                                                              color: themeProvider.myTheme.colorScheme.primary,
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
                                                                                17,
                                                                            splashRadius:
                                                                                17,
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
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Poppins-Regular',
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 80,
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
                                                              style:
                                                                  const TextStyle(
                                                                letterSpacing:
                                                                    0.4,
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Poppins-Regular',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
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
                              SizedBox(height: 40),
                              ListOfProductsButtonKiosko(),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      offset: Offset(0, -3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
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
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                              fontSize: 14,
                                              color: products.isEmpty
                                                  ? Color.fromARGB(
                                                      255, 193, 168, 168)
                                                  : Color.fromARGB(
                                                      255, 57, 57, 57),
                                            ),
                                          ),
                                          Text(
                                            '$coinSymbol $subTotalFormatted',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                              fontSize: 14,
                                              color: products.isEmpty
                                                  ? Color.fromARGB(
                                                      255, 193, 168, 168)
                                                  : Color.fromARGB(
                                                      255, 57, 57, 57),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                            'IVA (16%)',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                              fontSize: 14,
                                              color: products.isEmpty
                                                  ? Color.fromARGB(
                                                      255, 193, 168, 168)
                                                  : Color.fromARGB(
                                                      255, 57, 57, 57),
                                            ),
                                          ),
                                          Text(
                                            '$coinSymbol $ivaFormatted',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                              fontSize: 14,
                                              color: products.isEmpty
                                                  ? Color.fromARGB(
                                                      255, 193, 168, 168)
                                                  : Color.fromARGB(
                                                      255, 57, 57, 57),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                            'Total a pagar',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                              fontSize: 14,
                                              color: products.isEmpty
                                                  ? Color.fromARGB(
                                                      255, 193, 168, 168)
                                                  : Color.fromARGB(
                                                      255, 57, 57, 57),
                                            ),
                                          ),
                                          Text(
                                            '$coinSymbol $totalFormatted',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                              fontSize: 14,
                                              color: products.isEmpty
                                                  ? Color.fromARGB(
                                                      255, 193, 168, 168)
                                                  : Color.fromARGB(
                                                      255, 57, 57, 57),
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
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.pressed)) {
                                                  return Color.fromARGB(
                                                      145, 57, 57, 57);
                                                } else if (states.contains(
                                                    MaterialState.disabled)) {
                                                  return Colors.grey.shade500;
                                                } else {
                                                  return Color.fromARGB(
                                                      255, 57, 57, 57);
                                                }
                                              },
                                            ),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                              Colors.white,
                                            ),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onPressed: products.isEmpty
                                              ? null
                                              : () async {
                                                  bool internet =
                                                      await checkInternetConnection(
                                                          context);
                                                  if (internet) {
                                                    processSelection(
                                                      userUid,
                                                      products,
                                                      'Tarjeta de Debito',
                                                      ivaConverted.toDouble(),
                                                      subTotalConverted
                                                          .toDouble(),
                                                      totalConverted.toDouble(),
                                                    );
                                                  }
                                                },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(),
                                              Text(
                                                'Pagar',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-Medium',
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
                                    ),
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

  processSelection(
    userUid,
    products,
    paymentMethod,
    ivaConverted,
    subTotalConverted,
    totalConverted,
  ) async {
    setState(() {
      loading = true;
    });
    final firebaseID = FirebaseFirestore.instance
        .collection('clientes')
        .doc(widget.client!.clientDocumentId)
        .collection('pedidos')
        .doc()
        .id;

    final invoiceNumber = await completePaymentProcess(
      widget.client,
      userUid,
      '',
      0,
      products,
      'Factura',
      'Fiscal',
      DateTime.now(),
      ivaConverted,
      0,
      subTotalConverted,
      totalConverted,
      0,
      firebaseID,
    );

    Client currentClient = Client(
      active: widget.client!.active,
      specialContributor: widget.client!.specialContributor,
      madeBy: widget.client!.madeBy,
      masterDiscount: widget.client!.masterDiscount,
      fiscalAdress: widget.client!.fiscalAdress,
      dispatchAdress: widget.client!.dispatchAdress,
      email: widget.client!.email,
      prices: widget.client!.prices,
      modified: widget.client!.modified,
      name: widget.client!.name,
      id: widget.client!.id,
      prospect: widget.client!.prospect,
      phone1: widget.client!.phone1,
      phone2: widget.client!.phone2,
      idType: widget.client!.idType,
      zone: widget.client!.zone,
      clientDocumentId: widget.client!.clientDocumentId,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(
          name: 'PAGO-DIRECTO',
        ),
        builder: (BuildContext context) => AddPaymentPage(
          invoiceTotal: totalConverted,
          remaining: totalConverted,
          subTotal: subTotalConverted,
          discountPercentage: 0,
          discount: 0,
          tax: ivaConverted,
          percentageTax: 16,
          client: currentClient,
          invoiceDocumentID: firebaseID,
          invoiceNumber: invoiceNumber,
          payments: const [],
          isKiosko: true,
          paymentType: paymentMethod,
        ),
      ),
    );
    setState(() {
      loading = false;
    });
  }
}
