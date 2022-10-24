// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/product_details/product_details.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class MostSelledProducts extends StatefulWidget {
  const MostSelledProducts({Key? key, required this.isOrderActive})
      : super(key: key);

  final bool isOrderActive;

  @override
  State<MostSelledProducts> createState() => _MostSelledProductsState();
}

class _MostSelledProductsState extends State<MostSelledProducts> {
  @override
  Widget build(BuildContext context) {
    final productsBySales = Provider.of<List<ProductsByDate>?>(context) ?? [];
    var productsBySalesList = productsBySales;
    // print(productsBySalesList);
    final linesSummary = Provider.of<LineSummary?>(context)?.summary ?? {};
    final stockValues = Provider.of<StockModel?>(context)?.stock ?? {};
    final products = Provider.of<List<Products>?>(context) ?? [];
    final prices = Provider.of<Prices?>(context)?.prices ?? {};

    final productsList = products;
    // print(productsList);

    return Container(
      margin: EdgeInsets.fromLTRB(0, 10.0, 0, 15.0),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Icon(
                  AntDesign.dotchart,
                  color: myTheme.colorScheme.primary,
                  size: 20.0,
                ),
              ),
              SizedBox(width: 5.0),
              Text(
                'Más Vendidos',
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
              itemCount: productsBySalesList.length,
              itemBuilder: (BuildContext context, index) {
                final product = productsBySalesList[index];
                return GestureDetector(
                  onTap: () {
                    // Redireccionar a detalles del producto
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ProductDetails(
                          code: product.code,
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
                    print('Redireccionar a este producto mas vendido');
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10.0, 8.0, 5.0, 0),
                    height: 100,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Container(
                            height: 120,
                            width: 120,
                            child: Image.network(
                              'https://i.imgur.com/BPbj6Gy.jpg',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5.0, 5.0, 0, 0),
                          child: Text(
                            '${product.name}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            // textAlign: TextAlign.start,
                            style: TextStyle(
                              color: myTheme.colorScheme.primary,
                              fontFamily: 'Poppins-regular',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(8.0, 1.0, 0, 0),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 3.0),
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 3.0),
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 3.0),
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: Colors.green,
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
