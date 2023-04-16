import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
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
    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    List<String> currentCoinSplit = currentCoin!.split(' ');
    String currentCoinSelectedCode = currentCoinSplit.last;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: myTheme.colorScheme.primary,
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
    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    final coinName = Provider.of<Coin?>(context)?.name ?? '';
    final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 0;
    final coinExchangeRatio = Provider.of<Coin?>(context)?.exchangeRatio ?? 0;
    final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '';
    final coinCode = Provider.of<Coin?>(context)?.code ?? '';

    final total = priceMultipliedByItsExchangeRatio(
        productPrice: widget.total,
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio);

    return Column(
      children: [
        Container(
          color: Colors.transparent,
          margin: const EdgeInsets.fromLTRB(15, 40, 20, 0),
          child: Text(
            widget.completedMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: myTheme.colorScheme.secondary,
              fontFamily: 'Poppins-regular',
              fontSize: 25,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 10, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
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
                          'CLIENTE',
                          style: TextStyle(
                            color: Colors.purple.shade600,
                            fontFamily: 'Poppins-regular',
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          // height: 60,
                          width: 140,
                          child: Text(
                            widget.client,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontFamily: 'Poppins-regular',
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
                            color: Colors.purple.shade600,
                            fontFamily: 'Poppins-regular',
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          widget.date,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontFamily: 'Poppins-regular',
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
                            color: Colors.purple.shade600,
                            fontFamily: 'Poppins-regular',
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '# ${widget.orderNumber}',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontFamily: 'Poppins-regular',
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
                              color: Colors.purple.shade600,
                              fontFamily: 'Poppins-regular',
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${widget.method}',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontFamily: 'Poppins-regular',
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
                              color: Colors.purple.shade600,
                              fontFamily: 'Poppins-regular',
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '$coinSymbol ${total.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontFamily: 'Poppins-regular',
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
                              color: Colors.purple.shade600,
                              fontFamily: 'Poppins-regular',
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            // height: 60,
                            width: 150,
                            child: Text(
                              '${widget.address}',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontFamily: 'Poppins-regular',
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
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          width: 340,
          height: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ElevatedButton(
              onPressed: () {
                objectBox.delelteAllShoppingCart();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: myTheme.colorScheme.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Regresar al Inicio',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                    child: const Icon(
                      SimpleLineIcons.check,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Image.asset(
          'assets/images/receipt.png',
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
