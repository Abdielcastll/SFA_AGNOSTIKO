// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class CompletedOrderPage extends StatelessWidget {
  const CompletedOrderPage({
    Key? key,
    required this.client,
    required this.total,
    required this.method,
    required this.date,
    required this.address,
    this.orderNumber,
  }) : super(key: key);

  final client;
  final total;
  final method;
  final date;
  final address;
  final orderNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(20),
        child: AppBar(
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.vertical(
          //     bottom: Radius.circular(20),
          //   ),
          // ),
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: myTheme.colorScheme.primary,
        ),
      ),
      body: SingleChildScrollView(
        child: CompletedOrderBody(
          client: client,
          total: total,
          method: method,
          date: date,
          address: address,
          orderNumber: orderNumber,
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
  }) : super(key: key);
  final client;
  final total;
  final method;
  final date;
  final address;
  final orderNumber;

  @override
  State<CompletedOrderBody> createState() => _CompletedOrderBody();
}

class _CompletedOrderBody extends State<CompletedOrderBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          margin: EdgeInsets.fromLTRB(15, 40, 20, 0),
          child: Text(
            '¡Pedido Completado!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: myTheme.colorScheme.secondary,
              fontFamily: 'Poppins-regular',
              fontSize: 25,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 10, 10, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                        Container(
                          // height: 60,
                          width: 140,
                          child: Text(
                            widget.client,
                            // 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',
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
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
              SizedBox(width: 20),
              Container(
                margin: EdgeInsets.only(top: 17),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                            'USD\$ ${widget.total.toStringAsFixed(2)}',
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
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                          Container(
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
        SizedBox(height: 20),
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
                // Continuar con la compra
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: myTheme.colorScheme.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Regresar al Inicio',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                    child: Icon(
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
