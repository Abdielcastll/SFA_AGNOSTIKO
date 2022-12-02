// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/examples/products_example.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    Key? key,
    required this.code,
    this.price,
    required this.line,
    required this.name,
    required this.imageUrl,
    required this.isProductNew,
    required this.stock,
    this.list,
    required this.isOrderActive,
    required this.isProductInAPromotion,
    this.prices,
    this.pricesName,
  }) : super(key: key);

  final String code;
  final String? price;
  final String line;
  final String name;
  final String imageUrl;
  final bool isProductNew;
  final int stock;
  final List<Products>? list;
  final bool isOrderActive;
  final bool isProductInAPromotion;
  final prices;
  final pricesName;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, toolbarHeight: 40),
      backgroundColor: myTheme.colorScheme.surface,
      body: ProductDetailsBody(
        code: widget.code,
        line: widget.line,
        imageUrl: widget.imageUrl,
        isProductNew: widget.isProductNew,
        name: widget.name,
        stock: widget.stock,
        list: widget.list,
        price: widget.price,
        isOrderActive: widget.isOrderActive,
        isProductInAPromotion: widget.isProductInAPromotion,
        prices: widget.prices,
        pricesName: widget.pricesName,
      ),
    );
  }
}

class ProductDetailsBody extends StatelessWidget {
  ProductDetailsBody({
    Key? key,
    required this.code,
    this.price,
    required this.line,
    required this.name,
    required this.imageUrl,
    required this.isProductNew,
    required this.stock,
    this.list,
    required this.isOrderActive,
    required this.isProductInAPromotion,
    this.prices,
    this.pricesName,
  }) : super(key: key);

  final String code;
  final String? price;
  final String line;
  final String name;
  final String imageUrl;
  final bool isProductNew;
  final int stock;
  final List<Products>? list;
  final bool isOrderActive;
  final bool isProductInAPromotion;
  final prices;
  final pricesName;

  final String? currentCoin =
      sharedPreferences!.getString('currentCoin') ?? 'Dolares - USD';

  priceFormat(productPrice) {
    if (currentCoin!.contains('USD') || currentCoin == null) {
      return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
          .format(productPrice)
          .toString();
    } else if (currentCoin!.contains('VED')) {
      return NumberFormat.currency(
        locale: 'es_VE',
        decimalDigits: 2,
        symbol: "Bs.",
      ).format(productPrice * 4.58).toString();
    } else if (currentCoin!.contains('EUR')) {
      return NumberFormat.currency(
        locale: 'es_ES',
        decimalDigits: 2,
        symbol: '€',
      ).format(productPrice * 0.89).toString();
    } else if (currentCoin!.contains('MXN')) {
      return NumberFormat.currency(
        locale: 'es_MX',
        decimalDigits: 2,
        symbol: '\$',
      ).format(productPrice * 19.43);
    } else if (currentCoin!.contains('BTC')) {
      return '฿ ${(productPrice * 0.00011).toString()}';
    } else {
      return NumberFormat.currency(
        locale: 'es_VE',
        decimalDigits: 2,
        symbol: "PPR.",
      ).format(productPrice * 4.58).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final priceProduct = priceFormat(double.parse(price ?? '0')).toString();

    // String test2 = 'USD';
    // String test = 'Dolares - USD';
    // print(test.contains(test2));

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.transparent,
                  ),
                  height: 380,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: imageUrl,
                      placeholder: (context, url) => Container(
                          alignment: Alignment.center,
                          width: 300,
                          child:
                              const Center(child: CircularProgressIndicator())),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/noproduct.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                isProductNew
                    ? Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: myTheme.colorScheme.onPrimaryContainer,
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            stops: const [.5, .5],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Colors.transparent,
                              myTheme.colorScheme.onPrimaryContainer
                                  .withOpacity(0.8), // top Right part
                            ],
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(30, 0, 0, 20),
                          child: Icon(
                            CupertinoIcons.sparkles,
                            color: myTheme.colorScheme.background,
                            size: 30,
                          ),
                        ),
                      )
                    : Container(),
                isProductInAPromotion
                    ? Container(
                        height: 68,
                        width: 68,
                        decoration: BoxDecoration(
                          color: myTheme.colorScheme.onPrimaryContainer,
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            stops: const [.5, .5],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Colors.transparent,
                              myTheme.colorScheme.onPrimaryContainer
                                  .withOpacity(0.8), // top Right part
                            ],
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(25, 0, 0, 25),
                          child: Icon(
                            Icons.grade_outlined,
                            color: myTheme.colorScheme.background,
                            size: 26,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  name,
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 26,
                    color: myTheme.colorScheme.onBackground,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '$line • ',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontFamily: 'Poppins-regular',
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${AppLocalizations.of(context)!.stock}: $stock',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontFamily: 'Poppins-regular',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                          child: Text(
                            '${AppLocalizations.of(context)!.price}: $priceProduct',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontFamily: 'Poppins-regular',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                          child: Text(
                            AppLocalizations.of(context)!.colors,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontFamily: 'Poppins-regular',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 5.0),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 5.0),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: myTheme.colorScheme.onPrimaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 5.0),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade900,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                          child: Text(
                            'ID: $code',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontFamily: 'Poppins-regular',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 30.0),
                            // width: 160,
                            height: 38,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Redirigir a lista producto completas filtrada
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ProductsPage(
                                        listOfProducts: list,
                                        isOrderActive: isOrderActive,
                                        listOfPrices: prices,
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  MaterialCommunityIcons.view_list,
                                  color: myTheme.colorScheme.onPrimaryContainer,
                                ),
                                style: ButtonStyle(
                                  shadowColor: MaterialStateProperty.all<Color>(
                                      Colors.transparent),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Color.fromARGB(255, 159, 165, 252)
                                        .withOpacity(0.3),
                                  ),
                                  overlayColor:
                                      MaterialStateProperty.all<Color>(myTheme
                                          .colorScheme.primary
                                          .withOpacity(0.3)),
                                ),
                                label: Text(
                                  AppLocalizations.of(context)!.seeInList,
                                  style: TextStyle(
                                      color: myTheme
                                          .colorScheme.onPrimaryContainer,
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              isOrderActive == false
                                  ? Container()
                                  : Container(
                                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      alignment: Alignment.center,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 30.0),
                                        // width: 160,
                                        height: 38,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              if (stock > 0) {
                                                final newProduct =
                                                    ShoppingCartProduct(
                                                  productQuantity: 1,
                                                  code: code,
                                                  productId: code,
                                                  listOfPricesId:
                                                      pricesName.toString(),
                                                  totalAmount: price.toString(),
                                                  name: name,
                                                  unitPrice: price.toString(),
                                                  availableStock: stock,
                                                );
                                                objectBox
                                                    .insertShoppingCartProduct(
                                                        newProduct);
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Producto añadido correctamente');
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'No hay stock disponible para este producto');
                                              }
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Producto añadido correctamente');
                                            },
                                            icon: Icon(
                                              Icons.add_shopping_cart_rounded,
                                              color: myTheme.colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                            style: ButtonStyle(
                                              shadowColor: MaterialStateProperty
                                                  .all<Color>(
                                                      Colors.transparent),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                Color.fromARGB(
                                                        255, 159, 165, 252)
                                                    .withOpacity(0.3),
                                              ),
                                              overlayColor:
                                                  MaterialStateProperty
                                                      .all<Color>(myTheme
                                                          .colorScheme.primary
                                                          .withOpacity(0.3)),
                                            ),
                                            label: Text(
                                              'Añadir',
                                              style: TextStyle(
                                                  color: myTheme.colorScheme
                                                      .onPrimaryContainer,
                                                  fontFamily: 'Poppins-regular',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
