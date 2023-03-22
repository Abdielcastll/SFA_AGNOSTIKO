import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/order_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/order_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

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
                const SizedBox(width: 20),
                Container(
                  height: 40,
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: myTheme.colorScheme.secondary.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(currentDay !=
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
                          : 'Todos'),
                      IconButton(
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
                          Icons.calendar_month,
                          color: myTheme.colorScheme.primary.withOpacity(0.8),
                          size: 20,
                        ),
                      ),
                      Container(
                        width: 40,
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
                          icon: Icon(
                            Icons.disabled_by_default_outlined,
                            color: myTheme.colorScheme.primary,
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
                    child: Scrollbar(
                      child: ListView.builder(
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
                          );
                        },
                      ),
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        child: Image.asset(
                          'assets/images/nodiary.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        // color: Colors.green,
                        // height: 150,
                        // margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            'No hay ordenes este día',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontSize: 14,
                              color: myTheme.colorScheme.onPrimaryContainer,
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
