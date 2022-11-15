// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/examples/products_example.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';
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
        isOrderActive: widget.isOrderActive,
        isProductInAPromotion: widget.isProductInAPromotion,
        prices: widget.prices,
      ),
    );
  }
}

class ProductDetailsBody extends StatelessWidget {
  const ProductDetailsBody({
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

  @override
  Widget build(BuildContext context) {
    final String priceProduct = price ?? '0';

    print(prices);
    print('Precio: ${price ?? 000}');

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
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
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
                            '${AppLocalizations.of(context)!.price}: \$$priceProduct',
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
                                              // Anadir este producto al carrito
                                              final newProduct =
                                                  ShoppingCartProduct(
                                                productQuantity: 1,
                                                code: code,
                                                productId: code,
                                                listOfPricesId: 'GENER-03',
                                                totalAmount: priceProduct,
                                                name: name,
                                                unitPrice: priceProduct,
                                              );
                                              objectBox
                                                  .insertShoppingCartProduct(
                                                      newProduct);
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
