// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/promotions_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_client_kiosko.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_products_kiosko.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_kiosko.dart';

class CataloguePageKiosko extends StatefulWidget {
  const CataloguePageKiosko({Key? key}) : super(key: key);

  @override
  State<CataloguePageKiosko> createState() => _CataloguePageKioskoState();
}

class _CataloguePageKioskoState extends State<CataloguePageKiosko> {
  @override
  Widget build(BuildContext context) {
    final userZoneDocument = context.watch<CurrentUserInfo>().zoneDocument;

    print('zoneDocument: $userZoneDocument');

    return Scaffold(
      appBar: AppBarKiosko(
        message: 'Orden',
        userZoneDocument: userZoneDocument,
      ),
      backgroundColor: myTheme.colorScheme.surface,
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
  late FToast fToast;

  @override
  void initState() {
    initOrder();
    super.initState();
  }

  initOrder() async {
    final orderActive = context.read<OrderProvider>();
    final userZoneDocument = context.read<CurrentUserInfo>().zoneDocument;

    Clients? defaultClient = genericClients;
    await clientsCollection
        .where('zona', isEqualTo: userZoneDocument)
        .where('numeroId', isEqualTo: 0)
        .get()
        .then((value) {
      return value.docs.map((snapshot) {
        if (snapshot
            .get('nombre')
            .toString()
            .contains('000A Cliente Default')) {
          defaultClient = genericClients;
        } else {
          defaultClient = genericClients;
        }
      }).toList();
    }).catchError((e) async {
      print('ERROR ON GETTING CLIENT DEFAULT ON APPBAR NAVIGATION');
      print(e);
      return <Null>[];
    });

    print('defaultClient?.zone: ${defaultClient?.zone}');
    orderActive.setOrder(true, defaultClient);
  }

  @override
  Widget build(BuildContext context) {
    final currentClientForTheOrder =
        context.watch<OrderProvider>().clientForTheOrder;
    final currentCoin = context.watch<CurrencyProvider>().currentCurrency;
    List<String> currentCoinSplit = currentCoin!.split(' ');
    String currentCoinSelectedCode = currentCoinSplit.last;
    final counterLimitProvider =
        Provider.of<CounterLimitFirestore>(context, listen: false);
    counterLimitProvider.setProductsLimit(0, 0);

    return MultiProvider(
      providers: [
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
        StreamProvider<Coin?>.value(
          initialData: Coin(),
          catchError: (context, error) {
            print(
                'ERROR ON STREAM PROVIDER OF COINEXCHANGE RATES IN ADD CLIENT');
            print(error);
            return;
          },
          value: coinCollection
              .doc(currentCoinSelectedCode)
              .snapshots()
              .map(coinFromSnapshot),
        ),
      ],
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SelectedClientKiosko(),
            SelectedProductsKiosko(client: currentClientForTheOrder)
          ],
        ),
      ),
    );
  }
}
