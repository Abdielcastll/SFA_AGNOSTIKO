// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_client_kiosko.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_products_kiosko.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
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

    print('SELECTING DEFAULT CLIENT');
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
          print('SENDING DATA BASE DEFAULT CLIENT');
          defaultClient = genericClients;
        } else {
          print('SENDING ERROR DEFAULT CLIENT');
          defaultClient = genericClients;
        }
      }).toList();
    }).catchError((e) async {
      print('ERROR ON GETTING CLIENT DEFAULT ON APPBAR NAVIGATION');
      print(e);
      print('SENDING ERROR DEFAULT CLIENT');
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

    return MultiProvider(
      providers: [
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
      child: Container(
        height: MediaQuery.of(context).size.height - 60,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SelectedClientKiosko(),
              SelectedProductsKiosko(client: currentClientForTheOrder)
            ],
          ),
        ),
      ),
    );

    /* return Container(
      height: MediaQuery.of(context).size.height - 60,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/bimbo_background.jpg'))),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Center(
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  width: 300,
                  child: Image.asset('assets/images/bimboPay.png')),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: ElevatedButton(
                  onPressed: createOrder,
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      backgroundColor: Colors.white60,
                      shape: CircleBorder()),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.cartOutline,
                          size: 120,
                          color: myTheme.colorScheme.onPrimaryContainer,
                        ),
                        Text(
                          'Llenar Carrito',
                          style: TextStyle(
                              fontSize: 24,
                              color: myTheme.colorScheme.onPrimaryContainer,
                              fontFamily: 'Poppins-bold'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ); */
  }
}
