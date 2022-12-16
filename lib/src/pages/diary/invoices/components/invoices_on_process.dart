// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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
  bool isDescending = false;

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
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: invoicesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final sortedInvoices = isDescending
                        ? invoicesList.reversed.toList()
                        : invoicesList;
                    final invoice = sortedInvoices[index];
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
