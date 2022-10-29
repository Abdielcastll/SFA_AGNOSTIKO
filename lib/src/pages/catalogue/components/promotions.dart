// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/product_details/product_details.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PromotionsWidget extends StatefulWidget {
  const PromotionsWidget({
    Key? key,
    required this.isOrderActive,
  }) : super(key: key);

  final bool isOrderActive;

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
    // print(productsWithPromotionList);
    final linesSummary = Provider.of<LineSummary?>(context)?.summary ?? {};
    // print(linesSummary);
    final stockValues = Provider.of<StockModel?>(context)?.stock ?? {};
    // print(stockValues);
    final products = Provider.of<List<Products>?>(context) ?? [];
    final productsList = products;
    // Precios
    final prices = Provider.of<Prices?>(context)?.prices ?? {};
    // print(prices);
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                MaterialIcons.star_outline,
                color: myTheme.colorScheme.primary,
                size: 25.0,
              ),
              SizedBox(width: 5.0),
              Text(
                AppLocalizations.of(context)!.promotions,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: myTheme.colorScheme.secondary,
                  fontSize: 16.0,
                  fontFamily: 'Poppins-regular',
                ),
              ),
            ],
          ),
          productsWithPromotionList.isEmpty
              ? SizedBox(
                  height: 165,
                  width: double.infinity,
                  child: RawScrollbar(
                    thumbColor: myTheme.colorScheme.primary.withOpacity(0.3),
                    thickness: 4,
                    radius: Radius.circular(16),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          height: 120,
                          width: 260,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              'https://i.imgur.com/zSVi1hN.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          width: 260,
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
                  ),
                )
              : Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  height: 165,
                  width: double.infinity,
                  child: RawScrollbar(
                    thumbColor: myTheme.colorScheme.primary.withOpacity(0.3),
                    thickness: 4,
                    radius: Radius.circular(16),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: productsWithPromotionList.length,
                      itemBuilder: (BuildContext context, index) {
                        final product = productsWithPromotionList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProductDetails(
                                  code: product.code,
                                  price: prices[product.code],
                                  line: linesSummary[product.line],
                                  imageUrl: 'https://i.imgur.com/BPbj6Gy.jpg',
                                  isProductNew: true,
                                  name: product.name,
                                  stock: stockValues[product.code] ?? 000,
                                  list: productsList
                                      .where((element) =>
                                          element.name == product.name)
                                      .toList(),
                                  isOrderActive: widget.isOrderActive,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                height: 120,
                                width: 260,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    'https://i.imgur.com/4hzxljO.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                width: 300,
                                height: 20,
                                child: Text(
                                  product.name,
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
