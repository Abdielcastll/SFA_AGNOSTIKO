// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/account_balance_model.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountBalancePage extends StatefulWidget {
  const AccountBalancePage({
    super.key,
    this.clientDocument,
    this.clientName,
  });

  final clientDocument;
  final clientName;

  @override
  State<AccountBalancePage> createState() => _AccountBalancePageState();
}

class _AccountBalancePageState extends State<AccountBalancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBarNavigation(
        message: AppLocalizations.of(context)!.accountBalance,
        isOrderActive: false,
      ),
      body: AccountBalanceBody(
          clientDocument: widget.clientDocument, clientName: widget.clientName),
    );
  }
}

class AccountBalanceBody extends StatefulWidget {
  AccountBalanceBody({
    Key? key,
    this.clientDocument,
    this.clientName,
  }) : super(key: key);

  final clientDocument;
  final clientName;

  @override
  State<AccountBalanceBody> createState() => _AccountBalanceBodyState();
}

class _AccountBalanceBodyState extends State<AccountBalanceBody> {
  bool isCheckedNotes = false;
  bool isCheckedFactures = true;
  bool isCheckedOnProcess = false;

  @override
  Widget build(BuildContext context) {
    // print(widget.clientDocument);
    return MultiProvider(
      providers: [
        isCheckedFactures == true
            ? StreamProvider<List<Invoices>?>.value(
                value: FirebaseFirestore.instance
                    .collection('clientes')
                    .doc(widget.clientDocument.toString())
                    .collection('facturas')
                    .orderBy('nroCorrelativo', descending: false)
                    .snapshots()
                    .map(accountInvoicesFromSnapshot),
                initialData: const [],
                catchError: (context, error) {
                  // print(error);
                  return;
                },
              )
            : StreamProvider<List<CreditNotes>?>.value(
                value: FirebaseFirestore.instance
                    .collection('clientes')
                    .doc(widget.clientDocument.toString())
                    .collection('notas_credito')
                    .orderBy('nroCorrelativo', descending: false)
                    .snapshots()
                    .map(accountCreditNotesFromSnapshot),
                initialData: const [],
                catchError: (context, error) {
                  // print(error);
                  return;
                },
              )
      ],
      child: SingleChildScrollView(
        child: Column(
          children: [
            StatusBarResume(isCheckedFactures: isCheckedFactures),
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
                    AppLocalizations.of(context)!.issues,
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
                    AppLocalizations.of(context)!.notes,
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
                    AppLocalizations.of(context)!.invoices,
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            isCheckedFactures == true
                ? ShowInvoices(
                    isCheckedOnProcess: isCheckedOnProcess,
                    clientName: widget.clientName,
                  )
                : ShowCreditNotes(
                    isCheckedOnProcess: isCheckedOnProcess,
                    clientName: widget.clientName,
                  ),
          ],
        ),
      ),
    );
  }
}

class StatusBarResume extends StatefulWidget {
  const StatusBarResume({
    Key? key,
    this.isCheckedFactures,
  }) : super(key: key);

  final isCheckedFactures;

  @override
  State<StatusBarResume> createState() => _StatusBarResumeState();
}

class _StatusBarResumeState extends State<StatusBarResume> {
  final String? currentCoin =
      sharedPreferences!.getString('currentCoin') ?? 'Dolares - USD';

  priceFormat(productPrice) {
    if (currentCoin!.contains('USD') || currentCoin == null) {
      return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
          .format(productPrice)
          .toString();
    } else if (currentCoin!.contains('VED')) {
      return NumberFormat.currency(
        locale: 'es_VE',
        decimalDigits: 2,
        symbol: "Bs.",
      ).format(productPrice * 4.58).toString();
    } else if (currentCoin!.contains('EUR')) {
      return NumberFormat.currency(
        locale: 'es_ES',
        decimalDigits: 2,
        symbol: '€',
        customPattern: '\u00a4 #,##.#',
      ).format(productPrice * 0.89).toString();
    } else if (currentCoin!.contains('MXN')) {
      return NumberFormat.currency(
        locale: 'es_MX',
        decimalDigits: 2,
        symbol: '\$',
        customPattern: '\u00a4 #,##.#',
      ).format(productPrice * 0.89);
    } else if (currentCoin!.contains('BTC')) {
      return '฿ ${(productPrice * 0.00011).toString()}';
    } else {
      return NumberFormat.currency(
        locale: 'es_VE',
        decimalDigits: 2,
        symbol: "PPR.",
      ).format(productPrice * 4.58).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoices = Provider.of<List<Invoices>?>(context) ?? [];
    final creditNotes = Provider.of<List<CreditNotes>?>(context) ?? [];
    final listOnProcess = widget.isCheckedFactures == true
        ? invoices.where((element) => element.isPaid == false).toList()
        : creditNotes
            .where((element) =>
                element.paymentsData['conciliado'] == false &&
                element.paymentsData['anulado'] == false)
            .toList();
    final listOfCompleted = widget.isCheckedFactures == true
        ? invoices.where((element) => element.isPaid == true).toList()
        : creditNotes
            .where((element) =>
                element.paymentsData['conciliado'] == true &&
                element.paymentsData['anulado'] == false)
            .toList();
    double totalAmount = 0.0;
    if (widget.isCheckedFactures == true && invoices.isNotEmpty) {
      for (int i = 0; i < invoices.length; i++) {
        totalAmount += (invoices[i].totalAmount).toDouble();
      }
    } else if (widget.isCheckedFactures == false && creditNotes.isNotEmpty) {
      for (int i = 0; i < creditNotes.length; i++) {
        totalAmount +=
            (creditNotes[i].paymentsData['montoOriginal']).toDouble() ?? 0;
      }
    }

    // print(totalAmount);
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text(
                AppLocalizations.of(context)!.issues,
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
                  listOnProcess.length.toString(),
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
                AppLocalizations.of(context)!.paidUp,
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
                  listOfCompleted.length.toString(),
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
                AppLocalizations.of(context)!.accountTotalAmount,
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
                  '${priceFormat(totalAmount)}',
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
                AppLocalizations.of(context)!.accountTotalBalance,
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
                  priceFormat(0),
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
    this.isCheckedOnProcess,
    this.clientName,
  }) : super(key: key);

  final isCheckedOnProcess;
  final clientName;

  @override
  State<ShowInvoices> createState() => _ShowInvoicesState();
}

class _ShowInvoicesState extends State<ShowInvoices> {
  leadingIcon(isConcilied) {
    if (isConcilied == true) {
      return Icon(
        Icons.money_off_csred_outlined,
        color: Colors.green,
      );
    } else if (isConcilied == false) {
      return Icon(
        Icons.money_off_csred_outlined,
        color: Colors.amber,
      );
    }
  }

  final String? currentCoin =
      sharedPreferences!.getString('currentCoin') ?? 'Dolares - USD';

  priceFormat(productPrice) {
    if (currentCoin!.contains('USD') || currentCoin == null) {
      return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
          .format(productPrice)
          .toString();
    } else if (currentCoin!.contains('VED')) {
      return NumberFormat.currency(
        locale: 'es_VE',
        decimalDigits: 2,
        symbol: "Bs.",
      ).format(productPrice * 4.58).toString();
    } else if (currentCoin!.contains('EUR')) {
      return NumberFormat.currency(
        locale: 'es_ES',
        decimalDigits: 2,
        symbol: '€',
        customPattern: '\u00a4 #,##.#',
      ).format(productPrice * 0.89).toString();
    } else if (currentCoin!.contains('MXN')) {
      return NumberFormat.currency(
        locale: 'es_MX',
        decimalDigits: 2,
        symbol: '\$',
        customPattern: '\u00a4 #,##.#',
      ).format(productPrice * 0.89);
    } else if (currentCoin!.contains('BTC')) {
      return '฿ ${(productPrice * 0.00011).toString()}';
    } else {
      return NumberFormat.currency(
        locale: 'es_VE',
        decimalDigits: 2,
        symbol: "PPR.",
      ).format(productPrice * 4.58).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoices = Provider.of<List<Invoices>?>(context) ?? [];
    final invoicesList = invoices;
    var invoicesOnProcessList =
        invoices.where((element) => element.isPaid == false).toList();
    var dateFormatter = DateFormat('yyyy-MM-dd');
    // print(invoices);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: widget.isCheckedOnProcess == true
            ? invoicesOnProcessList.length
            : invoicesList.length,
        itemBuilder: (context, index) {
          final note = widget.isCheckedOnProcess == true
              ? invoicesOnProcessList[index]
              : invoicesList[index];
          final noteNumber = note.correlativeNumber ?? 'NaN';
          final unFormattedDate =
              note.orderDate ?? Timestamp.fromDate(DateTime.now());
          final date = DateTime.parse(unFormattedDate.toDate().toString());
          final noteDate = dateFormatter.format(date);
          final noteOriginalAmount = note.totalAmount ?? 0;
          final noteBalance = 00;

          return ListTile(
            leading: leadingIcon(note.isPaid),
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
              'Monto original: ${priceFormat(noteOriginalAmount)} - Saldo: ${priceFormat(noteBalance)}',
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

class ShowCreditNotes extends StatefulWidget {
  const ShowCreditNotes({
    Key? key,
    this.isCheckedOnProcess,
    this.clientName,
  }) : super(key: key);

  final isCheckedOnProcess;
  final clientName;

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

  final String? currentCoin =
      sharedPreferences!.getString('currentCoin') ?? 'Dolares - USD';

  priceFormat(productPrice) {
    if (currentCoin!.contains('USD') || currentCoin == null) {
      return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
          .format(productPrice)
          .toString();
    } else if (currentCoin!.contains('VED')) {
      return NumberFormat.currency(
        locale: 'es_VE',
        decimalDigits: 2,
        symbol: "Bs.",
      ).format(productPrice * 4.58).toString();
    } else if (currentCoin!.contains('EUR')) {
      return NumberFormat.currency(
        locale: 'es_ES',
        decimalDigits: 2,
        symbol: '€',
        customPattern: '\u00a4 #,##.#',
      ).format(productPrice * 0.89).toString();
    } else if (currentCoin!.contains('MXN')) {
      return NumberFormat.currency(
        locale: 'es_MX',
        decimalDigits: 2,
        symbol: '\$',
        customPattern: '\u00a4 #,##.#',
      ).format(productPrice * 0.89);
    } else if (currentCoin!.contains('BTC')) {
      return '฿ ${(productPrice * 0.00011).toString()}';
    } else {
      return NumberFormat.currency(
        locale: 'es_VE',
        decimalDigits: 2,
        symbol: "PPR.",
      ).format(productPrice * 4.58).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final creditNotes = Provider.of<List<CreditNotes>?>(context) ?? [];
    final creditNotesList = creditNotes;
    var creditOnProcessList = creditNotes
        .where((element) =>
            element.paymentsData['conciliado'] == false &&
            element.paymentsData['anulado'] == false)
        .toList();
    // print(creditNotes);
    var dateFormatter = DateFormat('yyyy-MM-dd');

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: widget.isCheckedOnProcess == true
            ? creditOnProcessList.length
            : creditNotesList.length,
        itemBuilder: (context, index) {
          final note = widget.isCheckedOnProcess == true
              ? creditOnProcessList[index]
              : creditNotesList[index];
          final noteNumber = note.correlativeNumber ?? 'NaN';
          final unFormattedDate =
              note.date ?? Timestamp.fromDate(DateTime.now());
          final date = DateTime.parse(unFormattedDate.toDate().toString());
          final noteDate = dateFormatter.format(date);
          final noteOriginalAmount = note.totalAmount ?? 0;
          final noteBalance = note.paymentsData['monto'] ?? 0;
          final noteNuled = note.paymentsData['anulado'] ?? 'NaN';
          final noteConciled = note.paymentsData['conciliado'] ?? 'NaN';
          final balanceNC = noteBalance + noteOriginalAmount;
          // print(noteDate);
          // print(note);
          return ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    child: StatefulBuilder(
                      builder: ((context, setState) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(
                            'Nota de Credito #$noteNumber',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.secondary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Text(
                                  'Cliente',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    color: Colors.grey,
                                    fontSize: 14,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  width: 350,
                                  height: 40,
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(10, 15, 0, 10),
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: myTheme.colorScheme.primary
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                  child: Text(
                                    widget.clientName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 14,
                                      color: myTheme.colorScheme.primary
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                Text(
                                  'Fecha',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    color: Colors.grey,
                                    fontSize: 14,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  width: 350,
                                  height: 40,
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(10, 15, 0, 10),
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: myTheme.colorScheme.primary
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        noteDate,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          fontSize: 14,
                                          color: myTheme.colorScheme.primary
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                      Icon(
                                        Icons.calendar_month,
                                        color: myTheme.colorScheme.primary
                                            .withOpacity(0.5),
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Monto: ${priceFormat(noteOriginalAmount)}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Usado: ${priceFormat(noteBalance)}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Saldo NC: ${priceFormat(balanceNC)}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Regresar',
                                      style: TextStyle(
                                        fontFamily: 'Poppins-regular',
                                        color: myTheme.colorScheme.primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                },
              );
            }, // AlertDialogPara mostrar informacion del invoice

            leading: leadingIcon(noteNuled, noteConciled),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nota de credito #$noteNumber',
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
              'Monto original: \$ ${priceFormat(noteOriginalAmount)} - Saldo: \$ ${priceFormat(noteBalance)}',
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
