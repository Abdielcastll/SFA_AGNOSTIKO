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

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({Key? key}) : super(key: key);

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  bool isCheckedNotes = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        isCheckedNotes == false
            ? StreamProvider<List<Invoices>?>.value(
                value: FirebaseFirestore.instance
                    .collectionGroup('facturas')
                    .orderBy('nroCorrelativo', descending: true)
                    .snapshots()
                    .map(accountInvoicesFromSnapshot),
                initialData: const [],
                catchError: (context, error) {
                  print(error);
                  return;
                },
              )
            : StreamProvider<List<CreditNotes>?>.value(
                value: FirebaseFirestore.instance
                    .collectionGroup('notas_credito')
                    .snapshots()
                    .map(accountCreditNotesFromSnapshot),
                initialData: const [],
                catchError: (context, error) {
                  print(error);
                  return;
                },
              )
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[100],
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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
          widget.isNotesChecked == false
              ? InvoicesOnProcess()
              : CreditNotesOnProcess(),
          widget.isNotesChecked == false ? InvoicesList() : Container(),
          // InvoicesList(),
        ],
      ),
    );
  }
}
