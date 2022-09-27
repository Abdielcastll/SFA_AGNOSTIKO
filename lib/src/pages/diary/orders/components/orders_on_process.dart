// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/order_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/order_card.dart';

class OrdersOnProcess extends StatelessWidget {
  const OrdersOnProcess({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<Orders>?>(context) ?? [];
    var dateFormatter = DateFormat('yyyy-MM-dd');
    final ordersOnProcess =
        orders.where((element) => element.isInvoiced == false).toList();
    // print(orders);
    print('Ordenes en procesos: ${ordersOnProcess.length}');
    // final clientNames = Provider.of<List<ClientName>?>(context) ?? [];

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
                  itemCount: ordersOnProcess.length,
                  itemBuilder: (BuildContext context, int index) {
                    final order = ordersOnProcess[index];
                    final orderTotalAmount = order.totalAmount ?? 0;
                    final unformattedDate = order.deliveryDate ??
                        Timestamp.fromDate(DateTime.now());
                    final orderStatus = 'En proceso';
                    final date =
                        DateTime.parse(unformattedDate.toDate().toString());
                    final deliveryDate = dateFormatter.format(date);
                    final orderCommentary = order.commentary;
                    final orderClientRefID = order.clientDocumentRef;
                    final orderRefID = order.orderDocumentRef;
                    final orderIsFailed = order.isInvoiceFailed;
                    final orderProducts = order.products;
                    final orderTax = order.tax;
                    final orderSubTotal = order.subTotal; // print(order);
                    return OrderCard(
                      clientReferenceId: orderClientRefID,
                      date: deliveryDate,
                      total: orderTotalAmount,
                      orderDocumentId: orderRefID,
                      status: orderStatus,
                      isInvoicesFailed: orderIsFailed,
                      commentary: orderCommentary,
                      products: orderProducts,
                      tax: orderTax,
                      subTotal: orderSubTotal,
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
