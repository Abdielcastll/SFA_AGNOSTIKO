// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/order_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/order_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class CompletedOrders extends StatefulWidget {
  const CompletedOrders({
    Key? key,
    required this.isDescending,
  }) : super(key: key);

  final bool isDescending;

  @override
  State<CompletedOrders> createState() => _CompletedOrdersState();
}

class _CompletedOrdersState extends State<CompletedOrders> {
  var dateFormatter = DateFormat('dd-MM-yyyy');
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<Orders>?>(context) ?? [];
    print('ordenes: ${orders.length}');
    final ordersCompleted = orders
        .where((element) => element.isInvoiced == true)
        .toList()
        .reversed
        .toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ordersCompleted.isNotEmpty
            ? SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.52,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: ordersCompleted.length,
                    itemBuilder: (BuildContext context, int index) {
                      final sortedOrders = widget.isDescending
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
                      final orderStatus =
                          AppLocalizations.of(context)!.completed;
                      final orderProducts = order.products;
                      final orderSubTotal = order.subTotal;
                      final orderDiscountMaster = order.masterDiscount;
                      final orderTax = order.tax;
                      final orderExchangeRates = order.exchangeRate;
                      final orderProductQuantities = order.productsQuantity;
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
                        showButton: true,
                        coinsExchangeRates: orderExchangeRates,
                        orderProductQuantities: orderProductQuantities,
                      );
                    },
                  ),
                ),
              )
            : Container(
                margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              // Colors.red.withOpacity(0.3)),
                              myTheme.colorScheme.primary.withOpacity(0.3)),
                      width: 120,
                      height: 120,
                      child: Opacity(
                        opacity: 0.8,
                        child: Icon(
                          MaterialCommunityIcons.calendar_remove_outline,
                          color: myTheme.colorScheme.onPrimaryContainer,
                          size: 60,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Center(
                        child: Container(
                          width: 250,
                          child: Text(
                            'No hay ordenes registradas este día',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontSize: 16,
                              color: myTheme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
