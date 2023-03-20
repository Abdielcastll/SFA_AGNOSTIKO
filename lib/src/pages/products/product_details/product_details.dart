import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:full_screen_image/full_screen_image.dart';
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
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
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
    required this.isProductInAPromotion,
    this.prices,
    this.pricesName,
    this.catalogueID,
    required this.userZoneDocument,
    required this.showListButton,
  }) : super(key: key);

  final String? code;
  final String? price;
  final String? line;
  final String? name;
  final String imageUrl;
  final bool isProductNew;
  final bool showListButton;
  final bool isProductInAPromotion;
  final int? stock;
  final List<ProductsByDate>? list;
  final prices;
  final pricesName;
  final catalogueID;
  final userZoneDocument;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
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
        isProductInAPromotion: widget.isProductInAPromotion,
        prices: widget.prices,
        pricesName: widget.pricesName,
        catalogueID: widget.catalogueID,
        userZoneDocument: widget.userZoneDocument,
        showListButton: widget.showListButton,
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
    required this.isProductInAPromotion,
    this.prices,
    this.pricesName,
    this.catalogueID,
    required this.userZoneDocument,
    required this.showListButton,
  }) : super(key: key);

  final String? code;
  final String? price;
  final String? line;
  final String? name;
  final String imageUrl;
  final bool isProductNew;
  final bool showListButton;
  final int? stock;
  final List<ProductsByDate>? list;
  final bool isProductInAPromotion;
  final prices;
  final pricesName;
  final catalogueID;
  final userZoneDocument;

  @override
  Widget build(BuildContext context) {
    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    final orderActive = Provider.of<OrderProvider>(context);

    /////////////////////////////////////////
    print('code:$code');
    print('price:$price');
    print('line:$line');
    print('name:$name');
    print('imageUrl:$imageUrl');
    print('isProductNew:$isProductNew');
    print('stock:$stock');
    print('list:$list');
    print('isProductInAPromotion:$isProductInAPromotion');
    print('prices:$prices');
    print('pricesName:$pricesName');
    print('catalogueID:$catalogueID');
    print('userZoneDocument:$userZoneDocument');
    /////////////////////////////////////////

    priceFormat(productPrice) {
      double correctAmount = double.parse(productPrice.toStringAsFixed(2));
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
        return '฿ ${(correctAmount * 0.00011).toString()}';
      } else {
        return NumberFormat.currency(
          locale: 'es_VE',
          decimalDigits: 2,
          symbol: "PPR.",
        ).format(correctAmount * 4.58).toString();
      }
    }

    final priceProduct = priceFormat(double.parse(price ?? '0')).toString();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                FullScreenWidget(
                  disposeLevel: DisposeLevel.Low,
                  child: InteractiveViewer(
                    child: Container(
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
                              child: const Center(
                                  child: CircularProgressIndicator())),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/noproduct.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
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
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '$name',
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 24,
                    color: myTheme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: orderActive.orderActive == false
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      // SizedBox(height: 10),
                      showListButton == false
                          ? Container()
                          : Container(
                              // alignment: Alignment.centerLeft,
                              child: Container(
                                // margin: const EdgeInsets.only(left: 30.0),
                                // width: 160,
                                height: 38,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ProductsPage(
                                            listOfProducts: list,
                                            listOfPrices: prices,
                                            userZoneDocument: userZoneDocument,
                                            showFullList: false,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      MaterialCommunityIcons.view_list,
                                      color: myTheme
                                          .colorScheme.onPrimaryContainer,
                                    ),
                                    style: ButtonStyle(
                                      shadowColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.transparent),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 159, 165, 252)
                                            .withOpacity(0.3),
                                      ),
                                      overlayColor:
                                          MaterialStateProperty.all<Color>(
                                              myTheme.colorScheme.primary
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
                      orderActive.orderActive == false
                          ? Container()
                          : Container(
                              // margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              // alignment: Alignment.center,
                              child: Container(
                                // margin: const EdgeInsets.only(left: 30.0),
                                height: 38,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      if (stock! > 0) {
                                        final newProduct = ShoppingCartProduct(
                                          productQuantity: 1,
                                          code: code,
                                          productId: code,
                                          listOfPricesId: pricesName.toString(),
                                          totalAmount: price.toString(),
                                          name: name,
                                          unitPrice: price.toString(),
                                          availableStock: stock,
                                          urlPicture: catalogueID.toString(),
                                        );

                                        objectBox.insertShoppingCartProduct(
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
                                      color: myTheme
                                          .colorScheme.onPrimaryContainer,
                                    ),
                                    style: ButtonStyle(
                                      shadowColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.transparent),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 159, 165, 252)
                                            .withOpacity(0.3),
                                      ),
                                      overlayColor:
                                          MaterialStateProperty.all<Color>(
                                              myTheme.colorScheme.primary
                                                  .withOpacity(0.3)),
                                    ),
                                    label: Text(
                                      'Añadir',
                                      style: TextStyle(
                                        color: myTheme
                                            .colorScheme.onPrimaryContainer,
                                        fontFamily: 'Poppins-regular',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Linea: ',
                          style: TextStyle(
                            color: myTheme.colorScheme.onPrimaryContainer,
                            fontFamily: 'Poppins-regular',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$line •',
                          style: TextStyle(
                            color: myTheme.colorScheme.primary,
                            fontFamily: 'Poppins-regular',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.stock}: ',
                          style: TextStyle(
                            color: myTheme.colorScheme.onPrimaryContainer,
                            fontFamily: 'Poppins-regular',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$stock en inventario',
                          style: TextStyle(
                            color: myTheme.colorScheme.primary,
                            fontFamily: 'Poppins-regular',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.price}: ',
                          style: TextStyle(
                            color: myTheme.colorScheme.onPrimaryContainer,
                            fontFamily: 'Poppins-regular',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          priceProduct,
                          style: TextStyle(
                            color: myTheme.colorScheme.primary,
                            fontFamily: 'Poppins-regular',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: Text(
                          AppLocalizations.of(context)!.colors,
                          style: TextStyle(
                            color: myTheme.colorScheme.onPrimaryContainer,
                            fontFamily: 'Poppins-regular',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 5.0),
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 5.0),
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: myTheme.colorScheme.onPrimaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Container(
                              // margin: const EdgeInsets.only(right: 5.0),
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
                    ],
                  ),
                ],
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.fromLTRB(10, 10, 0, 20),
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Row(
            //               children: [
            //                 Text(
            //                   '$line • ',
            //                   style: TextStyle(
            //                     color: Colors.grey.shade700,
            //                     fontFamily: 'Poppins-regular',
            //                     fontSize: 16,
            //                   ),
            //                 ),
            //                 Text(
            //                   '${AppLocalizations.of(context)!.stock}: $stock',
            //                   style: TextStyle(
            //                     color: Colors.grey.shade700,
            //                     fontFamily: 'Poppins-regular',
            //                     fontSize: 16,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             Container(
            //               margin: const EdgeInsets.fromLTRB(0, 5, 10, 0),
            //               child: Text(
            //                 '${AppLocalizations.of(context)!.price}: $priceProduct',
            //                 style: TextStyle(
            //                   color: Colors.grey.shade700,
            //                   fontFamily: 'Poppins-regular',
            //                   fontSize: 16,
            //                 ),
            //               ),
            //             ),
            //             Container(
            //               margin: const EdgeInsets.fromLTRB(0, 5, 10, 0),
            //               child: Text(
            //                 AppLocalizations.of(context)!.colors,
            //                 style: TextStyle(
            //                   color: Colors.grey.shade700,
            //                   fontFamily: 'Poppins-regular',
            //                   fontSize: 16,
            //                 ),
            //               ),
            //             ),
            //             Container(
            //               margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            //               child: Row(
            //                 children: [
            //                   Container(
            //                     margin: const EdgeInsets.only(right: 5.0),
            //                     height: 30,
            //                     width: 30,
            //                     decoration: BoxDecoration(
            //                       color: Colors.amber,
            //                       borderRadius: BorderRadius.circular(20),
            //                     ),
            //                   ),
            //                   Container(
            //                     margin: const EdgeInsets.only(right: 5.0),
            //                     height: 30,
            //                     width: 30,
            //                     decoration: BoxDecoration(
            //                       color: myTheme.colorScheme.onPrimaryContainer,
            //                       borderRadius: BorderRadius.circular(20),
            //                     ),
            //                   ),
            //                   Container(
            //                     margin: const EdgeInsets.only(right: 5.0),
            //                     height: 30,
            //                     width: 30,
            //                     decoration: BoxDecoration(
            //                       color: Colors.green.shade900,
            //                       borderRadius: BorderRadius.circular(20),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             Container(
            //               margin: const EdgeInsets.fromLTRB(0, 5, 10, 0),
            //               child: Text(
            //                 'ID: $code',
            //                 style: TextStyle(
            //                   color: Colors.grey.shade700,
            //                   fontFamily: 'Poppins-regular',
            //                   fontSize: 16,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //         Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             showListButton == false
            //                 ? Container()
            //                 : Container(
            //                     alignment: Alignment.centerLeft,
            //                     child: Container(
            //                       margin: const EdgeInsets.only(left: 30.0),
            //                       // width: 160,
            //                       height: 38,
            //                       decoration: BoxDecoration(
            //                           borderRadius: BorderRadius.circular(20)),
            //                       child: ClipRRect(
            //                         borderRadius: BorderRadius.circular(20),
            //                         child: ElevatedButton.icon(
            //                           onPressed: () {
            //                             Navigator.push(
            //                               context,
            //                               MaterialPageRoute(
            //                                 builder: (BuildContext context) =>
            //                                     ProductsPage(
            //                                   listOfProducts: list,
            //                                   listOfPrices: prices,
            //                                   userZoneDocument:
            //                                       userZoneDocument,
            //                                   showFullList: false,
            //                                 ),
            //                               ),
            //                             );
            //                           },
            //                           icon: Icon(
            //                             MaterialCommunityIcons.view_list,
            //                             color: myTheme
            //                                 .colorScheme.onPrimaryContainer,
            //                           ),
            //                           style: ButtonStyle(
            //                             shadowColor:
            //                                 MaterialStateProperty.all<Color>(
            //                                     Colors.transparent),
            //                             backgroundColor:
            //                                 MaterialStateProperty.all<Color>(
            //                               const Color.fromARGB(
            //                                       255, 159, 165, 252)
            //                                   .withOpacity(0.3),
            //                             ),
            //                             overlayColor:
            //                                 MaterialStateProperty.all<Color>(
            //                                     myTheme.colorScheme.primary
            //                                         .withOpacity(0.3)),
            //                           ),
            //                           label: Text(
            //                             AppLocalizations.of(context)!.seeInList,
            //                             style: TextStyle(
            //                                 color: myTheme
            //                                     .colorScheme.onPrimaryContainer,
            //                                 fontFamily: 'Poppins-regular',
            //                                 fontSize: 13,
            //                                 fontWeight: FontWeight.bold),
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 orderActive.orderActive == false
            //                     ? Container()
            //                     : Container(
            //                         margin: const EdgeInsets.fromLTRB(
            //                             0, 10, 0, 0),
            //                         alignment: Alignment.center,
            //                         child: Container(
            //                           margin:
            //                               const EdgeInsets.only(left: 30.0),
            //                           height: 38,
            //                           decoration: BoxDecoration(
            //                               borderRadius:
            //                                   BorderRadius.circular(20)),
            //                           child: ClipRRect(
            //                             borderRadius:
            //                                 BorderRadius.circular(20),
            //                             child: ElevatedButton.icon(
            //                               onPressed: () {
            //                                 if (stock! > 0) {
            //                                   final newProduct =
            //                                       ShoppingCartProduct(
            //                                     productQuantity: 1,
            //                                     code: code,
            //                                     productId: code,
            //                                     listOfPricesId:
            //                                         pricesName.toString(),
            //                                     totalAmount: price.toString(),
            //                                     name: name,
            //                                     unitPrice: price.toString(),
            //                                     availableStock: stock,
            //                                     urlPicture:
            //                                         catalogueID.toString(),
            //                                   );

            //                                   objectBox
            //                                       .insertShoppingCartProduct(
            //                                           newProduct);
            //                                   Fluttertoast.showToast(
            //                                       msg:
            //                                           'Producto añadido correctamente');
            //                                 } else {
            //                                   Fluttertoast.showToast(
            //                                       msg:
            //                                           'No hay stock disponible para este producto');
            //                                 }
            //                                 Fluttertoast.showToast(
            //                                     msg:
            //                                         'Producto añadido correctamente');
            //                               },
            //                               icon: Icon(
            //                                 Icons.add_shopping_cart_rounded,
            //                                 color: myTheme.colorScheme
            //                                     .onPrimaryContainer,
            //                               ),
            //                               style: ButtonStyle(
            //                                 shadowColor: MaterialStateProperty
            //                                     .all<Color>(
            //                                         Colors.transparent),
            //                                 backgroundColor:
            //                                     MaterialStateProperty.all<
            //                                         Color>(
            //                                   const Color.fromARGB(
            //                                           255, 159, 165, 252)
            //                                       .withOpacity(0.3),
            //                                 ),
            //                                 overlayColor:
            //                                     MaterialStateProperty
            //                                         .all<Color>(myTheme
            //                                             .colorScheme.primary
            //                                             .withOpacity(0.3)),
            //                               ),
            //                               label: Text(
            //                                 'Añadir',
            //                                 style: TextStyle(
            //                                   color: myTheme.colorScheme
            //                                       .onPrimaryContainer,
            //                                   fontFamily: 'Poppins-regular',
            //                                   fontSize: 13,
            //                                   fontWeight: FontWeight.bold,
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
