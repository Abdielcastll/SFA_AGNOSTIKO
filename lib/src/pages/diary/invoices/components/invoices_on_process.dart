// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/account_balance_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/invoices/components/invoice_card.dart';
import 'package:pwa_sales2go_flutter/src/widgets/loading/loading_widget.dart';

class InvoicesOnProcess extends StatefulWidget {
  const InvoicesOnProcess({Key? key}) : super(key: key);

  @override
  State<InvoicesOnProcess> createState() => _InvoicesOnProcessState();
}

class _InvoicesOnProcessState extends State<InvoicesOnProcess> {
  var dateFormatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    final invoices = Provider.of<List<Invoices>?>(context) ?? [];
    final invoicesList =
        invoices.where((element) => element.isPaid == false).toList();
    // print(invoicesList);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  textAlign: TextAlign.start,
                  'Por Realizar',
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
                  // physics: BouncingScrollPhysics(),
                  itemCount: invoicesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final invoice = invoicesList[index];
                    final invoiceClient = invoice.clientIdReference;
                    final unformattedDate =
                        invoice.orderDate ?? Timestamp.fromDate(DateTime.now());
                    final date =
                        DateTime.tryParse(unformattedDate.toDate().toString());

                    final invoiceDate =
                        dateFormatter.format(date ?? DateTime.now());
                    final invoiceBalance = invoice.totalAmount;
                    final invoicePayments = invoice.payments;
                    const invoiceStatus = 'En proceso';
                    final invoiceNumber = invoice.correlativeNumber;
                    final invoiceTotal = invoice.totalAmount;
                    final invoiceDocumentID = invoice.invoiceDocumentID;
                    // print(invoice);
                    return InvoiceCard(
                      invoiceClient: invoiceClient,
                      invoiceDate: invoiceDate,
                      invoiceBalance: invoiceBalance,
                      invoiceStatus: invoiceStatus,
                      invoicePayments: invoicePayments,
                      invoiceNumber: invoiceNumber,
                      invoiceTotal: invoiceTotal,
                      invoiceDocumentID: invoiceDocumentID,
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
