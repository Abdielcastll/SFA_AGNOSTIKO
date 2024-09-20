// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';

class CompletedOrderPage extends StatelessWidget {
  const CompletedOrderPage({
    Key? key,
    required this.client,
    required this.total,
    required this.method,
    required this.date,
    required this.address,
    this.orderNumber,
    required this.completedMessage,
  }) : super(key: key);

  final client;
  final total;
  final method;
  final date;
  final address;
  final orderNumber;
  final String completedMessage;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    List<String> currentCoinSplit = currentCoin!.split(' ');
    String currentCoinSelectedCode = currentCoinSplit.last;
    return Scaffold(
      backgroundColor: themeProvider.myTheme.colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: themeProvider.myTheme.colorScheme.primary,
          foregroundColor: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: MultiProvider(
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
          child: CompletedOrderBody(
            client: client,
            total: total,
            method: method,
            date: date,
            address: address,
            orderNumber: orderNumber,
            completedMessage: completedMessage,
          ),
        ),
      ),
    );
  }
}

class CompletedOrderBody extends StatefulWidget {
  const CompletedOrderBody({
    Key? key,
    required this.client,
    required this.total,
    required this.method,
    required this.date,
    required this.address,
    required this.orderNumber,
    required this.completedMessage,
  }) : super(key: key);
  final client;
  final total;
  final method;
  final date;
  final address;
  final orderNumber;
  final String completedMessage;

  @override
  State<CompletedOrderBody> createState() => _CompletedOrderBody();
}

class _CompletedOrderBody extends State<CompletedOrderBody> {
  @override
  Widget build(BuildContext context) {
    final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 0;
    final coinExchangeRatio = Provider.of<Coin?>(context)?.exchangeRatio ?? 0;
    final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '';

    final total = priceMultipliedByItsExchangeRatio(
        productPrice: widget.total,
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Column(
      children: [
        Container(
          color: Colors.transparent,
          margin: const EdgeInsets.fromLTRB(15, 40, 20, 0),
          child: Text(
            widget.completedMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: themeProvider.myTheme.colorScheme.primary,
              fontFamily: 'Poppins-regular',
              fontSize: 25,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 17, 0, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CLIENTE',
                          style: TextStyle(
                            color: Color(0xFF7D5070),
                            fontFamily: 'Poppins-Medium',
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          // height: 60,
                          width: 140,
                          child: Text(
                            widget.client,
                            style: TextStyle(
                              color: Color(0xFF5A5D77),
                              fontFamily: 'Poppins-Medium',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FECHA DE PEDIDO',
                          style: TextStyle(
                            color: Color(0xFF7D5070),
                            fontFamily: 'Poppins-Medium',
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.date,
                          style: TextStyle(
                            color: Color(0xFF5A5D77),
                            fontFamily: 'Poppins-Medium',
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PEDIDO',
                          style: TextStyle(
                            color: Color(0xFF7D5070),
                            fontFamily: 'Poppins-Medium',
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '# ${widget.orderNumber}',
                          style: TextStyle(
                            color: Color(0xFF5A5D77),
                            fontFamily: 'Poppins-Medium',
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Container(
                margin: const EdgeInsets.only(top: 17),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MÉTODO DE PAGO',
                            style: TextStyle(
                              color: Color(0xFF7D5070),
                              fontFamily: 'Poppins-Medium',
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${widget.method}',
                            style: TextStyle(
                              color: Color(0xFF5A5D77),
                              fontFamily: 'Poppins-Medium',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MONTO A PAGAR',
                            style: TextStyle(
                              color: Color(0xFF7D5070),
                              fontFamily: 'Poppins-Medium',
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '$coinSymbol ${total.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Color(0xFF5A5D77),
                              fontFamily: 'Poppins-Medium',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DIRECCION',
                            style: TextStyle(
                              color: Color(0xFF7D5070),
                              fontFamily: 'Poppins-Medium',
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            // height: 60,
                            width: 150,
                            child: Text(
                              '${widget.address ?? ''}',
                              style: TextStyle(
                                color: Color(0xFF5A5D77),
                                fontFamily: 'Poppins-Medium',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 250,
          child: Image.asset(
            'assets/images/receipt.png',
            fit: BoxFit.cover,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor:
                    themeProvider.myTheme.colorScheme.primary.withOpacity(0.1),
                child: IconButton(
                  onPressed: () {
                    // Compartir
                  },
                  splashRadius: 15,
                  splashColor: themeProvider.myTheme.colorScheme.primary,
                  icon: Icon(
                    Icons.share,
                    color: themeProvider.myTheme.colorScheme.primary,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          width: 340,
          height: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ElevatedButton(
              onPressed: () {
                objectBox.delelteAllShoppingCart();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  themeProvider.myTheme.colorScheme.primary,
                ),
                foregroundColor: MaterialStateProperty.all(
                  Colors.white,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'REGRESAR AL INICIO',
                    style: TextStyle(
                        fontFamily: 'Poppins-Medium',
                        fontSize: 14,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: themeProvider.myTheme.colorScheme.primary, width: 2)),
          width: 340,
          height: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ElevatedButton(
              onPressed: () {
                final orderActive =
                    Provider.of<OrderProvider>(context, listen: false);
                objectBox.delelteAllShoppingCart();
                Navigator.popUntil(context, (route) => route.isFirst);
                orderActive.setOrder(false);
                final j =
                    Provider.of<CounterLimitFirestore>(context, listen: false);
                j.setNewScreen(1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'VER AGENDA',
                    style: TextStyle(
                      fontFamily: 'Poppins-Medium',
                      fontSize: 14,
                      color: themeProvider.myTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
