// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/diary/orders/components/order_card.dart';

class CompletedOrders extends StatelessWidget {
  const CompletedOrders({
    Key? key,
    required this.completedList,
  }) : super(key: key);

  final List completedList;

  @override
  Widget build(BuildContext context) {
    print('Cantidad completada: ${completedList.length}');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, top: 5),
              child: Text(
                textAlign: TextAlign.start,
                'Completado',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: completedList.length,
            itemBuilder: (BuildContext context, int index) {
              final order = completedList[index];
              // print(client);
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
      ],
    );
  }
}
