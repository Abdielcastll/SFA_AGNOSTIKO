// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/promotions_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/product_details/product_details.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PromotionsWidget extends StatefulWidget {
  const PromotionsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<PromotionsWidget> createState() => _PromotionsWidgetState();
}

class _PromotionsWidgetState extends State<PromotionsWidget> {
  @override
  Widget build(BuildContext context) {
    final productsWithPromotions =
        Provider.of<List<ProductsWithPromotions>?>(context) ?? [];
    List<ProductsWithPromotions>? productsWithPromotionList =
        productsWithPromotions;
    final pricesName = Provider.of<Prices?>(context)?.name ?? {};
    final linesSummary = Provider.of<LineSummary?>(context)?.summary ?? {};
    final stockValues = Provider.of<StockModel?>(context)?.stock ?? {};
    final products = Provider.of<List<Products>?>(context) ?? [];
    final productsList = products;
    final promotions = Provider.of<List<Promotions>?>(context) ?? [];
    List productsWithPromotionID =
        productsWithPromotionList.map((e) => e.promotion).toList();
    List activePromotions = promotions
        .where((element) =>
            productsWithPromotionID.contains(element.firebaseDocumentID))
        .toList();
    final listOfPrices = Provider.of<Prices?>(context)?.prices ?? {};
    final orderActive = Provider.of<OrderProvider>(context);
    final currentClientForTheOrder =
        Provider.of<OrderProvider>(context).clientForTheOrder;

    final userZoneDocument = Provider.of<CurrentUserInfo>(context).zoneDocument;

    int activeIndex = 0;

    return Container(
      // padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 10.0),
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: myTheme.colorScheme.background,
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(15, 8, 0, 0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: Icon(
                    Entypo.star_outlined,
                    color: myTheme.colorScheme.onPrimaryContainer,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 5.0),
                Text(
                  AppLocalizations.of(context)!.promotions,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: myTheme.colorScheme.onPrimaryContainer,
                    letterSpacing: 0.15,
                    fontSize: 16,
                    fontFamily: 'Poppins-medium',
                  ),
                ),
              ],
            ),
          ),
          activePromotions.isEmpty
              ? Container(
                  margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  height: 175,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 140,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/nopromotions.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        width: 280,
                        height: 20,
                        alignment: Alignment.center,
                        child: Text(
                          AppLocalizations.of(context)!.promotionsUnavaliable,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: myTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  // height: 180,
                  width: double.infinity,
                  child: CarouselSlider.builder(
                    itemCount: activePromotions.length,
                    options: CarouselOptions(
                      viewportFraction: 0.9,
                      height: 180,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() => activeIndex = index);
                        print(activeIndex);
                      },
                    ),
                    itemBuilder: (context, index, realIndex) {
                      final promotion = activePromotions[index];

                      return FutureBuilder<String?>(
                        future: storage
                            .ref()
                            .child('imagenes')
                            .child('promociones')
                            .child(promotion.firebaseDocumentID)
                            .child('1')
                            .getDownloadURL()
                            .catchError((e) {
                          print('ERROR ON GETTING PROMOTION IMAGE');
                          print(e);
                          return e;
                        }),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final String url = snapshot.data?.toString() ??
                                'https://imgur.com/Tx5FGxS';

                            return GestureDetector(
                              onTap: () {
                                final counterLimitProvider =
                                    Provider.of<CounterLimitFirestore>(context,
                                        listen: false);
                                if (counterLimitProvider.getProductsLimit >
                                    100) {
                                  counterLimitProvider.setProductsLimit(10, 10);
                                }
                                print(products
                                    .where((product) =>
                                        product.promotion ==
                                        promotion.firebaseDocumentID)
                                    .toList());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductsPage(
                                      listOfProducts: productsWithPromotions
                                          .where((product) =>
                                              product.promotion ==
                                              promotion.firebaseDocumentID)
                                          .toList(),
                                      listOfPrices: listOfPrices,
                                      userZoneDocument: userZoneDocument,
                                      showFullList: false,
                                      pricesName: pricesName,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // margin: activePromotions.last == promotion
                                    //     ? const EdgeInsets.fromLTRB(0, 0, 16, 0)
                                    //     : const EdgeInsets.fromLTRB(
                                    //         0, 0, 16, 0),
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 16, 0),
                                    height: 140,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: url,
                                        placeholder: (context, url) =>
                                            const SizedBox(
                                          width: 300,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/images/promotions.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: 280,
                                    child: Text(
                                      promotion.description,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Poppins-regular',
                                        color: myTheme
                                            .colorScheme.onPrimaryContainer,
                                        fontSize: 16,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductsPage(
                                      listOfProducts: productsWithPromotions
                                          .where(
                                            (product) =>
                                                product.promotion ==
                                                promotion.firebaseDocumentID,
                                          )
                                          .toList(),
                                      listOfPrices: listOfPrices,
                                      userZoneDocument: userZoneDocument,
                                      showFullList: false,
                                      pricesName: pricesName,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 16, 0),
                                    height: 140,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        'assets/images/promotions.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    margin: const EdgeInsets.only(left: 12),
                                    width: 280,
                                    height: 20,
                                    child: Text(
                                      promotion.description,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Poppins-regular',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: myTheme
                                            .colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox(
                              width: 300,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
