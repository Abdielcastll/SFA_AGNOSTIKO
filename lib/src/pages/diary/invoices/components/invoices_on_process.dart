// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/account_balance_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/invoices/components/invoice_card.dart';
import 'package:pwa_sales2go_flutter/src/widgets/loading/loading_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 16, bottom: 10),
                child: Text(
                  textAlign: TextAlign.start,
                  AppLocalizations.of(context)!.onProcess,
                  style: TextStyle(
                    color: Colors.amber.shade600,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins-regular',
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: 230,
              child: Scrollbar(
                child: ListView.builder(
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
                    final invoiceStatus =
                        AppLocalizations.of(context)!.onProcess;
                    final invoiceNumber = invoice.correlativeNumber;
                    final invoiceTotal = invoice.totalAmount;
                    final invoiceDocumentID = invoice.invoiceDocumentID;

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
