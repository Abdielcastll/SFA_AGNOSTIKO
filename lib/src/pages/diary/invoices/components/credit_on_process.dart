// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/account_balance_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/invoices/components/creditnote_card.dart';

class CreditNotesOnProcess extends StatefulWidget {
  const CreditNotesOnProcess({Key? key}) : super(key: key);

  @override
  State<CreditNotesOnProcess> createState() => _CreditNotesOnProcessState();
}

class _CreditNotesOnProcessState extends State<CreditNotesOnProcess> {
  var dateFormatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    final creditNotes = Provider.of<List<CreditNotes>?>(context) ?? [];
    final creditNotesList = creditNotes
        .where((element) =>
            element.isValid == false && element.isEliminated == false)
        .toList();
    // print(creditNotes);
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
                  itemCount: creditNotesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final creditNote = creditNotesList[index];
                    final creditClient = creditNote.clientIdReference;
                    final creditOrder = creditNote.correlativeNumber;
                    final unformattedDate =
                        creditNote.date ?? Timestamp.fromDate(DateTime.now());
                    final date =
                        DateTime.parse(unformattedDate.toDate().toString());
                    final creditDate = dateFormatter.format(date);
                    final creditBalance = creditNote.totalAmount;
                    final creditPayments = creditNote.payments;
                    final creditNoteIsValid = creditNote.isValid;
                    final creditNoteIsEliminated = creditNote.isEliminated;
                    final creditNumber = creditNote.correlativeNumber;
                    final creditTotal = creditNote.totalAmount;
                    // print(invoice);
                    return CreditNoteCard(
                      creditNoteClient: creditClient,
                      creditNoteOrder: creditOrder,
                      creditNoteDate: creditDate,
                      creditNoteBalance: creditBalance,
                      creditNoteIsValid: creditNoteIsValid,
                      creditNoteIsEliminated: creditNoteIsEliminated,
                      creditNotePayments: creditPayments,
                      creditNoteNumber: creditNumber,
                      creditNoteTotal: creditTotal,
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
