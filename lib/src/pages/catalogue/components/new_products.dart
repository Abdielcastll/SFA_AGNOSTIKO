// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/product_details/product_details.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../models/prices_model.dart';

class NewProductsWidget extends StatefulWidget {
  const NewProductsWidget({Key? key, required this.isOrderActive})
      : super(key: key);

  final bool isOrderActive;

  @override
  State<NewProductsWidget> createState() => _NewProductsWidgetState();
}

class _NewProductsWidgetState extends State<NewProductsWidget> {
  @override
  Widget build(BuildContext context) {
    final productsByDate = Provider.of<List<ProductsByDate>?>(context) ?? [];
    List<ProductsByDate>? productsByDateList = productsByDate;
    // print(productsByDateList);
    final linesSummary = Provider.of<LineSummary?>(context)?.summary ?? {};
    final stockValues = Provider.of<StockModel?>(context)?.stock ?? {};
    final prices = Provider.of<Prices?>(context)?.prices ?? {};
    final products = Provider.of<List<Products>?>(context) ?? [];
    final productsList = products;
    // print(productsList);

    return Container(
      margin: EdgeInsets.fromLTRB(16, 12.0, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Icon(
                  CupertinoIcons.sparkles,
                  color: myTheme.colorScheme.onPrimaryContainer,
                  size: 25.0,
                ),
              ),
              SizedBox(width: 5.0),
              Container(
                // margin: const EdgeInsets.only(bottom: 5),
                child: Text(
                  AppLocalizations.of(context)!.newProducts,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: myTheme.colorScheme.onPrimaryContainer,
                    fontSize: 16.0,
                    fontFamily: 'Poppins-regular',
                    letterSpacing: 0.15,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 215,
            width: double.infinity,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: productsByDateList.length,
              itemBuilder: (BuildContext context, index) {
                final product = productsByDateList[index];
                // print(productsList
                //     .where((element) => element.name == product.name)
                //     .toList());
                return GestureDetector(
                  onTap: () {
                    // Redireccionar a detalles del producto
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ProductDetails(
                          code: product.code,
                          price: prices[product.code],
                          line: linesSummary[product.line],
                          imageUrl: 'https://i.imgur.com/BPbj6Gy.jpg',
                          isProductNew: true,
                          name: product.name,
                          stock: stockValues[product.code] ?? 000,
                          list: productsList
                              .where((element) => element.name == product.name)
                              .toList(),
                          isOrderActive: widget.isOrderActive,
                        ),
                      ),
                    );
                    print('Redireccionar a detalles de producto reciente');
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0.0, 12.0, 16.0, 8),
                    // height: 100,
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.transparent,
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 150,
                            width: 160,
                            child: Image.network(
                              'https://i.imgur.com/BPbj6Gy.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 8.0, 0, 8),
                          child: Text(
                            '${product.name}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            // textAlign: TextAlign.start,
                            style: TextStyle(
                              color: myTheme.colorScheme.onPrimaryContainer,
                              fontFamily: 'Poppins-regular',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5.0, 0.0, 0, 0),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 3.0),
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 3.0),
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: myTheme.colorScheme.onPrimaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 3.0),
                                height: 10,
                                width: 10,
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
