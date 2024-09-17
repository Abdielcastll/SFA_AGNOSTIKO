// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/account_balance_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/invoices/components/invoice_card.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InvoicesOnProcess extends StatefulWidget {
  const InvoicesOnProcess({Key? key, required this.isDescending})
      : super(key: key);

  final bool isDescending;

  @override
  State<InvoicesOnProcess> createState() => _InvoicesOnProcessState();
}

class _InvoicesOnProcessState extends State<InvoicesOnProcess> {
  var dateFormatter = DateFormat('dd/MM/yyyy');
  DateTime today = DateTime.now();

  bool isDescending = false;

  @override
  Widget build(BuildContext context) {
    final invoices = Provider.of<List<Invoices>?>(context) ?? [];
    final invoicesList =
        invoices.where((element) => element.isPaid == false).toList();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          invoicesList.isNotEmpty
              ? SingleChildScrollView(
                  child: Container(
                    // color: Colors.red,
                    // height: MediaQuery.of(context).size.height * 0.52,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: invoicesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final sortedInvoices = isDescending
                            ? invoicesList.reversed.toList()
                            : invoicesList;
                        final invoice = sortedInvoices[index];
                        final invoiceClient = invoice.clientIdReference;
                        final unformattedDate = invoice.orderDate ??
                            Timestamp.fromDate(DateTime.now());
                        final date = DateTime.tryParse(
                            unformattedDate.toDate().toString());

                        final invoiceDate =
                            dateFormatter.format(date ?? DateTime.now());
                        final invoiceBalance = invoice.totalAmount;
                        final invoicePayments = invoice.payments;
                        final invoiceStatus =
                            AppLocalizations.of(context)!.onProcess;
                        final invoiceNumber = invoice.correlativeNumber;
                        final invoiceTotal = invoice.totalAmount;
                        final invoiceDocumentID = invoice.invoiceDocumentID;
                        final invoiceExchangeRate = invoice.invoiceExchangeRate;
                        print('invoiceExchangeRate: $invoiceExchangeRate');
                        return InvoiceCard(
                          invoiceClient: invoiceClient,
                          invoiceDate: invoiceDate,
                          invoiceBalance: invoiceBalance,
                          invoiceStatus: invoiceStatus,
                          invoicePayments: invoicePayments,
                          invoiceNumber: invoiceNumber,
                          invoiceTotal: invoiceTotal,
                          invoiceDocumentID: invoiceDocumentID,
                          invoiceSubtotal: invoice.subTotalAmount,
                          invoicePercetageTax: invoice.taxPercentage,
                          invoiceTax: invoice.taxAmount,
                          discountPercentage: invoice.masterDiscountPercentage,
                          discount: invoice.masterDiscountAmount,
                          invoiceExchangeRatefromDB: invoiceExchangeRate,
                        );
                      },
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
                                themeProvider.myTheme.colorScheme.primary
                                    .withOpacity(0.3)),
                        width: 120,
                        height: 120,
                        child: Opacity(
                          opacity: 0.8,
                          child: Icon(
                            MaterialCommunityIcons.archive_check_outline,
                            color: themeProvider
                                .myTheme.colorScheme.onPrimaryContainer,
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
                              'No hay pagos registrados este día',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 16,
                                color: themeProvider
                                    .myTheme.colorScheme.onPrimaryContainer,
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
