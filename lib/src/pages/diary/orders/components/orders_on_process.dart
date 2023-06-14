import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/order_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/order_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/loading/loading_widget.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class OrdersOnProcess extends StatefulWidget {
  const OrdersOnProcess({
    Key? key,
    required this.isDescending,
  }) : super(key: key);

  final bool isDescending;

  @override
  State<OrdersOnProcess> createState() => _OrdersOnProcessState();
}

class _OrdersOnProcessState extends State<OrdersOnProcess> {
  var dateFormatter = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
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
          ordersOnProcess.isNotEmpty
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.52,
                    // height: 426,
                    child: Scrollbar(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: ordersOnProcess.length,
                        itemBuilder: (BuildContext context, int index) {
                          final sortedOrders = widget.isDescending
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
                          final orderExchangeRates = order.exchangeRate;
                          final orderProductQuantities = order.productsQuantity;
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
                            showButton: true,
                            coinsExchangeRates: orderExchangeRates,
                            orderProductQuantities: orderProductQuantities,
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
      ),
    );
  }
}
