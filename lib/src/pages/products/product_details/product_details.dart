// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/utils/custom_cache_manager.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';

import '../../../utils/functions.dart';

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

  final double? price;
  final String? code;
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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    List<String> currentCoinSplit = currentCoin!.split(' ');
    String currentCoinSelectedCode = currentCoinSplit.last;
    // print(currentCoinSelectedCode);
    return Scaffold(
      appBar: AppBarNavigation(
        message: AppLocalizations.of(context)!.products,
        userZoneDocument: widget.userZoneDocument,
      ),
      backgroundColor: themeProvider.myTheme.colorScheme.surface,
      body: MultiProvider(
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
        child: ProductDetailsBody(
          code: widget.code,
          line: widget.line,
          imageUrl: widget.imageUrl,
          isProductNew: widget.isProductNew,
          name: widget.name,
          stock: widget.stock ?? 0,
          list: widget.list,
          price: widget.price ?? 0.00,
          isProductInAPromotion: widget.isProductInAPromotion,
          prices: widget.prices,
          pricesName: widget.pricesName,
          catalogueID: widget.catalogueID,
          userZoneDocument: widget.userZoneDocument,
          showListButton: widget.showListButton,
        ),
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
    this.catalogueID = '',
    required this.userZoneDocument,
    required this.showListButton,
  }) : super(key: key);

  final double? price;
  final String? code;
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
    final orderActive = Provider.of<OrderProvider>(context);
    final coinName = Provider.of<Coin?>(context)?.name ?? 'Dolares';
    final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 2;
    final coinExchangeRatio = Provider.of<Coin?>(context)?.exchangeRatio ?? 1;
    final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '\$';

    print(coinName);
    print(coinDecimals);
    print(coinExchangeRatio);
    print(coinSymbol);
    // final coinCode = Provider.of<Coin?>(context)?.code ?? '';

    // final priceProduct = (double.parse(price ?? '0.0') *
    //         double.parse(coinExchangeRatio.toString()))
    //     .toStringAsFixed(coinDecimals);
    final double priceProduct = double.parse(
        (priceMultipliedByItsExchangeRatio2(
                productPrice: price,
                coinDecimals: coinDecimals,
                coinExchangeRatio: coinExchangeRatio))
            .toString());
    print('price: $price');
    print('priceProduct: $priceProduct');

    var formattedPrice = formatDecimalPriceByRegion(
        price: Decimal.parse(priceProduct.toString()));
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return coinName.toString().isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
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
                              child: imageUrl != ''
                                  ? CachedNetworkImage(
                                      cacheManager: CustomCacheManager.instance,
                                      fit: BoxFit.cover,
                                      imageUrl: imageUrl,
                                      placeholder: (context, url) => Container(
                                          alignment: Alignment.center,
                                          width: 300,
                                          child: const Center(
                                              child:
                                                  CircularProgressIndicator())),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/noproduct.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.asset(
                                      'assets/images/noproduct.jpg',
                                      fit: BoxFit.cover,
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
                                color: themeProvider
                                    .myTheme.colorScheme.onPrimaryContainer,
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  stops: const [.5, .5],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Colors.transparent,
                                    themeProvider
                                        .myTheme.colorScheme.onPrimaryContainer
                                        .withOpacity(0.8), // top Right part
                                  ],
                                ),
                              ),
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(30, 0, 0, 20),
                                child: Icon(
                                  CupertinoIcons.sparkles,
                                  color: themeProvider
                                      .myTheme.colorScheme.background,
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
                                color: themeProvider
                                    .myTheme.colorScheme.onPrimaryContainer,
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  stops: const [.5, .5],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Colors.transparent,
                                    themeProvider
                                        .myTheme.colorScheme.onPrimaryContainer
                                        .withOpacity(0.8), // top Right part
                                  ],
                                ),
                              ),
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(25, 0, 0, 25),
                                child: Icon(
                                  Icons.grade_outlined,
                                  color: themeProvider
                                      .myTheme.colorScheme.background,
                                  size: 26,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    alignment: Alignment.center,
                    width: 380,
                    child: Text(
                      '$name',
                      textAlign: TextAlign.left,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 26,
                        color: Color(0xFF1B1B1F),
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
                                    // margin: const EdgeInsets.only(left: 30.0),
                                    // width: 160,
                                    width: orderActive.orderActive == false
                                        ? 300
                                        : 180,
                                    height: 46,

                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ProductsPage(
                                                listOfProducts: list,
                                                listOfPrices: prices,
                                                userZoneDocument:
                                                    userZoneDocument,
                                                showFullList: false,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          MaterialCommunityIcons
                                              .view_list_outline,
                                          color: themeProvider.myTheme
                                              .colorScheme.onPrimaryContainer,
                                        ),
                                        style: ButtonStyle(
                                          shadowColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.transparent),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            // const Color.fromARGB(
                                            //         255, 159, 165, 252)
                                            //     .withOpacity(0.3),
                                            Colors.white,
                                          ),
                                          overlayColor:
                                              MaterialStateProperty.all<Color>(
                                                  themeProvider.myTheme
                                                      .colorScheme.primary
                                                      .withOpacity(0.3)),
                                        ),
                                        label: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .seeInList,
                                              style: TextStyle(
                                                  color: themeProvider
                                                      .myTheme
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Icon(
                                              MaterialIcons.arrow_forward_ios,
                                              color: themeProvider
                                                  .myTheme
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                              size: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            orderActive.orderActive == false
                                ? Container()
                                : Container(
                                    width: 5,
                                  ),
                            orderActive.orderActive == false
                                ? Container()
                                : Container(
                                    // margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    // alignment: Alignment.center,
                                    child: Container(
                                      // margin: const EdgeInsets.only(left: 30.0),
                                      height: 46,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: ElevatedButton.icon(
                                          onPressed: () async {
                                            if (stock! > 0) {
                                              // Get all products in the cart
                                              final productsInCart = await objectBox
                                                  .getAllShoppingCartProducts();
                                              // Initialize a flag to check if the product is already in the cart
                                              bool isProductAlreadyInCart =
                                                  false;
                                              // Iterate through the products in the cart
                                              for (var element
                                                  in productsInCart) {
                                                if (element.code == code) {
                                                  // Product is already in the cart, increase its quantity
                                                  print(
                                                      'Product is already in the cart, increasing quantity by 1');
                                                  isProductAlreadyInCart = true;
                                                  // Create a new product object with updated quantity
                                                  final updatedProduct =
                                                      ShoppingCartProduct(
                                                    id: element.id,
                                                    availableStock:
                                                        element.availableStock,
                                                    productQuantity: element
                                                            .productQuantity! +
                                                        1,
                                                    code: element.code,
                                                    listOfPricesId:
                                                        element.listOfPricesId,
                                                    name: element.name,
                                                    productId:
                                                        element.productId,
                                                    unitPrice: element.unitPrice
                                                        .toString(),
                                                    totalAmount: element
                                                        .totalAmount
                                                        .toString(),
                                                    urlPicture: element
                                                        .urlPicture
                                                        .toString(),
                                                  );
                                                  // Update the product in ObjectBox
                                                  if (element.productQuantity! +
                                                          1 <=
                                                      element.availableStock!) {
                                                    objectBox
                                                        .insertShoppingCartProduct(
                                                            updatedProduct);
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Producto ${element.code} añadido correctamente');
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'producto sin stock: ${code}');
                                                  }
                                                  // Show a toast message
                                                  break; // Exit the loop as we've found the product
                                                }
                                              }
                                              // If the product is not already in the cart, add it as a new product
                                              if (!isProductAlreadyInCart) {
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
                                                  urlPicture:
                                                      catalogueID.toString(),
                                                );
                                                // Insert the new product into ObjectBox
                                                if (newProduct
                                                            .productQuantity! +
                                                        1 <=
                                                    newProduct
                                                        .availableStock!) {
                                                  objectBox
                                                      .insertShoppingCartProduct(
                                                          newProduct);
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Producto ${newProduct.code} añadido correctamente');
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'producto sin stock: ${code}');
                                                }
                                              }
                                            } else {
                                              // Show a toast message if no stock is available
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'No hay stock disponible para este producto');
                                            }
                                          },
                                          icon: Icon(
                                            Icons.add_shopping_cart_rounded,
                                            color: themeProvider.myTheme
                                                .colorScheme.onPrimaryContainer,
                                          ),
                                          style: ButtonStyle(
                                            shadowColor: MaterialStateProperty
                                                .all<Color>(Colors.transparent),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    // const Color.fromARGB(
                                                    //         255, 159, 165, 252)
                                                    //     .withOpacity(0.3),
                                                    Colors.white),
                                            overlayColor: MaterialStateProperty
                                                .all<Color>(themeProvider
                                                    .myTheme.colorScheme.primary
                                                    .withOpacity(0.3)),
                                          ),
                                          label: Text(
                                            'Añadir',
                                            style: TextStyle(
                                              color: themeProvider
                                                  .myTheme
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                              fontFamily: 'Poppins-Regular',
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
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.price}: ',
                                style: TextStyle(
                                  color: Color(0xFF5A5D77),
                                  fontFamily: 'Poppins-Regular',
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '$coinSymbol $formattedPrice',
                                style: TextStyle(
                                  color: Color(0xFF5A5D77),
                                  fontFamily: 'Poppins-Regular',
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
                                  color: Color(0xFF5A5D77),
                                  fontFamily: 'Poppins-Regular',
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '$stock en Inventario',
                                style: TextStyle(
                                  color: Color(0xFF5A5D77),
                                  fontFamily: 'Poppins-Regular',
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
                                'Linea: ',
                                style: TextStyle(
                                  color: Color(0xFF5A5D77),
                                  fontFamily: 'Poppins-Regular',
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '$line •',
                                style: TextStyle(
                                  color: Color(0xFF5A5D77),
                                  fontFamily: 'Poppins-Regular',
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Container(
                        //       alignment: Alignment.centerLeft,
                        //       margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        //       child: Text(
                        //         AppLocalizations.of(context)!.colors,
                        //         style: TextStyle(
                        //           color: themeProvider.myTheme.colorScheme.onPrimaryContainer,
                        //           fontFamily: 'Poppins-regular',
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ),
                        //     // Container(
                        //     //   margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        //     //   child: Row(
                        //     //     children: [
                        //     //       Container(
                        //     //         margin: const EdgeInsets.only(right: 5.0),
                        //     //         height: 30,
                        //     //         width: 30,
                        //     //         decoration: BoxDecoration(
                        //     //           color: Colors.amber,
                        //     //           borderRadius: BorderRadius.circular(20),
                        //     //         ),
                        //     //       ),
                        //     //       Container(
                        //     //         margin: const EdgeInsets.only(right: 5.0),
                        //     //         height: 30,
                        //     //         width: 30,
                        //     //         decoration: BoxDecoration(
                        //     //           color: themeProvider.myTheme
                        //     //               .colorScheme.onPrimaryContainer,
                        //     //           borderRadius: BorderRadius.circular(20),
                        //     //         ),
                        //     //       ),
                        //     //       Container(
                        //     //         // margin: const EdgeInsets.only(right: 5.0),
                        //     //         height: 30,
                        //     //         width: 30,
                        //     //         decoration: BoxDecoration(
                        //     //           color: Colors.green.shade900,
                        //     //           borderRadius: BorderRadius.circular(20),
                        //     //         ),
                        //     //       ),
                        //     //     ],
                        //     //   ),
                        //     // ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
