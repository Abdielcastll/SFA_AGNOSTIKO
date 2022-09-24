// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/account_balance_model.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';

class AccountBalancePage extends StatefulWidget {
  const AccountBalancePage({
    super.key,
    this.clientDocument,
  });

  final clientDocument;

  @override
  State<AccountBalancePage> createState() => _AccountBalancePageState();
}

class _AccountBalancePageState extends State<AccountBalancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBarNavigation(message: 'Estado de cuenta'),
      body: AccountBalanceBody(clientDocument: widget.clientDocument),
    );
  }
}

class AccountBalanceBody extends StatefulWidget {
  AccountBalanceBody({
    Key? key,
    this.clientDocument,
  }) : super(key: key);
  final clientDocument;

  @override
  State<AccountBalanceBody> createState() => _AccountBalanceBodyState();
}

class _AccountBalanceBodyState extends State<AccountBalanceBody> {
  bool isCheckedNotes = false;
  bool isCheckedFactures = true;
  bool isCheckedOnProcess = false;

  @override
  Widget build(BuildContext context) {
    print(widget.clientDocument);
    return MultiProvider(
      providers: [
        isCheckedFactures == true
            ? StreamProvider<List<AccountBalanceInvoices>?>.value(
                value: FirebaseFirestore.instance
                    .collection('clientes')
                    .doc(widget.clientDocument.toString())
                    .collection('facturas')
                    .orderBy('nroCorrelativo', descending: false)
                    .snapshots()
                    .map(accountInvoicesFromSnapshot),
                initialData: const [],
                catchError: (context, error) {
                  print(error);
                  return;
                },
              )
            : StreamProvider<List<AccountBalanceCreditNotes>?>.value(
                value: FirebaseFirestore.instance
                    .collection('clientes')
                    .doc(widget.clientDocument.toString())
                    .collection('notas_credito')
                    .orderBy('nroCorrelativo', descending: false)
                    .snapshots()
                    .map(accountCreditNotesFromSnapshot),
                initialData: const [],
                catchError: (context, error) {
                  print(error);
                  return;
                },
              )
      ],
      child: SingleChildScrollView(
        child: Column(
          children: [
            StatusBarResume(),
            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
              child: Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    value: isCheckedOnProcess,
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckedOnProcess = value!;
                      });
                    },
                  ),
                  Text(
                    'Pendientes',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                    ),
                  ),
                  Checkbox(
                    checkColor: Colors.white,
                    value: isCheckedNotes,
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckedNotes = value!;
                        if (isCheckedNotes = true) {
                          isCheckedFactures = false;
                          isCheckedOnProcess = false;
                        }
                      });
                    },
                  ),
                  Text(
                    'Notas',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                    ),
                  ),
                  Checkbox(
                    checkColor: Colors.white,
                    value: isCheckedFactures,
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckedFactures = value!;
                        if (isCheckedFactures = true) {
                          isCheckedNotes = false;
                          isCheckedOnProcess = false;
                        }
                      });
                    },
                  ),
                  Text(
                    'Facturas',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            isCheckedFactures == true ? ShowInvoices() : ShowCreditNotes(),
          ],
        ),
      ),
    );
  }
}

class StatusBarResume extends StatefulWidget {
  const StatusBarResume({
    Key? key,
  }) : super(key: key);

  @override
  State<StatusBarResume> createState() => _StatusBarResumeState();
}

class _StatusBarResumeState extends State<StatusBarResume> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text(
                'F. Pendientes',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  '0',
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text(
                'F. Pagadas',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  '0',
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text(
                'Monto Total',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  '0',
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text(
                'Saldo Total',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  '0',
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShowInvoices extends StatefulWidget {
  const ShowInvoices({
    Key? key,
  }) : super(key: key);

  @override
  State<ShowInvoices> createState() => _ShowInvoicesState();
}

class _ShowInvoicesState extends State<ShowInvoices> {
  @override
  Widget build(BuildContext context) {
    final invoices = Provider.of<List<AccountBalanceInvoices>?>(context) ?? [];
    // print(invoices);
    final invoicesList = invoices;
    return Center(
      child: Text('Facturas'),
    );
  }
}

class ShowCreditNotes extends StatefulWidget {
  const ShowCreditNotes({
    Key? key,
  }) : super(key: key);

  @override
  State<ShowCreditNotes> createState() => _ShowCreditNotesState();
}

class _ShowCreditNotesState extends State<ShowCreditNotes> {
  leadingIcon(isCancelled, isConcilied) {
    if (isCancelled == true) {
      return Icon(
        Icons.cancel_outlined,
        color: Colors.red,
      );
    } else if (isConcilied == true) {
      return Icon(
        Icons.money_off_csred_outlined,
        color: Colors.green,
      );
    } else if (isCancelled == false && isConcilied == false) {
      return Icon(
        Icons.money_off_csred_outlined,
        color: Colors.amber,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final creditNotes =
        Provider.of<List<AccountBalanceCreditNotes>?>(context) ?? [];
    final creditNotesList = creditNotes;
    // print(creditNotes);
    var dateFormatter = DateFormat('yyyy-MM-dd');

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: creditNotesList.length,
        itemBuilder: (context, index) {
          final note = creditNotesList[index];
          final noteNumber = note.correlativeNumber ?? 'NaN';
          final date = DateTime.parse(note.date.toDate().toString());
          final noteDate = dateFormatter.format(date);
          final noteOriginalAmount = note.totalAmount ?? 'NaN';
          final noteBalance = note.paymentsData['monto'] ?? 'NaN';
          final noteNuled = note.paymentsData['anulado'] ?? 'NaN';
          final noteConciled = note.paymentsData['conciliado'] ?? 'NaN';
          // print(noteDate);
          return ListTile(
            leading: leadingIcon(noteNuled, noteConciled),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Factura #$noteNumber',
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 14,
                  ),
                ),
                Text(
                  noteDate,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              'Monto original: \$ $noteOriginalAmount - Saldo: \$ $noteBalance',
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}


// Container(
          //   margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
          //   // ignore: prefer_const_literals_to_create_immutables
          //   child: Column(
          //     // ignore: prefer_const_literals_to_create_immutables
          //     children: [
          //       ListTile(
          //         leading: Icon(
          //           Icons.money_off_csred_outlined,
          //           color: Colors.green,
          //         ),
          //         title: Text(
          //           'Factura #00',
          //           style: TextStyle(
          //             fontFamily: 'Poppins-regular',
          //             fontSize: 14,
          //           ),
          //         ),
          //         subtitle: Text(
          //           'Monto original: \$ 00.00 - Saldo: \$ 00.00',
          //           style: TextStyle(
          //             fontFamily: 'Poppins-regular',
          //             fontSize: 12,
          //             color: Colors.grey,
          //           ),
          //         ),
          //       ),
          //       ListTile(
          //         leading: Icon(
          //           Icons.money_off_csred_outlined,
          //           color: Colors.amber,
          //         ),
          //         title: Text(
          //           'Factura #01',
          //           style: TextStyle(
          //             fontFamily: 'Poppins-regular',
          //             fontSize: 14,
          //           ),
          //         ),
          //         subtitle: Text(
          //           'Monto original: \$ 00.00 - Saldo: \$ 00.00',
          //           style: TextStyle(
          //             fontFamily: 'Poppins-regular',
          //             fontSize: 12,
          //             color: Colors.grey,
          //           ),
          //         ),
          //       ),
          //       ListTile(
          //         leading: Icon(
          //           Icons.cancel_outlined,
          //           color: Colors.red,
          //         ),
          //         title: Text(
          //           'Factura #03',
          //           style: TextStyle(
          //             fontFamily: 'Poppins-regular',
          //             fontSize: 14,
          //           ),
          //         ),
          //         subtitle: Text(
          //           'Monto original: \$ 00.00 - Saldo: \$ 00.00',
          //           style: TextStyle(
          //             fontFamily: 'Poppins-regular',
          //             fontSize: 12,
          //             color: Colors.grey,
          //           ),
          //         ),
          //       ),
          //       ListTile(
          //         leading: Icon(
          //           Icons.money_off_csred_outlined,
          //           color: Colors.amber,
          //         ),
          //         title: Text(
          //           'Nota #01',
          //           style: TextStyle(
          //             fontFamily: 'Poppins-regular',
          //             fontSize: 14,
          //           ),
          //         ),
          //         subtitle: Text(
          //           'Monto original: \$ 00.00 - Saldo: \$ 00.00',
          //           style: TextStyle(
          //             fontFamily: 'Poppins-regular',
          //             fontSize: 12,
          //             color: Colors.grey,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),