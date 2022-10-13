// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

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

    List categoriesSummary = categories.values.toList();
    // print(categoriesSummary);
    final products = Provider.of<List<Products>?>(context) ?? [];
    final productsList = products;
    // print(productsList);
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Icon(
                  Icons.category_outlined,
                  color: myTheme.colorScheme.primary,
                  size: 20.0,
                ),
              ),
              SizedBox(width: 5.0),
              Text(
                'Catálogo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: myTheme.colorScheme.secondary,
                  fontSize: 16.0,
                  fontFamily: 'Poppins-regular',
                ),
              ),
            ],
          ),
          Container(
            height: 165,
            width: double.infinity,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: categoriesSummary.length,
              itemBuilder: (BuildContext context, index) {
                final categorie = categoriesSummary[index];
                return GestureDetector(
                  onTap: () {
                    // Redireccionar a productos filtrados por catalogo,
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ProductsPage(
                          listOfProducts: productsList
                              .where((product) =>
                                  categories[product.categorie] == categorie)
                              .toList(),
                          listOfPrices: prices,
                          isOrderActive: widget.isOrderActive,
                        ),
                      ),
                    );
                    print(
                        'Redireccionar a lista de productos filtrada por esta categoria: $categorie');
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 0),
                    height: 110,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'https://i.imgur.com/H9rVf4m.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 2),
                          child: Stack(
                            children: [
                              Text(
                                '$categorie',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..color = myTheme.colorScheme.primary
                                      ..strokeWidth = 2),
                              ),
                              Text(
                                '$categorie',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
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
