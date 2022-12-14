// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListOfCategories extends StatefulWidget {
  ListOfCategories({Key? key, required this.isOrderActive}) : super(key: key);

  final bool isOrderActive;

  @override
  State<ListOfCategories> createState() => _ListOfCategoriesState();
}

class _ListOfCategoriesState extends State<ListOfCategories> {
  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<CategorieSummary?>(context)?.summary ?? {};
    final prices = Provider.of<Prices?>(context)?.prices ?? {};
    final products = Provider.of<List<Products>?>(context) ?? [];
    final productsList = products;
    List categoriesSummary = categories.values.toList();
    // print(categoriesSummary);
    // print(productsList);

    return Container(
      margin: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.category_outlined,
                color: myTheme.colorScheme.onPrimaryContainer,
                size: 20.0,
              ),
              SizedBox(width: 8.0),
              Text(
                AppLocalizations.of(context)!.catalogue,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: myTheme.colorScheme.onPrimaryContainer,
                  fontSize: 16.0,
                  fontFamily: 'Poppins-regular',
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
              itemCount: categoriesSummary.length,
              itemBuilder: (BuildContext context, index) {
                final categorie = categoriesSummary[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ProductsPage(
                          listOfProducts: productsList
                              .where((product) =>
                                  categories[product.categorie] == categorie)
                              .toList(),
                          listOfPrices: prices,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0),
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
                                borderRadius: BorderRadius.circular(8)),
                            height: 240,
                            width: 120,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: 'https://i.imgur.com/H9rVf4m.jpg',
                              placeholder: (context, url) => Container(
                                  width: 300,
                                  child: const Center(
                                      child: CircularProgressIndicator())),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/nocategorie.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            // child: Image.network(
                            //   'https://i.imgur.com/H9rVf4m.jpg',
                            //   fit: BoxFit.cover,
                            // ),
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
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontSize: 13,
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
