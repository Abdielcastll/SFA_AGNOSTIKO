import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/order_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/account_balance/client_orders_completed.dart';
import 'package:pwa_sales2go_flutter/src/pages/account_balance/client_orders_onprocess,.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/orders_page.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClientOrders extends StatefulWidget {
  const ClientOrders({super.key, required this.clientDocument});

  final clientDocument;

  @override
  State<ClientOrders> createState() => _ClientOrdersState();
}

class _ClientOrdersState extends State<ClientOrders> {
  @override
  Widget build(BuildContext context) {
    final document = clientsCollection
        .doc(widget.clientDocument)
        .collection('pedidos')
        .orderBy('fecha')
        .snapshots();
    return MultiProvider(
      providers: [
        StreamProvider<List<Orders>?>.value(
          value: document
              // FirebaseFirestore.instance
              //     .collectionGroup('pedidos')
              // .orderBy('fecha')
              //     .where(field)
              //     .snapshots()
              .map(ordersFromSnapshot),
          initialData: const [],
          catchError: (context, error) {
            print(error);
          },
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: myTheme.colorScheme.surface,
          body: ClientOrdersBody(),
        ),
      ),
    );
  }
}

class ClientOrdersBody extends StatefulWidget {
  const ClientOrdersBody({super.key});

  @override
  State<ClientOrdersBody> createState() => _ClientOrdersBodyState();
}

class _ClientOrdersBodyState extends State<ClientOrdersBody> {
  bool seeCompleted = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:
          // Center(
          //   child: CircularProgressIndicator(),
          // ),
          Column(
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
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: const Text(
                  'Ver completados',
                  style: TextStyle(
                    fontSize: 15,
                    // fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins-regular',
                  ),
                ),
              ),
              Checkbox(
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
          seeCompleted == false
              ? ClientsOrdersOnProcess()
              : ClientOrdersCompleted(),
        ],
      ),
    );
  }
}
