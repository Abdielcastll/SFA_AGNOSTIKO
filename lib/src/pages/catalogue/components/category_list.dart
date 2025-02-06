// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/new_products_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/custom_cache_manager.dart';

class ListOfCategories extends StatefulWidget {
  const ListOfCategories({Key? key}) : super(key: key);

  @override
  State<ListOfCategories> createState() => _ListOfCategoriesState();
}

class _ListOfCategoriesState extends State<ListOfCategories> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final categories = Provider.of<CategorieSummary?>(context)?.summary ?? {};
    List<MapEntry> listData = categories.entries.toList();
    listData.sort(
      (a, b) => a.value.toLowerCase().compareTo(
            b.value.toLowerCase(),
          ),
    );
    final Map sortedListData = Map.fromEntries(listData);
    final prices = Provider.of<Prices?>(context)?.prices ?? {};
    final pricesName = Provider.of<Prices?>(context)?.name ?? {};
    List categoriesSummary = sortedListData.values.toList();
    List categorieKeys = sortedListData.keys.toList();
    final userZoneDocument = Provider.of<CurrentUserInfo>(context).zoneDocument;

    return Container(
      margin: EdgeInsets.fromLTRB(0, 12.0, 0, 0),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Icon(
                  Icons.category_outlined,
                  color: themeProvider.myTheme.colorScheme.onPrimaryContainer,
                  size: 20.0,
                ),
              ),
              SizedBox(width: 8.0),
              Text(
                // AppLocalizations.of(context)!.catalogue,
                "Categorías",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: themeProvider.myTheme.colorScheme.onPrimaryContainer,
                  fontSize: 16.0,
                  fontFamily: 'Poppins-Medium',
                  letterSpacing: 0.15,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            height: 200,
            width: double.infinity,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount:
                  // 5,
                  categoriesSummary.length,
              itemBuilder: (BuildContext context, index) {
                final categorie = categoriesSummary[index];
                final key = categorieKeys[index];
                return GestureDetector(
                  onTap: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => NewProductsPage(
                          listOfPrices: prices,
                          userZoneDocument: userZoneDocument,
                          listOfProducts: const [],
                          showFullList: true,
                          pricesName: pricesName,
                          category: categorie,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: categoriesSummary.last == categorie
                        ? const EdgeInsets.fromLTRB(16, 0, 16, 0)
                        : const EdgeInsets.fromLTRB(16, 0, 0, 0),
                    height: 240,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.transparent,
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            height: 240,
                            width: 120,
                            child: FutureBuilder<String?>(
                              future: storage
                                  .ref()
                                  .child('imagenes')
                                  .child('catalogos')
                                  .child(categoriesCollection.doc(key).id)
                                  .child('1')
                                  .getDownloadURL()
                                  .catchError((e) {
                                // Handle error for image fetching
                                return 'assets/images/nocategorie.jpg';
                              }),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final url = snapshot.data?.toString();
                                  return CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: url!,
                                    placeholder: (context, url) => Container(
                                      width: 300,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/images/nocategorie.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: 'https://i.imgur.com/H9rVf4m.jpg',
                                    placeholder: (context, url) => Container(
                                      width: 300,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/images/nocategorie.jpg',
                                      fit: BoxFit.cover,
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
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                end: const Alignment(0.0, -1),
                                begin: const Alignment(0.0, 0.4),
                                colors: <Color>[
                                  const Color(0x8A000000),
                                  Colors.black12.withOpacity(0.0)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(8, 0, 0, 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            '$categorie',
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
