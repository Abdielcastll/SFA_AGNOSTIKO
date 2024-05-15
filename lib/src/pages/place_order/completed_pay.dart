import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/dialogs/confirm_dialog.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/add_payment.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/invoicePrintLayout.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class CompletedPayPage extends StatelessWidget {
  const CompletedPayPage({
    Key? key,
    required this.client,
    required this.total,
    required this.method,
    required this.date,
    required this.address,
    required this.coinsExchangeRates,
    required this.addPaymentBody,
    this.orderNumber,
  }) : super(key: key);

  final Client client;
  final total;
  final method;
  final date;
  final address;
  final orderNumber;
  final coinsExchangeRates;
  final AddPaymentBodyAtt addPaymentBody;

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
          child: CompletedPayBody(
            client: client,
            total: total,
            method: method,
            date: date,
            address: address,
            orderNumber: orderNumber,
            coinsExchangeRates: coinsExchangeRates,
            addPaymentBody: addPaymentBody,
            currentCoin: currentCoin,
          ),
        ),
      ),
    );
  }
}

class CompletedPayBody extends StatefulWidget {
  const CompletedPayBody({
    Key? key,
    required this.client,
    required this.total,
    required this.method,
    required this.date,
    required this.address,
    required this.orderNumber,
    required this.coinsExchangeRates,
    required this.addPaymentBody,
    required this.currentCoin,
  }) : super(key: key);
  final Client client;
  final total;
  final method;
  final date;
  final address;
  final orderNumber;
  final coinsExchangeRates;
  final AddPaymentBodyAtt addPaymentBody;
  final currentCoin;

  @override
  State<CompletedPayBody> createState() => _CompletedPayBody();
}

class _CompletedPayBody extends State<CompletedPayBody> {
  late List<double> coinsExchangeRates = widget.coinsExchangeRates;
  late double totalPayed = widget.addPaymentBody.payments.fold<double>(
      0.0, (previousValue, element) => previousValue + element.amount);
  bool isKiosko = globalRemoteConfig.conversionKiosko!;
  bool ticketPrinted = false;

  onGoBack() {
    if (!isKiosko) {
      final orderActive = Provider.of<OrderProvider>(context, listen: false);
      orderActive.setOrder(false);
    }
    objectBox.delelteAllShoppingCart();
    print('Going back');
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  showModalNoTicketPrinted() {
    showConfirmDialog(context,
        title: '¿Estas seguro?',
        message: 'No has imprimido la factura. ¿Seguro que deseas regresar?',
        textAccept: 'Si',
        textCancel: 'No', onAccept: () {
      onGoBack();
    }, onCancel: () {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isKiosko) {
        startTimer();
      }
    });
  }

  void startTimer() {
    invoicePrintLayout(widget.addPaymentBody, widget.currentCoin);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          onGoBack();
        });
        return AlertDialog(
          title: Padding(
            padding: const EdgeInsets.all(25),
            child: Text(
              'Por favor retire su comprobante y ticket de compra.',
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 0;
    final coinExchangeRatio = Provider.of<Coin?>(context)?.exchangeRatio ?? 0;
    final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '';
    final currentCoin =
        Provider.of<CurrencyProvider>(context).currentCurrency ?? 'MXN';

    priceFormat(productPrice) {
      double correctAmount = double.parse(productPrice.toStringAsFixed(4));
      double convertedAmount = double.parse(
          (correctAmount * coinExchangeRatio).toStringAsFixed(coinDecimals));
      return convertedAmount;
    }

    return Column(
      children: [
        Container(
          color: Colors.transparent,
          margin: const EdgeInsets.fromLTRB(15, 40, 20, 0),
          child: Text(
            '¡Pago Completado!',
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
                          width: 140,
                          child: Text(
                            widget.client.name,
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
                          'FECHA DE PAGO',
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'MONTO PAGADO',
                            style: TextStyle(
                              color: Colors.purple.shade600,
                              fontFamily: 'Poppins-regular',
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              '$coinSymbol ${priceFormat(widget.total).toStringAsFixed(2)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: myTheme.colorScheme.onPrimaryContainer,
                                fontFamily: 'Poppins-regular',
                                fontSize: 14,
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
        if (isKiosko == false)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            width: 340,
            height: 100,
            child: /*  ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: */
                Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (!ticketPrinted) {
                      showModalNoTicketPrinted();
                      return;
                    }

                    onGoBack();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      myTheme.colorScheme.primary,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Regresar al Inicio',
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
                          color: Colors.white,
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
                ElevatedButton(
                  onPressed: () async {
                    await invoicePrintLayout(
                        widget.addPaymentBody, currentCoin);
                    setState(() {
                      ticketPrinted = true;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      myTheme.colorScheme.primary,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Imprimir Factura',
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
                          color: Colors.white,
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
              ],
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
