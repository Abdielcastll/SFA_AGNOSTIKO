// ignore_for_file: prefer_const_constructors

import 'package:decimal/decimal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/widgets/dialog/register_payment_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/onTapPayment.dart';

void modalBottomSheetForInvoices({
  required bool completed,
  required BuildContext context,
  specialContribuyer,
  masterDiscount,
  fiscalAddress,
  email,
  listOfPrices,
  name,
  tlf1,
  tlf2,
  zone,
  nameId,
  typeId,
  clientDocumentReferenceID,
  invoicePayments,
  required int invoiceNumber,
  invoiceTotal,
  client,
  invoiceDocumentID,
  currentClientDispatchAdress,
  subTotal,
  percentageTax,
  required double tax,
  discountPercentage,
  discount,
  invoiceDate,
}) {
  final coinDecimals = context.read<Coin?>()?.decimals ?? 0;
  final coinExchangeRatio = context.read<Coin?>()?.exchangeRatio ?? 0;

  var dateFormatter = DateFormat('dd/MM/yyyy');
  DateTime today = DateTime.now();
  String formattedDate = dateFormatter.format(today);
  String? selectedValueA;
  String? selectedCoin = 'MXN';

  final paymentsValidPay =
      invoicePayments.where((element) => element['anulado'] == false).toList();
  final int paymentsValidPayQuantity = paymentsValidPay.length;
  final pendingPayments = invoicePayments
      .where((element) =>
          element['anulado'] == false && element['conciliado'] == false)
      .toList();
  final approvedPayments = invoicePayments
      .where((element) =>
          element['anulado'] == false && element['conciliado'] == true)
      .toList();

  print("pendingPayments: $pendingPayments");

  var sumOfPendingPayments = pendingPayments.fold(0, (i, element) {
    return i + element['monto'];
  });

  var sumOfValidPayments = paymentsValidPay.fold(0, (i, element) {
    return i + element['monto'];
  });

  var sumOfApprovedPayments = approvedPayments.fold(0, (i, element) {
    return i + element['monto'];
  });

  print('invoiceTotal: $invoiceTotal');
  print('sumOfValidPayments: $sumOfValidPayments');
  print('sumOfApprovedPayments: $sumOfApprovedPayments');

  var remaining = double.parse((Decimal.parse(invoiceTotal.toString()) -
          Decimal.parse(sumOfValidPayments.toString()))
      .toString());

  var subTotalConverted = priceMultipliedByItsExchangeRatio2(
      coinDecimals: coinDecimals,
      coinExchangeRatio: coinExchangeRatio,
      productPrice: subTotal);
  var subTotalformatted = formatDecimalPriceByRegion(price: subTotalConverted);

  var discountMasterConverted = priceMultipliedByItsExchangeRatio2(
      coinDecimals: coinDecimals,
      coinExchangeRatio: coinExchangeRatio,
      productPrice: discount ?? 0.0);
  var discountMasterformatted =
      formatDecimalPriceByRegion(price: discountMasterConverted);

  var taxConverted = priceMultipliedByItsExchangeRatio2(
      coinDecimals: coinDecimals,
      coinExchangeRatio: coinExchangeRatio,
      productPrice: tax);
  var taxformatted = formatDecimalPriceByRegion(price: taxConverted);

  var totalConverted = priceMultipliedByItsExchangeRatio2(
      coinDecimals: coinDecimals,
      coinExchangeRatio: coinExchangeRatio,
      productPrice: invoiceTotal);
  var totalformatted = formatDecimalPriceByRegion(price: totalConverted);

  showModalBottomSheet(
    elevation: 0,
    backgroundColor: Colors.white,
    barrierColor: myTheme.colorScheme.secondary.withOpacity(0.5),
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(10),
      ),
    ),
    builder: (context) {
      print(invoiceDocumentID);
      final currentCoin =
          Provider.of<CurrencyProvider>(context).currentCurrency;

      List<String> currentCoinSplit = currentCoin!.split(' ');
      String currentCoinSelectedCode = currentCoinSplit.last;
      return MultiProvider(
        providers: [
          StreamProvider<Coin?>.value(
            initialData: Coin(),
            catchError: (context, error) {
              print(
                  'ERROR ON STREAM PROVIDER OF COINEXCHANGE RATES IN ADD CLIENT');
              print(error);
              return;
            },
            value: coinCollection
                .doc(currentCoinSelectedCode)
                .snapshots()
                .map(coinFromSnapshot),
          ),
        ],
        child: StatefulBuilder(
          builder: (context, setState) {
            final coinName = Provider.of<Coin?>(context)?.name ?? '';
            final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 0;
            final coinExchangeRatio =
                Provider.of<Coin?>(context)?.exchangeRatio ?? 0;
            final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '';
            final coinCode = Provider.of<Coin?>(context)?.code ?? '';
            final fieldText = TextEditingController();
            var paidAmount = double.parse(priceMultipliedByItsExchangeRatio2(
                    productPrice: remaining,
                    coinDecimals: coinDecimals,
                    coinExchangeRatio: coinExchangeRatio)
                .toString());
            print('remaining: $remaining');
            print('PaidAmount inicial: $paidAmount');

            double moneyRecievedForRegisterMoney = 0;

            double change = 0;

            return SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ticket #$invoiceNumber',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF1B1B1F),
                          fontFamily: 'Poppins-regular',
                        ),
                      ),
                      SizedBox(height: 14),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          color: myTheme.colorScheme.onPrimaryContainer,
                          fontFamily: 'Poppins-medium',
                          letterSpacing: 0.15,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            'Fecha: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: myTheme.colorScheme.onPrimaryContainer,
                              fontFamily: 'Poppins-medium',
                              letterSpacing: 0.15,
                            ),
                          ),
                          Text(
                            '$invoiceDate',
                            style: TextStyle(
                              fontSize: 16,
                              color: myTheme.colorScheme.primary,
                              fontFamily: 'Poppins-medium',
                              letterSpacing: 0.15,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: TextStyle(
                              fontSize: 16,
                              color: myTheme.colorScheme.onPrimaryContainer,
                              fontFamily: 'Poppins-medium',
                              letterSpacing: 0.15,
                            ),
                          ),
                          Text(
                            '$coinSymbol $subTotalformatted',
                            style: TextStyle(
                              fontSize: 16,
                              color: myTheme.colorScheme.primary,
                              fontFamily: 'Poppins-medium',
                              letterSpacing: 0.15,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Descuento maestro ($masterDiscount%)',
                            style: TextStyle(
                              fontSize: 16,
                              color: myTheme.colorScheme.onPrimaryContainer,
                              fontFamily: 'Poppins-medium',
                              letterSpacing: 0.15,
                            ),
                          ),
                          Text(
                            '$coinSymbol $discountMasterformatted',
                            style: TextStyle(
                              fontSize: 16,
                              color: myTheme.colorScheme.primary,
                              fontFamily: 'Poppins-medium',
                              letterSpacing: 0.15,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'IVA (16%)',
                            style: TextStyle(
                              fontSize: 16,
                              color: myTheme.colorScheme.onPrimaryContainer,
                              fontFamily: 'Poppins-medium',
                              letterSpacing: 0.15,
                            ),
                          ),
                          Text(
                            '$coinSymbol $taxformatted',
                            style: TextStyle(
                              fontSize: 16,
                              color: myTheme.colorScheme.primary,
                              fontFamily: 'Poppins-medium',
                              letterSpacing: 0.15,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              color: myTheme.colorScheme.onPrimaryContainer,
                              fontFamily: 'Poppins-medium',
                              letterSpacing: 0.15,
                            ),
                          ),
                          Text(
                            '$coinSymbol $totalformatted',
                            style: TextStyle(
                              fontSize: 16,
                              color: myTheme.colorScheme.primary,
                              fontFamily: 'Poppins-medium',
                              letterSpacing: 0.15,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.white,
                                ),
                                overlayColor: MaterialStateProperty.resolveWith(
                                  (states) {
                                    return states
                                            .contains(MaterialState.pressed)
                                        ? myTheme.colorScheme.primary
                                        : null;
                                  },
                                ),
                                splashFactory: NoSplash.splashFactory,
                                elevation: MaterialStateProperty.all(0),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    side: BorderSide(
                                      color: myTheme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.seeClient,
                                style: TextStyle(
                                  fontFamily: 'Poppins-medium',
                                  color: myTheme.colorScheme.primary,
                                  fontSize: 12,
                                ),
                              ),
                              onPressed: () {
                                // Ver resumen de Cliente
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ClientDetails(
                                      specialContribuyer: specialContribuyer,
                                      masterDiscount: masterDiscount,
                                      fiscalAddress: fiscalAddress,
                                      email: email,
                                      listOfPrices: listOfPrices,
                                      name: name,
                                      tlf1: tlf1,
                                      tlf2: tlf2,
                                      zone: zone,
                                      nameId: nameId,
                                      typeId: typeId,
                                      clientDocumentReferenceID:
                                          clientDocumentReferenceID,
                                      dispatchAddress:
                                          currentClientDispatchAdress,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.white,
                                ),
                                overlayColor: MaterialStateProperty.resolveWith(
                                  (states) {
                                    return states
                                            .contains(MaterialState.pressed)
                                        ? myTheme.colorScheme.primary
                                        : null;
                                  },
                                ),
                                splashFactory: NoSplash.splashFactory,
                                elevation: MaterialStateProperty.all(0),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    side: BorderSide(
                                      color: myTheme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.seePayments,
                                style: TextStyle(
                                  fontFamily: 'Poppins-medium',
                                  color: myTheme.colorScheme.primary,
                                  fontSize: 12,
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // return Container();
                                      return SeePaymentsALertDialog(
                                        dateFormatter: dateFormatter,
                                        invoiceNumber:
                                            int.parse(invoiceNumber.toString()),
                                        client: client,
                                        invoiceDocumentID: invoiceDocumentID,
                                        invoicePayments: invoicePayments,
                                        coinName: coinName,
                                        coinDecimals: coinDecimals,
                                        coinExchangeRatio: coinExchangeRatio,
                                        coinSymbol: coinSymbol,
                                        coinCode: coinCode,
                                        remaining: remaining,
                                        sumOfApprovedPayments:
                                            sumOfApprovedPayments,
                                        sumOfPendingPayments:
                                            sumOfPendingPayments,
                                        completed: completed,
                                      );
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                      completed
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        myTheme.colorScheme.primary,
                                      ),
                                      overlayColor:
                                          MaterialStateProperty.resolveWith(
                                        (states) {
                                          return states.contains(
                                                  MaterialState.pressed)
                                              ? Colors.white
                                              : null;
                                        },
                                      ),
                                      splashFactory: NoSplash.splashFactory,
                                      elevation: MaterialStateProperty.all(0),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          side: BorderSide(
                                            color: myTheme.colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .registerPayment,
                                      style: TextStyle(
                                        fontFamily: 'Poppins-medium',
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    onPressed: () {
                                      showDialogForRegisterPayment(
                                        context,
                                        selectedValueA,
                                        formattedDate,
                                        today,
                                        dateFormatter,
                                        selectedCoin,
                                        fieldText,
                                        moneyRecievedForRegisterMoney,
                                        subTotal,
                                        discountPercentage,
                                        discount,
                                        percentageTax,
                                        double.parse(tax.toString()),
                                        invoiceTotal,
                                        change,
                                        paidAmount: paidAmount,
                                        coinDecimals: coinDecimals,
                                        coinExchangeRatio: double.parse(
                                            coinExchangeRatio.toString()),
                                        coinSymbol: coinSymbol,
                                        remaining: remaining,
                                        coinName: coinName,
                                        coinCode: coinCode,
                                        paymentsValidPayQuantity:
                                            paymentsValidPayQuantity,
                                        client: client,
                                        invoiceDocumentID: invoiceDocumentID,
                                        invoiceNumber: invoiceNumber,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

// ignore: must_be_immutable
class SeePaymentsALertDialog extends StatelessWidget {
  SeePaymentsALertDialog({
    super.key,
    required this.dateFormatter,
    required this.invoiceNumber,
    required this.client,
    required this.invoiceDocumentID,
    required this.invoicePayments,
    required this.coinName,
    required this.coinDecimals,
    required this.coinExchangeRatio,
    required this.coinSymbol,
    required this.coinCode,
    required this.remaining,
    required this.sumOfApprovedPayments,
    required this.sumOfPendingPayments,
    required this.completed,
  });

  var invoicePayments;
  final DateFormat dateFormatter;
  final int invoiceNumber;
  final client;
  final invoiceDocumentID;
  final coinName;
  final coinDecimals;
  final coinExchangeRatio;
  final coinSymbol;
  final coinCode;
  final remaining;
  final sumOfApprovedPayments;
  final sumOfPendingPayments;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StatefulBuilder(builder: ((context, setState) {
        var remainingConverted = priceMultipliedByItsExchangeRatio2(
          productPrice: remaining,
          coinDecimals: coinDecimals,
          coinExchangeRatio: coinExchangeRatio,
        );
        var remainingFormatted =
            formatDecimalPriceByRegion(price: remainingConverted);
        print('remainingConverted: $remainingConverted');
        print('remainingFormatted: $remainingFormatted');

        var sumOfApprovedPaymentsConverted = priceMultipliedByItsExchangeRatio2(
          productPrice: sumOfApprovedPayments,
          coinDecimals: coinDecimals,
          coinExchangeRatio: coinExchangeRatio,
        );
        var sumOfApprovedPaymentsFormatted =
            formatDecimalPriceByRegion(price: sumOfApprovedPaymentsConverted);
        print(
            'sumOfApprovedPaymentsConverted: $sumOfApprovedPaymentsConverted');
        print(
            'sumOfApprovedPaymentsFormatted: $sumOfApprovedPaymentsFormatted');

        var sumOfPendingPaymenstConverted = priceMultipliedByItsExchangeRatio2(
          productPrice: sumOfPendingPayments,
          coinDecimals: coinDecimals,
          coinExchangeRatio: coinExchangeRatio,
        );
        var sumOfPendingPaymensFormatted =
            formatDecimalPriceByRegion(price: sumOfPendingPaymenstConverted);

        print('sumOfPendingPaymenstConverted: $sumOfPendingPaymenstConverted');
        print('sumOfPendingPaymensFormatted: $sumOfPendingPaymensFormatted');

        return AlertDialog(
          surfaceTintColor: Color.fromARGB(255, 222, 222, 222),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            '${AppLocalizations.of(context)!.invoiceNumber} #$invoiceNumber',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.onPrimaryContainer,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Container(
                    // color: Colors.grey,
                    height: 330,
                    width: MediaQuery.of(context).size.width,
                    child: invoicePayments.isEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          // Colors.red.withOpacity(0.3)),
                                          myTheme.colorScheme.primary
                                              .withOpacity(0.3)),
                                  width: 110,
                                  height: 110,
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Icon(
                                      MaterialCommunityIcons.archive_alert,
                                      color: myTheme
                                          .colorScheme.onPrimaryContainer,
                                      size: 60,
                                    ),
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.noPayments,
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    fontSize: 13,
                                    color:
                                        myTheme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ],
                            ))
                        : Scrollbar(
                            thumbVisibility: true,
                            child: ListView.builder(
                              itemCount: invoicePayments.length,
                              itemBuilder: (context, index) {
                                final isLast =
                                    index == (invoicePayments.length - 1);
                                final payment = invoicePayments[index];
                                final date = payment['fecha'];
                                final unformattedDate =
                                    DateTime.parse(date.toDate().toString());
                                final paymentDate =
                                    dateFormatter.format(unformattedDate);

                                var paymentAmount =
                                    priceMultipliedByItsExchangeRatio2(
                                  productPrice: payment['monto'],
                                  coinDecimals: coinDecimals,
                                  coinExchangeRatio: payment['tasaDeCambio'],
                                );

                                final fecha =
                                    (payment['fecha'] as Timestamp).toDate();
                                final hoy = DateTime.now();
                                var permitirCancelacion = false;

                                if (fecha.year == hoy.year &&
                                    fecha.month == hoy.month &&
                                    fecha.day == hoy.day &&
                                    fecha.hour < 22) {
                                  permitirCancelacion = true;
                                }

                                final mostrarCancelacionDevolucion =
                                    payment['metodo']
                                            .toString()
                                            .toLowerCase()
                                            .contains('tarjeta') &&
                                        payment['stan'] != null;

                                final yaAnuladoConciliadoRefund =
                                    payment['anulado'] == true ||
                                        payment['conciliado'] == true ||
                                        payment['refund'] == true;

                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () async {},
                                      leading: Icon(
                                        Icons.money_off_csred,
                                        color: payment['refund'] == true
                                            ? Colors.blue.shade800
                                            : payment['anulado'] == false
                                                ? payment['conciliado'] == false
                                                    ? Colors.amber.shade600
                                                    : Colors.green.shade600
                                                : myTheme.colorScheme.error,
                                      ),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$coinSymbol ${paymentAmount.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-regular',
                                              color: payment['refund'] == true
                                                  ? Colors.blue.shade800
                                                  : payment['anulado'] == false
                                                      ? payment['conciliado'] ==
                                                              false
                                                          ? Colors
                                                              .amber.shade600
                                                          : Colors
                                                              .green.shade600
                                                      : myTheme
                                                          .colorScheme.error,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              paymentDate,
                                              style: TextStyle(
                                                fontFamily: 'Poppins-regular',
                                                color: myTheme
                                                    .colorScheme.secondary,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        '${payment['metodo']}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme.colorScheme.secondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    if (mostrarCancelacionDevolucion &&
                                        !yaAnuladoConciliadoRefund)
                                      Column(
                                        children: [
                                          if (permitirCancelacion)
                                            ElevatedButton.icon(
                                              onPressed: () async {
                                                final newPayments =
                                                    await cancel(
                                                        context,
                                                        payment,
                                                        AppLocalizations.of(
                                                                context)!
                                                            .pleaseWait,
                                                        client,
                                                        invoiceDocumentID,
                                                        index);
                                                if (newPayments == null) {
                                                  return;
                                                }
                                                setState(
                                                  () => invoicePayments =
                                                      newPayments,
                                                );
                                              },
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateColor
                                                          .resolveWith(
                                                (states) => Colors.red,
                                              )),
                                              icon: Icon(
                                                Icons.block_rounded,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                              label: Text(
                                                'Cancelación',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ElevatedButton.icon(
                                            onPressed: () async {
                                              refund(
                                                  context,
                                                  payment,
                                                  AppLocalizations.of(context)!
                                                      .pleaseWait,
                                                  client,
                                                  invoiceDocumentID,
                                                  index);
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateColor
                                                        .resolveWith(
                                              (states) => Colors.green,
                                            )),
                                            icon: Icon(
                                              Icons.currency_exchange_rounded,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                            label: Text(
                                              'Devolución',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (!isLast)
                                      Divider(
                                        color: Colors.grey,
                                        endIndent: 8,
                                        indent: 8,
                                      )
                                  ],
                                );
                              },
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.upToPay}: ',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      // 'Phos',
                      '$coinSymbol $remainingFormatted',
                      // completed
                      //     ? '$coinSymbol $remainingConverted'
                      //     : '$coinSymbol ${remainingConverted.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                remainingConverted.toDouble() <= 0
                    ? SizedBox(
                        height: 5,
                      )
                    : Container(),
                remainingConverted.toDouble() <= 0
                    ? Text(
                        'Esta factura no tiene deuda',
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          color: myTheme.colorScheme.error,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Container(),
                remainingConverted.toDouble() <= 0
                    ? SizedBox(
                        height: 5,
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.balanceConfirmed}: ',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: Colors.green.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      // 'Phos',

                      '$coinSymbol $sumOfApprovedPaymentsFormatted',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: Colors.green.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.balanceLeft}: ',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: Colors.amber.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      // 'Phos',
                      // '${AppLocalizations.of(context)!.balanceLeft}: ${priceFormat(sumOfPendingPayments)}',
                      '$coinSymbol $sumOfPendingPaymensFormatted',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: Colors.amber.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.goBack,
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
      })),
    );
  }
}
