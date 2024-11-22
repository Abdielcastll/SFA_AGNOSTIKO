// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'package:agnostiko/device/src/device.dart';
import 'package:agnostiko/scanner/src/scanner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/devices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_rol_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/checkout_retail_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/connection_service.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/checkout_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/utils/custom_cache_manager.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
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
  DeviceType? deviceType;
  String? deviceName;
  bool hasLaserScanner = false;
  String? scanResult = '';
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
    final model = await getModel();
    setState(() {
      hasLaserScanner = platformInfo.hasScannerHw;
      deviceType = dType;
      deviceName = model;
    });
  }

  addProductFromBarcodeResult(
    String? scanResult,
    List<ShoppingCartProduct>? productsInCart,
    stockValues,
  ) async {
    print('productsInCart: $productsInCart');
    final String? productScanResult = scanResult;
    print('BARCODE SCAN RESULT: ////////////////////////');
    print('ScanResult: $scanResult');
    List<ShoppingCartProduct> scannedProducts = [];

    if (scanResult == '') return;

    if (deviceType == DeviceType.PINPAD) {
      Fluttertoast.showToast(
          msg: 'Cargando producto $scanResult', fontSize: 20);
    }

    try {
      // print(stockProducts);
      final priceProducts = await listaDePreciosRef
          .doc(clientPriceList.toString())
          .get()
          .then((value) {
        return value['precios'];
      });
      print(priceProducts);

      await productosRef
          .where('codigoBarra', isEqualTo: productScanResult)
          .get()
          .then((docs) {
        var doc = docs.docs.first;
        if (!doc.exists) {
          Fluttertoast.showToast(
              msg: 'Producto no encontrado $scanResult',
              fontSize: 20,
              backgroundColor: Colors.red.shade700);
        }
        final code = doc.data().toString().contains('codigo')
            ? doc.get('codigo')
            : 'NaN';
        var stock = stockValues[code] ?? 000;
        const productQuantity = 1;
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
          if (productQuantity <= stock) {
            objectBox.insertShoppingCartProduct(result);
            Fluttertoast.showToast(
              msg: 'Se ha agregado exitosamente al carrito',
            );
          } else {
            Fluttertoast.showToast(msg: 'producto sin stock: ${code}');
          }
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
              if (element.productQuantity! + 1 <= stock) {
                objectBox.insertShoppingCartProduct(result);
                Fluttertoast.showToast(
                  msg: 'Se ha agregado exitosamente al carrito',
                );
              } else {
                Fluttertoast.showToast(msg: 'producto sin stock: ${code}');
              }
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
            if (productQuantity <= stock) {
              objectBox.insertShoppingCartProduct(result);
              Fluttertoast.showToast(
                msg: 'Se ha agregado exitosamente al carrito',
              );
            } else {
              Fluttertoast.showToast(msg: 'producto sin stock: ${code}');
            }
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
    // print("clientPriceList: $clientPriceList");
    final userRole = Provider.of<UserRole?>(context, listen: true);
    // print('User Role ${userRole?.name}');
    // print("Retail: ${userRole?.isRetail}");
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final stockValues = Provider.of<StockModel?>(context)?.stock ?? {};

    return coinName == ''
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

                        addProductFromBarcodeResult(
                            barcode, products, stockValues);
                      },
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              products!.isEmpty
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.50,
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            deviceType == DeviceType.PINPAD ||
                                                    deviceName == "N850"
                                                ? CrossAxisAlignment.center
                                                : CrossAxisAlignment.start,
                                        children: [
                                          deviceType == DeviceType.PINPAD ||
                                                  deviceName == "N850"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'No hay productos seleccionados\nAcerca el código de barras al escáner.',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-Medium',
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Image.asset(
                                                        'assets/images/scan_barcode.png',
                                                        height: 150,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      16, 8, 0, 0),
                                                  child: Text(
                                                    'No hay productos seleccionados',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'Poppins-Medium',
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      color: Colors.grey.shade100,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.50,
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: products.length,
                                        itemBuilder: (context, index) {
                                          final ShoppingCartProduct product =
                                              products[index];
                                          var productPrice = Decimal.parse(
                                              product.unitPrice.toString());

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
                                              Decimal.parse(product.unitPrice
                                                      .toString()) *
                                                  Decimal.parse(product
                                                      .productQuantity
                                                      .toString());

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
                                                      productTotalByQuantityConverted);

                                          return Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                16, 10, 16, 0),
                                            height: 95,
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
                                                                size: 20,
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
                                                                                15,
                                                                            splashRadius:
                                                                                15,
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
                                                                                15,
                                                                            splashRadius:
                                                                                15,
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
                                                                                if (product.productQuantity! + 1 <= product.availableStock!) {
                                                                                  updatedList.add(updatedProduct);
                                                                                  objectBox.insertManyShoppingCartProducts(updatedList);
                                                                                  Fluttertoast.showToast(
                                                                                    gravity: ToastGravity.TOP,
                                                                                    msg: 'Se ha agregado exitosamente al carrito',
                                                                                    fontSize: 20,
                                                                                    backgroundColor: const Color.fromARGB(255, 149, 231, 184),
                                                                                  );
                                                                                }
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
                                                                    'Poppins-Regular',
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
                                                                      'Poppins-Regular',
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        if (globalRemoteConfig
                                                    .escannerDeProductos ==
                                                true &&
                                            (deviceType != DeviceType.PINPAD))
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
                                                    themeProvider.myTheme
                                                        .colorScheme.primary,
                                                  ),
                                                  foregroundColor:
                                                      MaterialStateProperty.all(
                                                    Colors.white,
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        16,
                                                      ),
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
                                                      stockValues,
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
                                                          stockValues:
                                                              stockValues,
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
                                                        'Poppins-Medium',
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
                                          ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          width: 182,
                                          height: 56,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: ElevatedButton.icon(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  themeProvider.myTheme
                                                      .colorScheme.primary,
                                                ),
                                                foregroundColor:
                                                    MaterialStateProperty.all(
                                                  Colors.white,
                                                ),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                final test = Provider.of<
                                                        CounterLimitFirestore>(
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
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              label: Text(
                                                AppLocalizations.of(context)!
                                                    .addProducts,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Poppins-Medium',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                                            'Subtotal',
                                            style: const TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                              fontSize: 14,
                                              color: Color(0xff000C99),
                                            ),
                                          ),
                                          Text(
                                            '$coinSymbol $subTotalFormatted',
                                            style: const TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                              fontSize: 14,
                                              color: Color(0xff000C99),
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
                                                  return themeProvider.myTheme
                                                      .colorScheme.primary
                                                      .withOpacity(0.8);
                                                } else if (states.contains(
                                                    MaterialState.disabled)) {
                                                  return Colors.grey.shade500;
                                                } else {
                                                  return themeProvider.myTheme
                                                      .colorScheme.primary;
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
                                                    userRole?.isRetail == false
                                                        ? Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CheckoutPage(
                                                                client: widget
                                                                    .client,
                                                                cart: products,
                                                                subTotal: double
                                                                    .parse(
                                                                  subTotal
                                                                      .toString(),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CheckoutRetailPage(
                                                                client: widget
                                                                    .client,
                                                                cart: products,
                                                                subTotal: double
                                                                    .parse(
                                                                  subTotal
                                                                      .toString(),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                  }
                                                },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(),
                                              Text(
                                                'Continuar',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-Medium',
                                                  fontSize: 14,
                                                  color: products.isEmpty
                                                      ? Colors.grey.shade700
                                                      : Colors.white,
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 2),
                                                child: Icon(
                                                  SimpleLineIcons.arrow_right,
                                                  size: 14,
                                                  color: products.isEmpty
                                                      ? Colors.grey.shade700
                                                      : Colors.grey.shade300,
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
                      ),
                    );
                  }
                },
              ),
            ],
          );
  }
}
