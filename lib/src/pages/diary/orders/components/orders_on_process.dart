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
  }) : super(key: key);

  @override
  State<OrdersOnProcess> createState() => _OrdersOnProcessState();
}

class _OrdersOnProcessState extends State<OrdersOnProcess> {
  bool isDescending = false;
  DateTime today = DateTime.now();
  var dateFormatter = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<Orders>?>(context) ?? [];
    final currentDay =
        Provider.of<CounterLimitFirestore>(context).currentDayOrder;
    final currentDateTime = currentDay.toDate();
    String formattedDate = dateFormatter.format(currentDateTime);
    print('ordenes: ${orders.length}');
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
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        color: myTheme.colorScheme.secondary,
                        size: 25,
                      ),
                      const SizedBox(width: 5),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
                        child: Text(
                          isDescending
                              ? AppLocalizations.of(context)!.ascendingFilter
                              : AppLocalizations.of(context)!.descendingFilter,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            // color: Colors.grey.shade500,
                            color: myTheme.colorScheme.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    // Re ordenar el list view alfabeticamente
                    setState(() => isDescending = !isDescending);
                  },
                ),
                const SizedBox(width: 20),
                Container(
                  height: 40,
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: myTheme.colorScheme.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
                        child: Text(
                          currentDay !=
                                  Timestamp.fromDate(DateTime(
                                    DateTime.now().year + 99,
                                    DateTime.now().month + 99,
                                    DateTime.now().day + 99,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                  ))
                              ? formattedDate
                              : '00-00-0000',
                          style: TextStyle(
                            fontSize: 14,
                            // fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins-regular',
                            color: myTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                      Container(
                        width: 20,
                        child: IconButton(
                          onPressed: () async {
                            final currentDayProvider =
                                Provider.of<CounterLimitFirestore>(context,
                                    listen: false);

                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2010),
                              lastDate: DateTime(2030),
                            );
                            if (newDate == null) {
                              return;
                            }
                            setState(() {
                              today = newDate;
                              formattedDate = dateFormatter.format(newDate);
                              final newDay = Timestamp.fromDate(newDate);
                              currentDayProvider.setNewDayOrder(newDay);
                            });
                          },
                          splashRadius: 5,
                          icon: Icon(
                            MaterialCommunityIcons.calendar_edit,
                            color: myTheme.colorScheme.primary.withOpacity(0.8),
                            size: 20,
                          ),
                        ),
                      ),
                      Container(
                        // width: 20,
                        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: IconButton(
                          onPressed: () {
                            final currentDayProvider =
                                Provider.of<CounterLimitFirestore>(context,
                                    listen: false);
                            setState(() {
                              currentDayProvider
                                  .setNewDayOrder(Timestamp.fromDate(DateTime(
                                DateTime.now().year + 99,
                                DateTime.now().month + 99,
                                DateTime.now().day + 99,
                                0,
                                0,
                                0,
                                0,
                                0,
                              )));
                            });
                          },
                          splashRadius: 5,
                          icon: Icon(
                            MaterialCommunityIcons.calendar_remove,
                            color: myTheme.colorScheme.onPrimaryContainer,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                          final orderExchangeRates = order.exchangeRate;
                          print(orderExchangeRates);
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
