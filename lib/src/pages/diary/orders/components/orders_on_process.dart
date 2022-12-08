import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/order_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/order_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class OrdersOnProcess extends StatelessWidget {
  const OrdersOnProcess({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<Orders>?>(context) ?? [];
    print('ordenes: ${orders.length}');
    var dateFormatter = DateFormat('yyyy-MM-dd');
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
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: ordersOnProcess.length,
                        itemBuilder: (BuildContext context, int index) {
                          final order = ordersOnProcess[index];
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
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  alignment: Alignment.center,
                  child: Center(
                    child: Text(
                      'No hay Ordenes pendientes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: myTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
