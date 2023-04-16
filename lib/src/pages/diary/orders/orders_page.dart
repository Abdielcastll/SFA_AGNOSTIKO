// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/order_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_rol_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/filter_orders..dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/orders_completed.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/orders_on_process.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/widgets/loading/loading_widget.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CurrentUserInfo?>(context);
    print('USER ON ORDER BOTTOM SHEET: ${user?.uid}');
    final userUid = Provider.of<CurrentUserInfo?>(context)?.uid ?? {};
    final userDoc = usersCollection.doc(userUid);
    // print(userDoc);
    final currentDay =
        Provider.of<CounterLimitFirestore>(context).currentDayOrder;
    final currentDayDateTime = currentDay.toDate();
    DateTime tomorrow = DateTime(currentDayDateTime.year,
        currentDayDateTime.month, currentDayDateTime.day + 1);

    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    List<String> currentCoinSplit = currentCoin!.split(' ');
    String currentCoinSelectedCode = currentCoinSplit.last;

    return MultiProvider(
      providers: [
        FutureProvider<UserRole?>.value(
          value: user?.getUserRole(),
          initialData: null,
          catchError: (context, error) {
            print(error);
            return;
          },
        ),
        StreamProvider<List<Orders>?>.value(
          value: currentDay !=
                  Timestamp.fromDate(
                    DateTime(
                      DateTime.now().year + 99,
                      DateTime.now().month + 99,
                      DateTime.now().day + 99,
                      0,
                      0,
                      0,
                      0,
                      0,
                    ),
                  )
              ? FirebaseFirestore.instance
                  .collectionGroup('pedidos')
                  .where('vendedor', isEqualTo: userDoc)
                  .where('fecha', isGreaterThanOrEqualTo: currentDay)
                  .where('fecha', isLessThan: tomorrow)
                  .orderBy('fecha')
                  .snapshots()
                  .map(ordersFromSnapshot)
              : FirebaseFirestore.instance
                  .collectionGroup('pedidos')
                  .where('vendedor', isEqualTo: userDoc)
                  .orderBy('fecha')
                  .snapshots()
                  .map(ordersFromSnapshot),
          initialData: const [],
          catchError: (context, error) {
            print('ERROR ON GETTING ORDERS IN ORDERS PAGE PROVIDER');
            print(error);
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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: myTheme.colorScheme.surface,
          body: OrdersBody(),
        ),
      ),
    );
  }
}

class OrdersBody extends StatefulWidget {
  const OrdersBody({
    Key? key,
  }) : super(key: key);

  @override
  State<OrdersBody> createState() => _OrdersBodyState();
}

class _OrdersBodyState extends State<OrdersBody> {
  bool seeCompleted = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 120,
                margin: const EdgeInsets.fromLTRB(16, 10, 0, 10),
                child: Text(
                  seeCompleted == true
                      ? AppLocalizations.of(context)!.completed
                      : AppLocalizations.of(context)!.onProcess,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: seeCompleted == true
                        ? Colors.green.shade600
                        : Colors.amber.shade600,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins-regular',
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Text(
                      'Ver completados',
                      style: TextStyle(
                        fontSize: 14,
                        // fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-regular',
                        color: myTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Checkbox(
                    checkColor: Colors.white,
                    shape: CircleBorder(),
                    fillColor:
                        MaterialStateProperty.all(myTheme.colorScheme.primary),
                    activeColor: myTheme.colorScheme.primary,
                    value: seeCompleted,
                    onChanged: (value) {
                      setState(() {
                        seeCompleted = !seeCompleted;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          seeCompleted == false ? OrdersOnProcess() : CompletedOrders(),
        ],
      ),
    );
  }
}
