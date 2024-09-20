import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/order_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/order_card.dart';

import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ClientOrdersCompleted extends StatefulWidget {
  const ClientOrdersCompleted({
    super.key,
    this.controller,
  });

  final ScrollController? controller;

  @override
  State<ClientOrdersCompleted> createState() => _ClientOrdersCompletedState();
}

class _ClientOrdersCompletedState extends State<ClientOrdersCompleted> {
  bool isDescending = false;
  DateTime today = DateTime.now();
  var dateFormatter = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final orders = Provider.of<List<Orders>?>(context) ?? [];
    final ordersCompleted = orders
        .where((element) => element.isInvoiced == true)
        .toList()
        .reversed
        .toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   margin: const EdgeInsets.fromLTRB(10.0, 0.0, 0, 0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: [
        //       TextButton(
        //         style: ButtonStyle(
        //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //             RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(18.0),
        //             ),
        //           ),
        //         ),
        //         child: Row(
        //           children: [
        //             Icon(
        //               MaterialCommunityIcons.order_alphabetical_ascending,
        //               color: Colors.grey.shade500,
        //               size: 25,
        //             ),
        //             const SizedBox(width: 5),
        //             Text(
        //               isDescending
        //                   ? AppLocalizations.of(context)!.ascendingFilter
        //                   : AppLocalizations.of(context)!.descendingFilter,
        //               style: TextStyle(
        //                   fontFamily: 'Poppins-Regular',
        //                   color: Colors.grey.shade500,
        //                   fontSize: 14,
        //                   fontWeight: FontWeight.bold),
        //             ),
        //           ],
        //         ),
        //         onPressed: () {
        //           // Re ordenar el list view alfabeticamente
        //           setState(() => isDescending = !isDescending);
        //         },
        //       ),
        //     ],
        //   ),
        // ),
        ordersCompleted.isNotEmpty
            ? SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.61,
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: ListView.builder(
                    controller: widget.controller,
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
                        showButton: false,
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
                              themeProvider.myTheme.colorScheme.primary
                                  .withOpacity(0.3)),
                      width: 120,
                      height: 120,
                      child: Opacity(
                        opacity: 0.8,
                        child: Icon(
                          MaterialCommunityIcons.calendar_remove_outline,
                          color: themeProvider
                              .myTheme.colorScheme.onPrimaryContainer,
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
                            'No hay ordenes registradas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 16,
                              color: themeProvider
                                  .myTheme.colorScheme.onPrimaryContainer,
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
