// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/order_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/order_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompletedOrders extends StatefulWidget {
  const CompletedOrders({
    Key? key,
  }) : super(key: key);

  @override
  State<CompletedOrders> createState() => _CompletedOrdersState();
}

class _CompletedOrdersState extends State<CompletedOrders> {
  bool isDescending = false;

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<Orders>?>(context) ?? [];
    print('ordenes: ${orders.length}');

    var dateFormatter = DateFormat('yyyy-MM-dd');
    final ordersCompleted = orders
        .where((element) => element.isInvoiced == true)
        .toList()
        .reversed
        .toList();

    final clientNames = Provider.of<List<ClientName>?>(context) ?? [];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10.0, 0.0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      MaterialCommunityIcons.order_alphabetical_ascending,
                      color: Colors.grey.shade500,
                      size: 25,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isDescending
                          ? AppLocalizations.of(context)!.ascendingFilter
                          : AppLocalizations.of(context)!.descendingFilter,
                      style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          color: Colors.grey.shade500,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onPressed: () {
                  // Re ordenar el list view alfabeticamente
                  setState(() => isDescending = !isDescending);
                },
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: ordersCompleted.length,
              itemBuilder: (BuildContext context, int index) {
                final sortedOrders = isDescending
                    ? ordersCompleted.reversed.toList()
                    : ordersCompleted;
                final order = sortedOrders[index];
                final orderTotalAmount = order.totalAmount ?? 0;
                final unformattedDate =
                    order.date ?? Timestamp.fromDate(DateTime.now());
                final date =
                    DateTime.parse(unformattedDate.toDate().toString());
                final deliveryDate = dateFormatter.format(date);
                final orderCommentary = order.commentary;
                final orderClientRefID = order.clientDocumentRef;
                final orderRefID = order.orderDocumentRef;
                final orderIsFailed = order.isInvoiceFailed;
                final orderStatus = AppLocalizations.of(context)!.completed;
                final orderProducts = order.products;
                final orderSubTotal = order.subTotal;
                final orderDiscountMaster = order.masterDiscount;
                final orderTax = order.tax;
                // print(order);
                return OrderCard(
                  clientReferenceId: orderClientRefID,
                  date: deliveryDate,
                  total: orderTotalAmount,
                  orderDocumentId: orderRefID,
                  status: orderStatus,
                  isInvoicesFailed: orderIsFailed,
                  commentary: orderCommentary,
                  products: orderProducts,
                  subTotal: orderSubTotal,
                  discountMaster: orderDiscountMaster,
                  tax: orderTax,
                  correlativeNumber: order.correlativeNumber,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
