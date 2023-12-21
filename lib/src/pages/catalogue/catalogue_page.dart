// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
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
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
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
    final currentClientForTheOrder =
        Provider.of<OrderProvider>(context).clientForTheOrder;
    final userZoneDocument = Provider.of<CurrentUserInfo>(context).zoneDocument;
    final userRole = Provider.of<CurrentUserInfo>(context).role;
    print('zoneDocument: $userZoneDocument');
    print('currentClientForTheOrder: ${currentClientForTheOrder?.prices}');
    print('userRole: $userRole');
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
            print('ERROR ON GETTING PROMOTIONS');
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
          value: listaDePreciosRef
              .doc(currentClientForTheOrder?.prices.toString())
              .snapshots()
              .map(pricesfromSnapshot),
          initialData: null,
          catchError: (context, error) {
            print('StreamProvider<Prices?> $error');
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
  late FToast fToast;

  // @override
  // void initState() {
  //   super.initState();
  //   fToast = FToast();
  //   fToast.init(context);
  // }

  @override
  Widget build(BuildContext context) {
    final productsByDateProvider =
        Provider.of<List<ProductsByDate>?>(context) ?? [];

    return productsByDateProvider.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // ElevatedButton(
                //   onPressed: () {
                //     customToast(
                //         fToast: fToast,
                //         msg: 'Se ha ',
                //         backgroundColor: Color(0xFF95E7B8),
                //         icon: Icon(
                //           Icons.check,
                //           color: Color(0xFF10783C),
                //         ),
                //         textColor: Color(0xFF10783C));
                //   },
                //   child: Text('get data'),
                // ),
                if (globalRemoteConfig.promocionesVisualizacion == true)
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
