// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/discount.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/promotions_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/components/category_list.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/components/most_selled_products.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/components/new_products.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/components/product_list_button.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/components/promotions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/widgets/loading/loading_widget.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({Key? key}) : super(key: key);

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  @override
  Widget build(BuildContext context) {
    final currentClientForTheOrder =
        Provider.of<OrderProvider>(context).clientForTheOrder;
    final productsLimit =
        Provider.of<CounterLimitFirestore>(context).getProductsLimit;
    final userZoneDocument = Provider.of<CurrentUserInfo>(context).zoneDocument;
    getDiscounts();
    return MultiProvider(
      providers: [
        // StreamProvider<List<Products>?>.value(
        //   value: productsLimit == 0
        //       ? productsCollection
        //           .orderBy('codigo')
        //           .snapshots()
        //           .map(productsListFromSnapshot)
        //       : productsCollection
        //           .orderBy('codigo')
        //           .limit(productsLimit)
        //           .snapshots()
        //           .map(productsListFromSnapshot),
        //   initialData: const [],
        //   catchError: (context, error) {
        //     return;
        //   },
        // ),

        StreamProvider<List<ProductsWithPromotions>?>.value(
          value: DatabaseServiceStreams().productsWithPromotions,
          initialData: const [],
          catchError: (context, error) {
            return;
          },
        ),
        StreamProvider<List<Promotions>?>.value(
          value: DatabaseServiceStreams().promotions,
          initialData: const [],
          catchError: (context, error) {
            return;
          },
        ),
        StreamProvider<List<ProductsByDate>?>.value(
          value: DatabaseServiceStreams().productsByDate,
          initialData: const [],
          catchError: (context, error) {
            print('ERROR PRODUCTS BY DATE PROVIDER');
            print(error);
            return;
          },
        ),
        StreamProvider<CategorieSummary?>.value(
          value: DatabaseServiceStreams().categorieSummary,
          initialData: null,
          catchError: (context, error) {
            return;
          },
        ),
        StreamProvider<LineSummary?>.value(
          value: DatabaseServiceStreams().lineSummary,
          initialData: null,
          catchError: (context, error) {
            return;
          },
        ),
        StreamProvider<StockModel?>.value(
          value: DatabaseServiceStreams().stockValues,
          initialData: null,
          catchError: (context, error) {
            return;
          },
        ),
        StreamProvider<Prices?>.value(
          value: FirebaseFirestore.instance
              .collection('listas_de_precios')
              .doc(currentClientForTheOrder?.prices.toString())
              .snapshots()
              .map(pricesfromSnapshot),
          initialData: null,
          catchError: (context, error) {
            return;
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBarNavigation(
          message: 'Agnostiko',
          userZoneDocument: userZoneDocument,
        ),
        backgroundColor: myTheme.colorScheme.surface,
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
    final productsByDateProvider =
        Provider.of<List<ProductsByDate>?>(context) ?? [];
    // final productsLimit =
    //     Provider.of<CounterLimitFirestore>(context).getProductsLimit;
    // final productsScrollLimit =
    //     Provider.of<CounterLimitFirestore>(context).getScrollProductLimit;

    return productsByDateProvider.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: const [
                PromotionsWidget(),
                NewProductsWidget(),
                ListOfProductsButton(),
                ListOfCategories(),
                MostSelledProducts(),
              ],
            ));
  }
}
