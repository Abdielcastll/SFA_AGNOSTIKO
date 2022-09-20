// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/product_details/product_details.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class NewProductsWidget extends StatefulWidget {
  const NewProductsWidget({Key? key}) : super(key: key);

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
    final products = Provider.of<List<Products>?>(context) ?? [];
    final productsList = products;
    // print(productsList);

    return Container(
      margin: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Icon(
                  CupertinoIcons.sparkles,
                  color: myTheme.colorScheme.primary,
                  size: 25.0,
                ),
              ),
              SizedBox(width: 5.0),
              Text(
                'Nuevos Productos',
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
                          line: linesSummary[product.line],
                          imageUrl: 'https://i.imgur.com/BPbj6Gy.jpg',
                          isProductNew: true,
                          name: product.name,
                          stock: stockValues[product.code] ?? 000,
                          list: productsList
                              .where((element) => element.name == product.name)
                              .toList(),
                        ),
                      ),
                    );
                    print('Redireccionar a detalles de producto reciente');
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
