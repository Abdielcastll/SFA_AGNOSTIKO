import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/product_details/product_details.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MostSelledProducts extends StatefulWidget {
  const MostSelledProducts({Key? key}) : super(key: key);

  @override
  State<MostSelledProducts> createState() => _MostSelledProductsState();
}

class _MostSelledProductsState extends State<MostSelledProducts> {
  @override
  Widget build(BuildContext context) {
    final productsBySales = Provider.of<List<ProductsByDate>?>(context) ?? [];
    var productsBySalesList = productsBySales;
    final linesSummary = Provider.of<LineSummary?>(context)?.summary ?? {};
    final stockValues = Provider.of<StockModel?>(context)?.stock ?? {};
    final products = Provider.of<List<Products>?>(context) ?? [];
    final prices = Provider.of<Prices?>(context)?.prices ?? {};
    final userZoneDocument = Provider.of<CurrentUserInfo>(context).zoneDocument;
    final pricesName = Provider.of<Prices?>(context)?.name ?? {};

    final productsList = products;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12.0, 16.0, 15.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                AntDesign.dotchart,
                color: myTheme.colorScheme.onPrimaryContainer,
                size: 20.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                AppLocalizations.of(context)!.mostSelled,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: myTheme.colorScheme.onPrimaryContainer,
                  fontSize: 16.0,
                  fontFamily: 'Poppins-regular',
                ),
              ),
            ],
          ),
          SizedBox(
            height: 230,
            width: double.infinity,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: productsBySalesList.length,
              itemBuilder: (BuildContext context, index) {
                final product = productsBySalesList[index];
                if ((stockValues[product.code] ?? 000) > 0) {
                  return FutureBuilder<String>(
                    future: FirebaseStorage.instance
                        .ref()
                        .child('imagenes')
                        .child('catalogos')
                        .child(product.catalogue)
                        .child('1')
                        .getDownloadURL()
                        .catchError((e) {
                      return '';
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final url = snapshot.data!.toString();
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProductDetails(
                                  code: product.code,
                                  line: linesSummary[product.line],
                                  imageUrl: url,
                                  isProductNew: false,
                                  price: (prices[product.code] ?? 0),
                                  name: product.name,
                                  stock: stockValues[product.code] ?? 0,
                                  list: productsBySalesList
                                      .where((element) =>
                                          element.name == product.name)
                                      .toList(),
                                  isProductInAPromotion: false,
                                  prices: prices,
                                  catalogueID: product.catalogue,
                                  userZoneDocument: userZoneDocument,
                                  showListButton: true,
                                  // pricesName: pricesName,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin:
                                const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 0),
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.transparent,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    height: 150,
                                    width: 160,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: url,
                                      placeholder: (context, url) => Container(
                                        alignment: Alignment.center,
                                        width: 300,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/noproduct.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(5.0, 0, 0, 4),
                                  child: Text(
                                    '${product.name}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: myTheme
                                          .colorScheme.onPrimaryContainer,
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(5.0, 0.0, 0, 0),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 3.0),
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 3.0),
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          color: myTheme
                                              .colorScheme.onPrimaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 3.0),
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade900,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return GestureDetector(
                          onTap: () {
                            final counterLimitProvider =
                                Provider.of<CounterLimitFirestore>(context,
                                    listen: false);
                            if (products.length > 100) {
                              counterLimitProvider.setProductsLimit(10, 10);
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProductDetails(
                                  code: product.code,
                                  price: (prices[product.code] ?? 0),
                                  line: linesSummary[product.line],
                                  imageUrl: 'https://i.imgur.com/BPbj6Gy.jpg',
                                  isProductNew: false,
                                  name: product.name,
                                  stock: stockValues[product.code] ?? 0,
                                  list: productsBySalesList
                                      .where((element) =>
                                          element.name == product.name)
                                      .toList(),
                                  isProductInAPromotion: false,
                                  prices: prices,
                                  userZoneDocument: userZoneDocument,
                                  showListButton: true,
                                  pricesName: pricesName,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin:
                                const EdgeInsets.fromLTRB(0.0, 12.0, 16.0, 8),
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    height: 150,
                                    width: 160,
                                    child: Image.network(
                                      'https://i.imgur.com/BPbj6Gy.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(5, 0, 0, 4),
                                  child: Text(
                                    '${product.name}',
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: myTheme
                                          .colorScheme.onPrimaryContainer,
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(5.0, 0.0, 0, 0),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 3.0),
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 3.0),
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          color: myTheme
                                              .colorScheme.onPrimaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 3.0),
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade900,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox(
                          width: 140,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
