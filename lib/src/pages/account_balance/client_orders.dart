import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/order_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_rol_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/account_balance/client_orders_completed.dart';
import 'package:pwa_sales2go_flutter/src/pages/account_balance/client_orders_onprocess,.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/orders_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
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
    final user = Provider.of<CurrentUserInfo?>(context);
    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    List<String> currentCoinSplit = currentCoin!.split(' ');
    String currentCoinSelectedCode = currentCoinSplit.last;

    final scrollLimit =
        Provider.of<CounterLimitFirestore>(context).getScrollOrderBalance;
    final document = clientsCollection
        .doc(widget.clientDocument)
        .collection('pedidos')
        .orderBy('fecha')
        .limit(scrollLimit)
        .snapshots();
    return MultiProvider(
      providers: [
        StreamProvider<List<Orders>?>.value(
          value: document.map(ordersFromSnapshot),
          initialData: const [],
          catchError: (context, error) {
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
        FutureProvider<UserRole?>.value(
          value: user?.getUserRole(),
          initialData: null,
          catchError: (context, error) {
            print(
                'ERROR ON GETTING USER ROLE IN CLIENT ORDERS IN CLIENT DETAILS');
            print(error);
            return;
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
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    // products = widget.listOfProducts;
    _controller.addListener(() {
      final productsLimitProvider =
          Provider.of<CounterLimitFirestore>(context, listen: false);
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
          int newValor =
              int.parse(productsLimitProvider.getScrollOrderBalance.toString());
          print('Top balance page');
          productsLimitProvider.setOrderBalanceLimit(30, 30);
        } else {
          if (productsLimitProvider.getScrollOrderBalanceLimit == 0) {
            productsLimitProvider.setOrderBalanceLimit(0, 0);
          } else {
            int newValor = int.parse(
                productsLimitProvider.getScrollOrderBalanceLimit.toString());
            if (newValor == 30) {
              productsLimitProvider.setOrderBalanceLimit(
                  productsLimitProvider.getScrollOrderBalance + newValor, 30);
            } else if (newValor == 50) {
              productsLimitProvider.setOrderBalanceLimit(
                  productsLimitProvider.getScrollOrderBalance + newValor, 50);
            }
          }
          print('Bottom balance page');
          Fluttertoast.showToast(
            msg: 'Solicitando +10 pedidos',
            backgroundColor: myTheme.colorScheme.primary,
            textColor: Colors.white,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<UserRole?>(context, listen: true);

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
              ? ClientsOrdersOnProcess(
                  controller: _controller,
                )
              : ClientOrdersCompleted(
                  controller: _controller,
                ),
        ],
      ),
    );
  }
}
