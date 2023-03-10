import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/transaction_args.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/add_payment.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/invoicePrintLayout.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
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
        child: CompletedPayBody(
          client: client,
          total: total,
          method: method,
          date: date,
          address: address,
          orderNumber: orderNumber,
          coinsExchangeRates: coinsExchangeRates,
          addPaymentBody: addPaymentBody,
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
  State<CompletedPayBody> createState() => _CompletedPayBody();
}

class _CompletedPayBody extends State<CompletedPayBody> {
  late List<double> coinsExchangeRates = widget.coinsExchangeRates;
  late double totalPayed = widget.addPaymentBody.payments.fold<double>(
      0.0, (previousValue, element) => previousValue + element.amount);
  @override
  Widget build(BuildContext context) {
    final currentCoin =
        Provider.of<CurrencyProvider>(context).currentCurrency ?? 'MXN';

    priceFormat(productPrice) {
      double correctAmount = double.parse(productPrice.toStringAsFixed(2));
      if (currentCoin.contains('USD')) {
        return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
            .format(productPrice)
            .toString();
      } else if (currentCoin.contains('VED')) {
        return NumberFormat.currency(
          locale: 'es_VE',
          decimalDigits: 2,
          symbol: "Bs.",
        ).format(correctAmount * 4.58).toString();
      } else if (currentCoin.contains('EUR')) {
        return NumberFormat.currency(
          locale: 'es_ES',
          decimalDigits: 2,
          symbol: '€',
        ).format(correctAmount * 0.89).toString();
      } else if (currentCoin.contains('MXN')) {
        return NumberFormat.currency(
          locale: 'es_MX',
          decimalDigits: 2,
          symbol: '\$',
        ).format(correctAmount * 19.43);
      } else if (currentCoin.contains('BTC')) {
        return '฿ ${(correctAmount * 0.00011).toString()}';
      } else {
        return NumberFormat.currency(
          locale: 'es_VE',
          decimalDigits: 2,
          symbol: "PPR.",
        ).format(correctAmount * 4.58).toString();
      }
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
                          // height: 60,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MONTO PAGADO',
                            style: TextStyle(
                              color: Colors.purple.shade600,
                              fontFamily: 'Poppins-regular',
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            currentCoin != 'Dolares - USD'
                                ? '${priceFormat(widget.total)} = \$ ${widget.total.toStringAsFixed(2)}'
                                : '${priceFormat(widget.total)}',
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
          height: 100,
          child: /*  ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: */
              Column(
            children: [
              ElevatedButton(
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
              ElevatedButton(
                onPressed: () {
                  invoicePrintLayout(widget.addPaymentBody, currentCoin);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: myTheme.colorScheme.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Imprimir Factura',
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
