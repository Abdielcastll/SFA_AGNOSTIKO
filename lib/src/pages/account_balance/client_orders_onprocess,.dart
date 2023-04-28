import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/order_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/order_card.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ClientsOrdersOnProcess extends StatefulWidget {
  ClientsOrdersOnProcess({super.key, this.controller});

  ScrollController? controller;

  @override
  State<ClientsOrdersOnProcess> createState() => _ClientsOrdersOnProcessState();
}

class _ClientsOrdersOnProcessState extends State<ClientsOrdersOnProcess> {
  bool isDescending = false;

  @override
  Widget build(BuildContext context) {
    var dateFormatter = DateFormat('dd-MM-yyyy');

    final orders = Provider.of<List<Orders>?>(context) ?? [];
    final ordersOnProcess = orders
        .where((element) => element.isInvoiced == false)
        .toList()
        .reversed
        .toList();
    return SingleChildScrollView(
      child: Column(
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
          ordersOnProcess.isNotEmpty
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.61,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Scrollbar(
                      child: ListView.builder(
                        controller: widget.controller,
                        itemCount: ordersOnProcess.length,
                        itemBuilder: (BuildContext context, int index) {
                          final sortedOrders = isDescending
                              ? ordersOnProcess.reversed.toList()
                              : ordersOnProcess;
                          final order = sortedOrders[index];
                          final orderTotalAmount = order.totalAmount ?? 0;
                          final unformattedDate =
                              order.date ?? Timestamp.fromDate(DateTime.now());
                          final orderStatus =
                              AppLocalizations.of(context)!.onProcess;
                          final date = DateTime.parse(
                              unformattedDate.toDate().toString());
                          final deliveryDate = dateFormatter.format(date);
                          final orderCommentary = order.commentary;
                          final orderClientRefID = order.clientDocumentRef;
                          final orderRefID = order.orderDocumentRef;
                          final orderIsFailed = order.isInvoiceFailed;
                          final orderProducts = order.products;
                          final orderTax = order.tax;
                          final orderSubTotal = order.subTotal;
                          final orderDiscountMaster = order.masterDiscount;
                          // print('orderTotalAmount: $orderTotalAmount');
                          // print('unformattedDate: $unformattedDate');
                          // print('orderStatus: $orderStatus');
                          // print('date: $date');
                          // print('deliveryDate: $deliveryDate');
                          // print('orderCommentary: $orderCommentary');
                          // print('orderClientRefID: $orderClientRefID');
                          // print('orderRefID: $orderRefID');
                          // print('orderIsFailed: $orderIsFailed');
                          // print('orderProducts: $orderProducts');
                          // print('orderTax: $orderTax');
                          // print('orderSubTotal: $orderSubTotal');
                          // print('orderDiscountMaster: $orderDiscountMaster');
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
                            discountMaster: orderDiscountMaster,
                            correlativeNumber: order.correlativeNumber,
                            showButton: false,
                          );
                        },
                      ),
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
                              'No hay ordenes registradas',
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
      ),
    );
  }
}
