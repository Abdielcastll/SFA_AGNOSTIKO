// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/account_balance_model.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/order_model.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';

class InvoiceDetails extends StatefulWidget {
  const InvoiceDetails(
      {super.key,
      required this.number,
      required this.totalOfTheOrder,
      required this.coinDecimals,
      required this.coinExchangeRatio,
      required this.coinSymbol,
      required this.clientID,
      required this.isPaid,
      required this.orderID});

  final String number;
  final String coinSymbol;
  final String clientID;
  final String orderID;
  final double totalOfTheOrder;
  final double coinExchangeRatio;
  final int coinDecimals;
  final bool isPaid;

  @override
  State<InvoiceDetails> createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      StreamProvider<Client?>.value(
        value: FirebaseFirestore.instance
            .collection('clientes')
            .doc(widget.clientID.toString())
            .snapshots()
            .map(clientFromDocumentID),
        initialData: Client(),
        catchError: (context, error) {
          print('ERROR ON FETCHING CLIENT IN TICKET DETAILS');
          print(error);
          return;
        },
      ),
      StreamProvider<ClientOrder?>.value(
        value: FirebaseFirestore.instance
            .collection('clientes')
            .doc(widget.clientID.toString())
            .collection('pedidos')
            .doc(widget.orderID)
            .snapshots()
            .map(orderFromdocument),
        initialData: ClientOrder(),
        catchError: (context, error) {
          print('ERROR ON GETTING ORDER IN TICKET DETAILS');
          print(error);
        },
      ),
    ], child: InvoiceDetailsBody(widget: widget));
  }
}

class InvoiceDetailsBody extends StatelessWidget {
  const InvoiceDetailsBody({
    super.key,
    required this.widget,
  });

  final InvoiceDetails widget;

  @override
  Widget build(BuildContext context) {
    final currentClientName = Provider.of<Client?>(context)?.name ?? '';
    final currentClientPhone = Provider.of<Client?>(context)?.phone1 ?? '';
    final currentClientAddress =
        Provider.of<Client?>(context)?.fiscalAdress ?? '';
    final orderProducts = Provider.of<ClientOrder?>(context)?.products ?? [];

    var totalAmountConverted = priceMultipliedByItsExchangeRatio2(
      productPrice: widget.totalOfTheOrder,
      coinDecimals: widget.coinDecimals,
      coinExchangeRatio: widget.coinExchangeRatio,
    );

    var totalAmountFormatted =
        formatDecimalPriceByRegion(price: totalAmountConverted);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ticket #${widget.number}',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            fontSize: 20,
          ),
        ),
      ),
      bottomSheet: Container(
        alignment: Alignment.center,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300, //New
              blurRadius: 5.0,
              offset: Offset(0, -1),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total del pedido',
                style: TextStyle(
                  fontFamily: 'Poppins-medium',
                  fontSize: 14,
                  color: myTheme.colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                '${widget.coinSymbol} $totalAmountFormatted',
                style: TextStyle(
                  fontFamily: 'Poppins-medium',
                  fontSize: 14,
                  color: myTheme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: myTheme.colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.white,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '$currentClientName',
                    style: TextStyle(
                      fontFamily: 'Poppins-medium',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 180,
                      child: Text(
                        '$currentClientAddress',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Poppins-medium',
                          fontSize: 11,
                          color: Color(0xFF5A5D77),
                        ),
                      ),
                    ),
                    Text(
                      '$currentClientPhone',
                      style: TextStyle(
                        fontFamily: 'Poppins-medium',
                        fontSize: 11,
                        color: Color(0xFF7D5070),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FECHA DE COBRO',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Poppins-medium',
                          fontSize: 14,
                          color: Color(0xFF7D5070),
                        ),
                      ),
                      Text(
                        '10/07/2023',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Poppins-medium',
                          fontSize: 12,
                          color: Color(0xFF5A5D77),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TIPO DE TICKET',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Poppins-medium',
                          fontSize: 14,
                          color: Color(0xFF7D5070),
                        ),
                      ),
                      Text(
                        widget.isPaid ? 'Completada' : 'En proceso',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Poppins-medium',
                          fontSize: 12,
                          color: Color(0xFF5A5D77),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 0, 8),
              child: Text(
                'ITEMS',
                style: TextStyle(
                  fontFamily: 'Poppins-medium',
                  fontSize: 14,
                  color: Color(0xFF7D5070),
                ),
              ),
            ),
            Container(
              // height: 250,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: orderProducts.length,
                itemBuilder: (context, index) {
                  final product = orderProducts[index];

                  var unitPriceConverted = priceMultipliedByItsExchangeRatio2(
                    productPrice: product['monto'],
                    coinDecimals: widget.coinDecimals,
                    coinExchangeRatio: widget.coinExchangeRatio,
                  );

                  var unitPriceFormatted =
                      formatDecimalPriceByRegion(price: unitPriceConverted);

                  var productPriceConverted =
                      priceMultipliedByItsExchangeRatio2(
                    productPrice: double.parse(
                        (Decimal.parse(product['monto'].toString()) *
                                Decimal.parse(product['cantidad'].toString()))
                            .toString()),
                    coinDecimals: widget.coinDecimals,
                    coinExchangeRatio: widget.coinExchangeRatio,
                  );

                  var productPriceFormatted =
                      formatDecimalPriceByRegion(price: productPriceConverted);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      width: 380,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 99,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                            ),
                            child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                                child: Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                )
                                // Image.network(
                                //   'https://d36tnp772eyphs.cloudfront.net/blogs/1/2018/02/Taj-Mahal.jpg',
                                //   fit: BoxFit.cover,
                                // ),
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 13, 0, 13),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 200,
                                  child: Text(
                                    '${product['nombre']}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Poppins-medium',
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'U: ${product['cantidad']}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-medium',
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        '${widget.coinSymbol} $unitPriceFormatted',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-medium',
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 40),
                                      Text(
                                        '${widget.coinSymbol} $productPriceFormatted',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-medium',
                                          fontSize: 14,
                                          color: Color(0xFF7D5070),
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
                  );
                },
              ),
            ),
            SizedBox(height: 80)
          ],
        ),
      ),
    );
  }
}
