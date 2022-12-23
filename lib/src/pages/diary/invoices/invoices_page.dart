// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/examples/example_invoices_list.dart';
import 'package:pwa_sales2go_flutter/src/models/account_balance_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/invoices/components/credit_on_process.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/invoices/components/filter_invoices.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/invoices/components/invoice_completed.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/invoices/components/invoices_on_process.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/widgets/loading/loading_widget.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({Key? key}) : super(key: key);

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  bool isCheckedNotes = false;

  @override
  Widget build(BuildContext context) {
    final currentDay =
        Provider.of<CounterLimitFirestore>(context).currentDayInvoice;
    final currentDayDateTime = currentDay.toDate();
    DateTime tomorrow = DateTime(currentDayDateTime.year,
        currentDayDateTime.month, currentDayDateTime.day + 1);
    return MultiProvider(
      providers: [
        //     // isCheckedNotes == false
        //     // ?
        StreamProvider<List<Invoices>?>.value(
          value: FirebaseFirestore.instance
              .collectionGroup('facturas')
              .where('fecha', isGreaterThanOrEqualTo: currentDay)
              .where('fecha', isLessThan: tomorrow)
              .orderBy('fecha', descending: true)
              .snapshots()
              .map(accountInvoicesFromSnapshot),
          initialData: const [],
          catchError: (context, error) {
            return;
          },
        )
        //     // : StreamProvider<List<CreditNotes>?>.value(
        //     //     value: FirebaseFirestore.instance
        //     //         .collectionGroup('notas_credito')
        //     //         .orderBy('fecha', descending: true)
        //     //         .snapshots()
        //     //         .map(accountCreditNotesFromSnapshot),
        //     //     initialData: const [],
        //     //     catchError: (context, error) {
        //     //       return;
        //     //     },
        //     //   )
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: myTheme.colorScheme.surface,
          body: InvoicesBody(isNotesChecked: isCheckedNotes),
        ),
      ),
    );
  }
}

class InvoicesBody extends StatefulWidget {
  InvoicesBody({
    Key? key,
    this.isNotesChecked,
  }) : super(key: key);

  bool? isNotesChecked;

  @override
  State<InvoicesBody> createState() => _InvoicesBodyState();
}

class _InvoicesBodyState extends State<InvoicesBody> {
  bool seeCompleted = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          // Center(
          //   child: CircularProgressIndicator(),
          // ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                // Checkbox(
                //   checkColor: Colors.white,
                //   value: widget.isNotesChecked,
                //   onChanged: (bool? value) {
                //     setState(() {
                //       widget.isNotesChecked = value!;
                //     });
                //   },
                // ),
                // Text(
                //   'Notas',
                //   style: TextStyle(
                //     fontFamily: 'Poppins-regular',
                //     fontSize: 14,
                //   ),
                // ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 120,
                margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: Text(
                  seeCompleted == true
                      ? AppLocalizations.of(context)!.completed
                      : AppLocalizations.of(context)!.onProcess,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: seeCompleted == true
                        ? Colors.green.shade600
                        : Colors.amber.shade600,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins-regular',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Text(
                  'Ver completados',
                  style: TextStyle(
                    fontSize: 15,
                    // fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins-regular',
                  ),
                ),
              ),
              Checkbox(
                activeColor: myTheme.colorScheme.primary,
                value: seeCompleted,
                onChanged: (value) {
                  setState(() {
                    seeCompleted = !seeCompleted;
                  });
                },
              ),
            ],
          ),
          // widget.isNotesChecked == false
          //     ? InvoicesOnProcess()
          //     : CreditNotesOnProcess(),
          // widget.isNotesChecked == false ? InvoicesList() : Container(),
          // InvoicesList(),
          seeCompleted == true ? InvoicesList() : InvoicesOnProcess(),
        ],
      ),
    );
  }
}
