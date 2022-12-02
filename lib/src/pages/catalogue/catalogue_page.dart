import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/promotions_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/components/category_list.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/components/most_selled_products.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/components/new_products.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/components/product_list_button.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/components/promotions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage(
      {Key? key, this.listOfPrices, required this.isOrderActive})
      : super(key: key);

  final String? listOfPrices;
  final bool isOrderActive;

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  @override
  Widget build(BuildContext context) {
    final listOfPrices = widget.listOfPrices;
    return MultiProvider(
      providers: [
        StreamProvider<List<Products>?>.value(
          value: DatabaseServiceStreams().products,
          initialData: const [],
          catchError: (context, error) {
            // print(error);
            return;
          },
        ),
        StreamProvider<List<ProductsWithPromotions>?>.value(
          value: DatabaseServiceStreams().productsWithPromotions,
          initialData: const [],
          catchError: (context, error) {
            print(error);
            return;
          },
        ),
        StreamProvider<List<Promotions>?>.value(
          value: DatabaseServiceStreams().promotions,
          initialData: const [],
          catchError: (context, error) {
            print(error);
            return;
          },
        ),
        StreamProvider<List<ProductsByDate>?>.value(
          value: DatabaseServiceStreams().productsByDate,
          initialData: const [],
          catchError: (context, error) {
            // print(error);
            return;
          },
        ),
        StreamProvider<CategorieSummary?>.value(
          value: DatabaseServiceStreams().categorieSummary,
          initialData: null,
          catchError: (context, error) {
            // print(error);
            return;
          },
        ),
        StreamProvider<LineSummary?>.value(
          value: DatabaseServiceStreams().lineSummary,
          initialData: null,
          catchError: (context, error) {
            // print(error);
            return;
          },
        ),
        StreamProvider<StockModel?>.value(
          value: DatabaseServiceStreams().stockValues,
          initialData: null,
          catchError: (context, error) {
            // print(error);
            return;
          },
        ),
        StreamProvider<Prices?>.value(
          value: FirebaseFirestore.instance
              .collection('listas_de_precios')
              .doc(listOfPrices)
              .snapshots()
              .map(pricesfromSnapshot),
          initialData: null,
          catchError: (context, error) {
            // print(error);
            return;
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBarNavigation(
          message: 'Apps2Go',
          isOrderActive: widget.isOrderActive,
        ),
        backgroundColor: myTheme.colorScheme.surface,
        body: CatalogueBody(isOrderActive: widget.isOrderActive),
      ),
    );
  }
}

class CatalogueBody extends StatefulWidget {
  const CatalogueBody({
    Key? key,
    required this.isOrderActive,
  }) : super(key: key);

  final bool isOrderActive;

  @override
  State<CatalogueBody> createState() => _CatalogueBodyState();
}

class _CatalogueBodyState extends State<CatalogueBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          PromotionsWidget(isOrderActive: widget.isOrderActive),
          NewProductsWidget(isOrderActive: widget.isOrderActive),
          ListOfProductsButton(isOrderActive: widget.isOrderActive),
          ListOfCategories(isOrderActive: widget.isOrderActive),
          MostSelledProducts(isOrderActive: widget.isOrderActive),
        ],
      ),
    );
  }
}
