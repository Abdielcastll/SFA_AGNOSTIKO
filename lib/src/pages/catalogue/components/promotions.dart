import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:pwa_sales2go_flutter/src/pages/products/product_details/product_details.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    return Container(
      height: 240,
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: myTheme.colorScheme.background,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                MaterialIcons.grade,
                color: myTheme.colorScheme.primary,
                size: 25.0,
              ),
              const SizedBox(width: 5.0),
              Text(
                AppLocalizations.of(context)!.promotions,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: myTheme.colorScheme.onPrimaryContainer,
                  letterSpacing: 0.15,
                  fontSize: 16,
                  fontFamily: 'Poppins-regular',
                ),
              ),
            ],
          ),
          activePromotions.isEmpty
              ? Container(
                  margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  height: 175,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        height: 120,
                        width: 260,
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
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.only(left: 12),
                        width: 280,
                        height: 20,
                        child: Text(
                          AppLocalizations.of(context)!.promotionsUnavaliable,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: myTheme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  height: 175,
                  width: double.infinity,
                  child: RawScrollbar(
                    thumbColor: myTheme.colorScheme.primary.withOpacity(0.3),
                    thickness: 4,
                    radius: const Radius.circular(16),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: activePromotions.length,
                      itemBuilder: (BuildContext context, index) {
                        final promotion = activePromotions[index];

                        return FutureBuilder<String?>(
                          future: FirebaseStorage.instance
                              .ref()
                              .child('imagenes')
                              .child('promociones')
                              .child(promotion.firebaseDocumentID)
                              .child('1')
                              .getDownloadURL()
                              .catchError((e) {
                            print(e);
                          }),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final String url = snapshot.data?.toString() ??
                                  'https://imgur.com/Tx5FGxS';

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductsPage(
                                        listOfProducts: products
                                            .where((product) =>
                                                product.promotion ==
                                                promotion.firebaseDocumentID)
                                            .toList(),
                                        listOfPrices: listOfPrices,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 16, 0),
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
                                                      child:
                                                          CircularProgressIndicator())),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            'assets/images/promotions.jpg',
                                            fit: BoxFit.cover,
                                          ),
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
                            } else if (snapshot.hasError) {
                              return GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => ProductsPage(
                                  //       listOfProducts: products
                                  //           .where(
                                  //             (product) =>
                                  //                 product.promotion ==
                                  //                 promotion.firebaseDocumentID,
                                  //           )
                                  //           .toList(),
                                  //       listOfPrices: listOfPrices,
                                  //       isOrderActive: widget.isOrderActive,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 16, 0),
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
                ),
        ],
      ),
    );
  }
}
