// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/diary/orders/components/order_card.dart';

class OrdersOnProcess extends StatelessWidget {
  const OrdersOnProcess({
    Key? key,
    required this.onProcessList,
  }) : super(key: key);

  final List onProcessList;

  @override
  Widget build(BuildContext context) {
    print('ordenes en proceso: ${onProcessList.length}');
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  textAlign: TextAlign.start,
                  'Por Procesar',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            child: Container(
              height: 230,
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: onProcessList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final order = onProcessList[index];
                    // print(order);
                    return OrderCard(
                      name: order['nameClient'],
                      clientId: order['clientID'],
                      orderId: order['orderID'],
                      date: order['date'],
                      total: order['total'],
                      completed: order['completed'],
                      failed: order['failed'],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
