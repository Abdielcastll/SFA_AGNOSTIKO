// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/account_balance_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/invoices/components/invoice_card.dart';

class InvoicesList extends StatelessWidget {
  const InvoicesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dateFormatter = DateFormat('yyyy-MM-dd');
    final invoices = Provider.of<List<Invoices>?>(context) ?? [];
    final invoicesList =
        invoices.where((element) => element.isPaid == true).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, top: 5),
              child: Text(
                textAlign: TextAlign.start,
                'Completado',
                style: TextStyle(
                  color: Colors.green,
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
                physics: ClampingScrollPhysics(),
                itemCount: invoicesList.length,
                itemBuilder: (BuildContext context, int index) {
                  final invoice = invoicesList[index];
                  final invoiceClient = invoice.clientIdReference;
                  final invoiceOrder = invoice.orderDate;
                  final unformattedDate =
                      invoice.orderDate ?? Timestamp.fromDate(DateTime.now());
                  final date =
                      DateTime.parse(unformattedDate.toDate().toString());
                  final invoiceDate = dateFormatter.format(date);
                  final invoiceBalance = invoice.totalAmount;
                  final invoicePayments = invoice.payments;
                  const invoiceStatus = 'Facturado';
                  final invoiceNumber = invoice.correlativeNumber;
                  final invoiceTotal = invoice.totalAmount;
                  final invoiceDocumentID = invoice.invoiceDocumentID;

                  // print(invoice);
                  return InvoiceCard(
                    invoiceClient: invoiceClient,
                    invoiceOrder: invoiceOrder,
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
    );
  }
}
