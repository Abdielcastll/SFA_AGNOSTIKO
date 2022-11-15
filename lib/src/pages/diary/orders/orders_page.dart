// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/order_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/filter_orders..dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/orders_completed.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/orders_on_process.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late List<double> coinsExchangeRates = [0, 0, 0];

  Future<void> getPricesExchangesRates() async {
    await FirebaseFirestore.instance
        .collection('monedas')
        .get()
        .then((document) {
      // print('Cantidad de documentos en monedas: ${document.docs.length}');
      document.docs.forEach((element) {
        // print(element.data()['tasaDeCambio']);
        coinsExchangeRates.remove(0);
        coinsExchangeRates.add(element.data()['tasaDeCambio']);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getPricesExchangesRates();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Orders>?>.value(
          value: FirebaseFirestore.instance
              .collectionGroup('pedidos')
              .orderBy('nroCorrelativo', descending: true)
              .snapshots()
              .map(ordersFromSnapshot),
          initialData: const [],
          catchError: (context, error) {
            // print(error);
          },
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: myTheme.colorScheme.surface,
          body: OrdersBody(coinsExchangeRates: coinsExchangeRates),
        ),
      ),
    );
  }
}

class OrdersBody extends StatelessWidget {
  const OrdersBody({
    Key? key,
    this.coinsExchangeRates,
  }) : super(key: key);
  final coinsExchangeRates;

  @override
  Widget build(BuildContext context) {
    // print(orders);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          SizedBox(height: 10),
          OrdersOnProcess(coinsExchangeRates: coinsExchangeRates),
          CompletedOrders(coinsExchangeRates: coinsExchangeRates),
        ],
      ),
    );
  }
}
