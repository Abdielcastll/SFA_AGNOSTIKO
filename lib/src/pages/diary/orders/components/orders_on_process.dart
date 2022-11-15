import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/order_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/order_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrdersOnProcess extends StatelessWidget {
  const OrdersOnProcess({
    Key? key,
    this.coinsExchangeRates,
  }) : super(key: key);

  final coinsExchangeRates;

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<Orders>?>(context) ?? [];
    var dateFormatter = DateFormat('yyyy-MM-dd');
    final ordersOnProcess =
        orders.where((element) => element.isInvoiced == false).toList();

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 0, 10),
                child: Text(
                  textAlign: TextAlign.start,
                  AppLocalizations.of(context)!.onProcess,
                  style: TextStyle(
                    color: Colors.amber.shade600,
                    fontFamily: 'Poppins-regular',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
                    final orderStatus = AppLocalizations.of(context)!.onProcess;
                    final date =
                        DateTime.parse(unformattedDate.toDate().toString());
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
                      coinsExchangeRates: coinsExchangeRates,
                      discountMaster: orderDiscountMaster,
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
