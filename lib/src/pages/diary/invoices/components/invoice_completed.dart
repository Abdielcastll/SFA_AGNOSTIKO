// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/account_balance_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/invoices/components/invoice_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class InvoicesCompleted extends StatefulWidget {
  const InvoicesCompleted({Key? key}) : super(key: key);

  @override
  State<InvoicesCompleted> createState() => _InvoicesCompletedState();
}

class _InvoicesCompletedState extends State<InvoicesCompleted> {
  bool isDescending = false;
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var dateFormatter = DateFormat('dd-MM-yyyy');
    final invoices = Provider.of<List<Invoices>?>(context) ?? [];
    final invoicesList =
        invoices.where((element) => element.isPaid == true).toList();
    final currentDay =
        Provider.of<CounterLimitFirestore>(context).currentDayInvoice;
    final currentDateTime = currentDay!.toDate();
    String formattedDate = dateFormatter.format(currentDateTime);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10, 0),
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
                            color: myTheme.colorScheme.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
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
                      color: myTheme.colorScheme.secondary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
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
                            lastDate: DateTime(2500),
                          );
                          if (newDate == null) {
                            return;
                          }
                          setState(() {
                            today = newDate;
                            formattedDate = dateFormatter.format(newDate);
                            final newDay = Timestamp.fromDate(newDate);
                            currentDayProvider.setNewDayInvoice(newDay);
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
                      margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      width: 40,
                      child: IconButton(
                        onPressed: () {
                          final currentDayProvider =
                              Provider.of<CounterLimitFirestore>(context,
                                  listen: false);
                          setState(() {
                            currentDayProvider
                                .setNewDayInvoice(Timestamp.fromDate(DateTime(
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
                          MaterialCommunityIcons.calendar_remove,
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
        invoicesList.isNotEmpty
            ? SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.52,
                  child: Scrollbar(
                    child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      itemCount: invoicesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final sortedInvoices = isDescending
                            ? invoicesList.reversed.toList()
                            : invoicesList;
                        final invoice = sortedInvoices[index];
                        final invoiceClient = invoice.clientIdReference;
                        final invoiceOrder = invoice.orderDate;
                        final unformattedDate = invoice.orderDate ??
                            Timestamp.fromDate(DateTime.now());
                        final date =
                            DateTime.parse(unformattedDate.toDate().toString());
                        final invoiceDate = dateFormatter.format(date);
                        final invoiceBalance = invoice.totalAmount;
                        final invoicePayments = invoice.payments;
                        final invoiceStatus =
                            AppLocalizations.of(context)!.invoiced;
                        final invoiceNumber = invoice.correlativeNumber;
                        final invoiceTotal = invoice.totalAmount;
                        final invoiceDocumentID = invoice.invoiceDocumentID;

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
                          invoiceSubtotal: invoice.subTotalAmount,
                          invoicePercetageTax: invoice.taxPercentage,
                          invoiceTax: invoice.taxAmount,
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
                          MaterialCommunityIcons.archive_check_outline,
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
    );
  }
}
