// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/account_balance_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/account_balance/invoice_details/invoice_details.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';

class AccountBalancePage extends StatefulWidget {
  const AccountBalancePage({
    super.key,
    this.clientDocument,
    this.clientName,
    this.userZoneDocument,
  });

  final clientDocument;
  final clientName;
  final userZoneDocument;

  @override
  State<AccountBalancePage> createState() => _AccountBalancePageState();
}

class _AccountBalancePageState extends State<AccountBalancePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    List<String> currentCoinSplit = currentCoin!.split(' ');
    String currentCoinSelectedCode = currentCoinSplit.last;
    return MultiProvider(
      providers: [
        StreamProvider<Coin?>.value(
          initialData: Coin(),
          catchError: (context, error) {
            print(
                'ERROR ON STREAM PROVIDER OF COINEXCHANGE RATES IN ACCOUNT BALANCE - TICKETS');
            print(error);
            return;
          },
          value: coinCollection
              .doc(currentCoinSelectedCode)
              .snapshots()
              .map(coinFromSnapshot),
        ),
      ],
      child: Scaffold(
        backgroundColor: themeProvider.myTheme.colorScheme.background,
        body: AccountBalanceBody(
          clientDocument: widget.clientDocument,
          clientName: widget.clientName,
        ),
      ),
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
  bool light = false;
  List? invoicesAllPaymentAmounts = [];
  List? invoicesPayedUp = [];
  int? invoicesUpToPay = 0;
  int? payedUpInvoicesLength = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scrollLimit =
        Provider.of<CounterLimitFirestore>(context).getScrollBalance;
    final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 2;
    final coinExchangeRatio = Provider.of<Coin?>(context)?.exchangeRatio ?? 1;
    final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '';
    final userUID = Provider.of<UserModel?>(context);

    var totalAmountConverted = priceMultipliedByItsExchangeRatio2(
      productPrice: 0,
      coinDecimals: coinDecimals,
      coinExchangeRatio: coinExchangeRatio,
    );

    var totalAmountFormatted =
        formatDecimalPriceByRegion(price: totalAmountConverted);

    var balanceConverted = priceMultipliedByItsExchangeRatio2(
      productPrice: 0,
      coinDecimals: coinDecimals,
      coinExchangeRatio: coinExchangeRatio,
    );

    var balanceFormatted = formatDecimalPriceByRegion(price: balanceConverted);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return MultiProvider(
      providers: [
        StreamProvider<List<Invoices>?>.value(
          value: clientesRef
              .doc(widget.clientDocument.toString())
              .collection('facturas')
              .where('vendedor', isEqualTo: usersCollection.doc(userUID?.uid))
              .orderBy('nroCorrelativo', descending: true)
              .limit(scrollLimit)
              .snapshots()
              .map(accountInvoicesFromSnapshot),
          initialData: const [],
          catchError: (context, error) {
            return;
          },
        )
      ],
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 12, 16, 0),
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width,
                    height: 65,
                    decoration: BoxDecoration(
                      // color: Colors.green.shade100,
                      color: Color(0xFF33C926).withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Total pagado',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            fontFamily: 'Poppins-Medium',
                            color: Color(0xFF33C926),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '$coinSymbol $totalAmountFormatted',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins-Regular',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.29,
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                        height: 65,
                        decoration: BoxDecoration(
                          // color: Colors.green.shade100,
                          color: Color(0xFFC97426).withOpacity(0.1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Pagadas',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'Poppins-Medium',
                                color: Color(0xFFC97426),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              // '0',
                              '$payedUpInvoicesLength',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins-Regular',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.654,
                        padding: EdgeInsets.fromLTRB(0, 12, 16, 0),
                        alignment: Alignment.centerRight,
                        height: 65,
                        decoration: BoxDecoration(
                          // color: Colors.green.shade100,
                          color: Color(0xFF2667C9).withOpacity(0.1),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Saldo restante',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'Poppins-Medium',
                                color: Color(0xFF2667C9),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '$coinSymbol $balanceFormatted',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins-Regular',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Ver pendientes',
                    style: TextStyle(
                      fontFamily: 'Poppins-Medium',
                      fontSize: 12,
                      color: themeProvider.myTheme.colorScheme.secondary,
                    ),
                  ),
                  SizedBox(width: 10),
                  FlutterSwitch(
                    onToggle: (val) {
                      setState(() {
                        light = val;
                        isCheckedOnProcess = !isCheckedOnProcess;
                      });
                    },
                    width: 39,
                    height: 24,
                    toggleSize: 12,
                    value: light,
                    borderRadius: 26,
                    padding: 6,
                    activeColor: Colors.green.shade300,
                    inactiveColor: Color(0xFFDFE0FF),
                    inactiveToggleColor: Color(0xFF5A5D77),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
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

class ShowInvoices extends StatefulWidget {
  ShowInvoices({
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
      return const Icon(
        Icons.money_off_csred_outlined,
        color: Colors.green,
      );
    } else if (isConcilied == false) {
      return const Icon(
        Icons.money_off_csred_outlined,
        color: Colors.amber,
      );
    }
  }

  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final productsLimitProvider =
          Provider.of<CounterLimitFirestore>(context, listen: false);
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
          // int newValor =
          // int.parse(productsLimitProvider.getScrollBalanceLimit.toString());
          print('Top balance page');
          // productsLimitProvider.setBalanceLimit(10, 10);
        } else {
          if (productsLimitProvider.getScrollBalanceLimit == 0) {
            productsLimitProvider.setBalanceLimit(0, 0);
          } else {
            int newValor = int.parse(
                productsLimitProvider.getScrollBalanceLimit.toString());
            if (newValor == 10) {
              productsLimitProvider.setBalanceLimit(
                  productsLimitProvider.getScrollBalance + newValor, 10);
            } else if (newValor == 50) {
              productsLimitProvider.setProductsLimit(
                  productsLimitProvider.getScrollBalance + newValor, 50);
            }
          }
          print('Bottom balance page');
          Fluttertoast.showToast(
            msg: 'Solicitando +10 facturas',
            backgroundColor: themeProvider.myTheme.colorScheme.primary,
            textColor: Colors.white,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 2;
    final coinExchangeRatio = Provider.of<Coin?>(context)?.exchangeRatio ?? 1;
    final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '';
    final invoices = Provider.of<List<Invoices>?>(context) ?? [];
    final invoicesList = invoices;
    var invoicesOnProcessList =
        invoices.where((element) => element.isPaid == false).toList();
    var dateFormatter = DateFormat('yyyy/MM/dd');

    return Container(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height * 0.51,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            controller: _controller,
            physics: const BouncingScrollPhysics(),
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

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  onTap: () {
                    print('Ticket #$noteNumber');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => InvoiceDetails(
                          number: note.correlativeNumber.toString(),
                          totalOfTheOrder: note.totalAmount,
                          coinDecimals: coinDecimals,
                          coinExchangeRatio:
                              double.parse(coinExchangeRatio.toString()),
                          coinSymbol: coinSymbol,
                          clientID: note.clientIdReference.toString(),
                          isPaid: note.isPaid,
                          orderID: note.orderIdReference.toString(),
                        ),
                      ),
                    );
                  },
                  tileColor: Colors.white,
                  leading: leadingIcon(note.isPaid),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ticket #$noteNumber',
                        style: const TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        noteDate,
                        style: const TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Monto original: ",
                            style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            // '$coinSymbol ${priceMultipliedByItsExchangeRatio(
                            //   productPrice: noteOriginalAmount,
                            //   coinDecimals: coinDecimals,
                            //   coinExchangeRatio: coinExchangeRatio,
                            // ).toStringAsFixed(2)}',
                            '000000',
                            style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 12,
                              color: themeProvider
                                  .myTheme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            'Saldo: ',
                            style: const TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '000000',

                            // noteBalance < 0.001
                            //     ? '0.00'
                            //     : '$coinSymbol ${priceMultipliedByItsExchangeRatio(
                            //         productPrice: noteBalance,
                            //         coinDecimals: coinDecimals,
                            //         coinExchangeRatio: coinExchangeRatio,
                            //       ).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 12,
                              color: Colors.amber.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 60),
        ],
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
      return const Icon(
        Icons.cancel_outlined,
        color: Colors.red,
      );
    } else if (isConcilied == true) {
      return const Icon(
        Icons.money_off_csred_outlined,
        color: Colors.green,
      );
    } else if (isCancelled == false && isConcilied == false) {
      return const Icon(
        Icons.money_off_csred_outlined,
        color: Colors.amber,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 2;
    final coinExchangeRatio = Provider.of<Coin?>(context)?.exchangeRatio ?? 1;
    final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '';
    final creditNotes = Provider.of<List<CreditNotes>?>(context) ?? [];
    final creditNotesList = creditNotes;
    var creditOnProcessList = creditNotes
        .where((element) =>
            element.paymentsData['conciliado'] == false &&
            element.paymentsData['anulado'] == false)
        .toList();
    var dateFormatter = DateFormat('yyyy/MM/dd');

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.51,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
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
          final themeProvider =
              Provider.of<ThemeProvider>(context, listen: false);

          return ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    child: StatefulBuilder(
                      builder: ((context, setState) {
                        return AlertDialog(
                          surfaceTintColor: Color.fromARGB(255, 222, 222, 222),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(
                            'Nota de Credito #$noteNumber',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color:
                                  themeProvider.myTheme.colorScheme.secondary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                const Text(
                                  'Cliente',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Regular',
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  width: 350,
                                  height: 40,
                                  alignment: Alignment.centerLeft,
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 15, 0, 10),
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: themeProvider
                                          .myTheme.colorScheme.primary
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                  child: Text(
                                    widget.clientName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Regular',
                                      fontSize: 14,
                                      color: themeProvider
                                          .myTheme.colorScheme.primary
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                const Text(
                                  'Fecha',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Regular',
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  width: 350,
                                  height: 40,
                                  alignment: Alignment.centerLeft,
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 15, 0, 10),
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: themeProvider
                                          .myTheme.colorScheme.primary
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
                                          fontFamily: 'Poppins-Regular',
                                          fontSize: 14,
                                          color: themeProvider
                                              .myTheme.colorScheme.primary
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                      Icon(
                                        Icons.calendar_month,
                                        color: themeProvider
                                            .myTheme.colorScheme.primary
                                            .withOpacity(0.5),
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Monto: $coinSymbol ${priceMultipliedByItsExchangeRatio(
                                    productPrice: noteOriginalAmount,
                                    coinDecimals: coinDecimals,
                                    coinExchangeRatio: coinExchangeRatio,
                                  )}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins-Regular',
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Usado: $coinSymbol ${priceMultipliedByItsExchangeRatio(
                                    productPrice: noteBalance,
                                    coinDecimals: coinDecimals,
                                    coinExchangeRatio: coinExchangeRatio,
                                  )}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins-Regular',
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Saldo NC: $coinSymbol ${priceMultipliedByItsExchangeRatio(
                                    productPrice: balanceNC,
                                    coinDecimals: coinDecimals,
                                    coinExchangeRatio: coinExchangeRatio,
                                  )}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins-Regular',
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
                                        color: themeProvider
                                            .myTheme.colorScheme.primary,
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
            },
            leading: leadingIcon(noteNuled, noteConciled),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nota de credito #$noteNumber',
                  style: const TextStyle(
                    fontFamily: 'Poppins-Regular',
                    fontSize: 14,
                  ),
                ),
                Text(
                  noteDate,
                  style: const TextStyle(
                    fontFamily: 'Poppins-Regular',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              'Monto original: $coinSymbol ${priceMultipliedByItsExchangeRatio(
                productPrice: noteOriginalAmount,
                coinDecimals: coinDecimals,
                coinExchangeRatio: coinExchangeRatio,
              )} - Saldo:  $coinSymbol ${priceMultipliedByItsExchangeRatio(
                productPrice: noteBalance,
                coinDecimals: coinDecimals,
                coinExchangeRatio: coinExchangeRatio,
              )}',
              style: const TextStyle(
                fontFamily: 'Poppins-Regular',
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
