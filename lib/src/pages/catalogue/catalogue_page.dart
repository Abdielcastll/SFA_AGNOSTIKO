// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/examples/catalogue_example.dart';
import 'package:pwa_sales2go_flutter/examples/products_example.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/components/category_list.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/components/most_selled_products.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/components/new_products.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/components/product_list_button.dart';
import 'package:pwa_sales2go_flutter/src/services/database.dart';
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
    return MultiProvider(
      providers: [
        // StreamProvider<List<Products>?>.value(
        //   value: DatabaseService().products,
        //   initialData: const [],
        //   catchError: (context, error) {
        //     print(error);
        //     return;
        //   },
        // ),
        StreamProvider<List<ProductsWithPromotions>?>.value(
          value: DatabaseService().productsWithPromotions,
          initialData: const [],
          catchError: (context, error) {
            print(error);
            return;
          },
        ),
        StreamProvider<List<ProductsByDate>?>.value(
          value: DatabaseService().productsByDate,
          initialData: const [],
          catchError: (context, error) {
            print(error);
            return;
          },
        ),
        StreamProvider<CategorieSummary?>.value(
          value: DatabaseService().categorieSummary,
          initialData: null,
          catchError: (context, error) {
            print(error);
            return;
          },
        ),
        StreamProvider<LineSummary?>.value(
          value: DatabaseService().lineSummary,
          initialData: null,
          catchError: (context, error) {
            print(error);
            return;
          },
        ),
        StreamProvider<StockModel?>.value(
          value: DatabaseService().stockValues,
          initialData: null,
          catchError: (context, error) {
            print(error);
            return;
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBarNavigation(message: 'Apps2Go'),
        backgroundColor: Colors.grey[200],
        body: CatalogueBody(),
      ),
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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          PromotionsWidget(),
          NewProductsWidget(),
          ListOfProductsButton(),
          ListOfCategories(),
          MostSelledProducts(),
        ],
      ),
    );
  }
}
