// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/examples/products_example.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/components/new_products.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/components/promotions.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({Key? key}) : super(key: key);

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarNavigation(message: 'Apps2Go'),
      backgroundColor: Colors.grey[200],
      body: CatalogueBody(),
    );
  }
}

class CatalogueBody extends StatefulWidget {
  const CatalogueBody({
    Key? key,
  }) : super(key: key);

  @override
  State<CatalogueBody> createState() => _CatalogueBodyState();
}

class _CatalogueBodyState extends State<CatalogueBody> {
  List<ProductExample> productExampleList = allProducts;

  @override
  Widget build(BuildContext context) {
    var productsFilteredByPromotion = productExampleList
        .where((element) => element.promotion == true)
        .toList();

    //  print(productExampleList.sort((a, b) {
    //     return a.modified
    //         .toString()
    //         .toLowerCase()
    //         .compareTo(b.modified.toString().toLowerCase());
    //   }),
    //  );
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          PromotionsWidget(productsWithPromotion: productsFilteredByPromotion),
          NewProductsWidget(listOfProducts: productExampleList),
          // SizedBox(height: 10),
          // PromotionSwiper(),
          // SizedBox(height: 20),
          // CategoryGridView(),
        ],
      ),
    );
  }
}
