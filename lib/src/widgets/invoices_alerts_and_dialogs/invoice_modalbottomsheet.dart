// ignore_for_file: prefer_const_constructors
import 'dart:math' as math;

import 'dart:io';
import 'package:agnostiko/agnostiko.dart';
import 'package:agnostiko/emv/src/emv_transaction.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/add_payment.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/identify_payment_method.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/transaction_args.dart';
import '../../pages/amount_input/amount_input.dart';

priceToCurrencySelectedInput(productPrice, coin) {
  double correctAmount = double.parse(productPrice.toStringAsFixed(4));
  if (coin!.contains('USD')) {
    return double.parse(correctAmount.toStringAsFixed(4));
  } else if (coin.contains('VED')) {
    return double.parse((correctAmount * 4.58).toStringAsFixed(4));
  } else if (coin.contains('EUR')) {
    return double.parse((correctAmount * 0.89).toStringAsFixed(4));
  } else if (coin.contains('MXN')) {
    return double.parse((correctAmount * 19.43).toStringAsFixed(4));
  } else if (coin.contains('BTC')) {
    return double.parse((correctAmount * 0.00011).toStringAsFixed(4));
  } else {
    return double.parse((correctAmount * 4.58).toStringAsFixed(4));
  }
}

void modalBottomSheetForInvoices(
  bool completed,
  context,
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
  invoiceNumber,
  invoiceTotal,
  client,
  invoiceDocumentID,
  currentClientDispatchAdress,
  subTotal,
  percentageTax,
  double tax,
  discountPercentage,
  discount,
) {
  var dateFormatter = DateFormat('dd-MM-yyyy');
  DateTime today = DateTime.now();
  String formattedDate = dateFormatter.format(today);
  String? selectedValueA;
  String? selectedCoin = 'MXN';

  final paymentsValidPay =
      invoicePayments.where((element) => element['anulado'] == false).toList();
  // print(paymentsValidPay);
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
    return i + element['montoOriginal'];
  });

  var sumOfValidPayments = paymentsValidPay.fold(0, (i, element) {
    return i + element['montoOriginal'];
  });

  var sumOfApprovedPayments = approvedPayments.fold(0, (i, element) {
    return i + element['montoOriginal'];
  });

  print('invoiceTotal: $invoiceTotal');
  print('sumOfValidPayments: $sumOfValidPayments');
  final remaining =
      double.parse((invoiceTotal - sumOfValidPayments).toStringAsFixed(4));
  print('remaining: $remaining');
  final leftoverAmount;
  if (remaining < 0) {
    leftoverAmount = 0.00;
  } else {
    leftoverAmount = remaining.toStringAsFixed(4);
  }

  // double paidAmount = selectedCoin == null
  //     ? double.parse(remaining.toStringAsFixed(4))
  //     : priceToCurrencySelectedInput(
  //         double.parse(remaining.toStringAsFixed(4)), selectedCoin);

  showModalBottomSheet(
    elevation: 0,
    backgroundColor: Colors.white,
    barrierColor: myTheme.colorScheme.secondary.withOpacity(0.5),
    // isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      // double paidAmount = remaining;

      print(invoiceDocumentID);
      final currentCoin =
          Provider.of<CurrencyProvider>(context).currentCurrency;

      priceFormat(productPrice) {
        double correctAmount = double.parse(productPrice.toStringAsFixed(4));
        if (currentCoin!.contains('USD')) {
          return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
              .format(productPrice)
              .toString();
        } else if (currentCoin.contains('VED')) {
          return NumberFormat.currency(
            locale: 'es_VE',
            decimalDigits: 2,
            symbol: "Bs.",
          ).format(correctAmount * 4.58).toString();
        } else if (currentCoin.contains('EUR')) {
          return NumberFormat.currency(
            locale: 'es_ES',
            decimalDigits: 2,
            symbol: '€',
          ).format(correctAmount * 0.89).toString();
        } else if (currentCoin.contains('MXN')) {
          return NumberFormat.currency(
            locale: 'es_MX',
            decimalDigits: 2,
            symbol: '\$',
          ).format(correctAmount * 19.43);
        } else if (currentCoin.contains('BTC')) {
          return '฿ ${(correctAmount * 0.00011).toString()}';
        } else {
          return NumberFormat.currency(
            locale: 'es_VE',
            decimalDigits: 2,
            symbol: "PPR.",
          ).format(correctAmount * 4.58).toString();
        }
      }

      priceFormatForPaidAmount(productPrice, coin) {
        double correctAmount = double.parse(productPrice.toStringAsFixed(4));
        if (coin!.contains('USD')) {
          return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
              .format(productPrice)
              .toString();
        } else if (coin.contains('VED')) {
          return NumberFormat.currency(
            locale: 'es_VE',
            decimalDigits: 2,
            symbol: "Bs.",
          ).format(correctAmount * 4.58).toString();
        } else if (coin.contains('EUR')) {
          return NumberFormat.currency(
            locale: 'es_ES',
            decimalDigits: 2,
            symbol: '€',
          ).format(correctAmount * 0.89).toString();
        } else if (coin.contains('MXN')) {
          return NumberFormat.currency(
            locale: 'es_MX',
            decimalDigits: 2,
            symbol: '\$',
          ).format(correctAmount * 19.43);
        } else if (coin.contains('BTC')) {
          return '฿ ${(correctAmount * 0.00011).toString()}';
        } else {
          return NumberFormat.currency(
            locale: 'es_VE',
            decimalDigits: 2,
            symbol: "PPR.",
          ).format(correctAmount * 4.58).toString();
        }
      }

      symbolMoney(coin) {
        if (coin!.contains('USD')) {
          return "USD\$.";
        } else if (coin.contains('VED')) {
          return "BsS.";
        } else if (coin.contains('EUR')) {
          return "€.";
        } else if (coin.contains('MXN')) {
          return '\$';
          // return "MXN\$.";
        } else if (coin.contains('BTC')) {
          return '฿.';
        } else {
          return "PPR";
        }
      }

      return StatefulBuilder(
        builder: (context, setState) {
          //
          // double paidAmount = remaining;
          double paidAmount =
              priceToCurrencySelectedInput(remaining, selectedCoin);

          final fieldText = TextEditingController();

          return SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                      child: Text(
                        AppLocalizations.of(context)!.options,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: myTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: myTheme.colorScheme.primary),
                              child: TextButton(
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
                                style: TextButton.styleFrom(
                                  foregroundColor: myTheme.colorScheme.primary,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.seeClient,
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: myTheme.colorScheme.primary),
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SingleChildScrollView(
                                          child: StatefulBuilder(
                                              builder: ((context, setState) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              title: Text(
                                                '${AppLocalizations.of(context)!.invoiceNumber} #$invoiceNumber',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  color: myTheme
                                                      .colorScheme.secondary,
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
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: invoicePayments
                                                                .isEmpty
                                                            ? Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: 300,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .noPayments,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Poppins-regular',
                                                                      fontSize:
                                                                          13,
                                                                      color: myTheme
                                                                          .colorScheme
                                                                          .onPrimaryContainer),
                                                                ))
                                                            : Scrollbar(
                                                                child: ListView
                                                                    .builder(
                                                                  itemCount:
                                                                      invoicePayments
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    final payment =
                                                                        invoicePayments[
                                                                            index];
                                                                    final date =
                                                                        payment[
                                                                            'fecha'];
                                                                    final unformattedDate =
                                                                        DateTime.parse(date
                                                                            .toDate()
                                                                            .toString());
                                                                    final paymentDate =
                                                                        dateFormatter
                                                                            .format(unformattedDate);
                                                                    return ListTile(
                                                                      onTap:
                                                                          () {
                                                                        // Ver o Editar detalles de pago
                                                                      },
                                                                      leading:
                                                                          Icon(
                                                                        Icons
                                                                            .money_off_csred,
                                                                        color: payment['anulado'] ==
                                                                                false
                                                                            ? payment['conciliado'] == false
                                                                                ? Colors.amber
                                                                                : Colors.green
                                                                            : Colors.red,
                                                                      ),
                                                                      title:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            priceFormat(payment['montoOriginal']),
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Poppins-regular',
                                                                              color: Colors.grey.shade400,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            child:
                                                                                Text(
                                                                              paymentDate,
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins-regular',
                                                                                color: Colors.grey.shade400,
                                                                                fontSize: 10,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      subtitle:
                                                                          Text(
                                                                        '${payment['metodo']}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Poppins-regular',
                                                                          color: Colors
                                                                              .grey
                                                                              .shade400,
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 30),
                                                    Text(
                                                      '${AppLocalizations.of(context)!.upToPay}: ${priceFormat(double.parse(remaining.toStringAsFixed(4)) > 0.00 ? remaining : 0.00)}',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-regular',
                                                        color: myTheme
                                                            .colorScheme
                                                            .secondary,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    remaining <= 0
                                                        ? Text(
                                                            'Esta factura no tiene deuda',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-regular',
                                                              color: myTheme
                                                                  .colorScheme
                                                                  .error,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )
                                                        : Container(),
                                                    Text(
                                                      '${AppLocalizations.of(context)!.balanceConfirmed}: ${priceFormat(sumOfApprovedPayments)}',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-regular',
                                                        color: Colors.green,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${AppLocalizations.of(context)!.balanceLeft}: ${priceFormat(sumOfPendingPayments)}',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-regular',
                                                        color: Colors.amber,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .goBack,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins-regular',
                                                            color: myTheme
                                                                .colorScheme
                                                                .primary,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                      });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: myTheme.colorScheme.primary,
                                ),
                                child: Text(
                                  // Ver Pagos
                                  AppLocalizations.of(context)!.seePayments,
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Registrar pagos
                        completed
                            ? Container()
                            : Container(
                                margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: myTheme.colorScheme.primary),
                                child: TextButton(
                                  onPressed: () {
                                    // ignore: use_build_context_synchronously
                                    /* Navigator.pushNamed(
                                      context,
                                      AmountInputView.route,
                                      arguments: TransactionArgs(
                                        platformInfo: platformInfo,
                                        entryMode: EntryMode.Magstripe,
                                        showNumericKeyboard:
                                            !platformInfo.hasKeypad,
                                        supportedCardTypes:
                                            platformInfo.supportedCardTypes,
                                        emvTransactionType:
                                            EmvTransactionType.Goods,
                                      ),
                                    ); */
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        final List<String> items = [
                                          'Tarjeta de Debito',
                                          'Tarjeta de Credito',
                                          'Efectivo',
                                          'Cheque',
                                          'Deposito',
                                          'Transferencia',
                                          'Transf-internacional',
                                          // 'Criptomoneda',
                                          // 'Nota de credito',
                                        ];
                                        List<String> itemsCoin = [
                                          'USD',
                                          // 'BTC',
                                          // 'EUR',
                                          // 'VED',
                                          'MXN',
                                        ];
                                        return StatefulBuilder(
                                          builder: ((context, setState) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              title: Text(
                                                // Registrar pagos
                                                AppLocalizations.of(context)!
                                                    .registerPayment,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  color: Color.fromARGB(
                                                      255, 0, 24, 143),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              content: Container(
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        // Metodo de pago
                                                        AppLocalizations.of(
                                                                context)!
                                                            .paymentMethod,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-regular',
                                                          color: Color.fromARGB(
                                                              255, 0, 24, 143),
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 5, 10, 10),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child:
                                                              DropdownButton2(
                                                            isExpanded: true,
                                                            // ignore: prefer_const_literals_to_create_immutables
                                                            hint: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    selectedValueA ??
                                                                        'Seleccione medio de pago',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color.fromRGBO(
                                                                              46,
                                                                              62,
                                                                              174,
                                                                              1)
                                                                          .withOpacity(
                                                                              0.3),
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            items: items
                                                                .map((item) =>
                                                                    DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          item,
                                                                      child:
                                                                          Text(
                                                                        item,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color: myTheme
                                                                              .colorScheme
                                                                              .primary,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ))
                                                                .toList(),
                                                            value:
                                                                selectedValueA,
                                                            onChanged: (value) {
                                                              setState(
                                                                () {
                                                                  selectedValueA =
                                                                      value
                                                                          as String;
                                                                },
                                                              );
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .arrow_forward_ios_outlined,
                                                            ),
                                                            iconSize: 11,
                                                            iconEnabledColor:
                                                                myTheme
                                                                    .colorScheme
                                                                    .primary
                                                                    .withOpacity(
                                                                        0.5),
                                                            iconDisabledColor:
                                                                Colors.grey,
                                                            buttonHeight: 50,
                                                            // buttonWidth: 200,
                                                            buttonPadding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 14,
                                                                    right: 14),
                                                            buttonDecoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              border:
                                                                  Border.all(
                                                                color: myTheme
                                                                    .colorScheme
                                                                    .primary
                                                                    .withOpacity(
                                                                        0.3),
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            buttonElevation: 0,
                                                            itemHeight: 40,
                                                            itemPadding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 14,
                                                                    right: 14),
                                                            dropdownMaxHeight:
                                                                300,
                                                            dropdownWidth: 200,
                                                            dropdownPadding:
                                                                null,
                                                            dropdownDecoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            dropdownElevation:
                                                                8,
                                                            scrollbarRadius:
                                                                const Radius
                                                                    .circular(10),
                                                            scrollbarThickness:
                                                                6,
                                                            scrollbarAlwaysShow:
                                                                true,
                                                            offset:
                                                                const Offset(
                                                                    0, 0),
                                                          ),
                                                        ),
                                                      ),
                                                      // Container(
                                                      //   margin:
                                                      //       EdgeInsets.fromLTRB(
                                                      //           10, 5, 10, 10),
                                                      //   child:
                                                      //       DropdownButtonHideUnderline(
                                                      //     child:
                                                      //         DropdownButton2(
                                                      //       isExpanded: true,
                                                      //       // ignore: prefer_const_literals_to_create_immutables
                                                      //       hint: Row(
                                                      //         children: [
                                                      //           Expanded(
                                                      //             child: Text(
                                                      //               selectedCoin ??
                                                      //                   'Seleccione moneda',
                                                      //               style:
                                                      //                   TextStyle(
                                                      //                 fontSize:
                                                      //                     12,
                                                      //                 fontWeight:
                                                      //                     FontWeight
                                                      //                         .bold,
                                                      //                 color: myTheme
                                                      //                     .colorScheme
                                                      //                     .primary
                                                      //                     .withOpacity(
                                                      //                         0.3),
                                                      //               ),
                                                      //               overflow:
                                                      //                   TextOverflow
                                                      //                       .ellipsis,
                                                      //             ),
                                                      //           ),
                                                      //         ],
                                                      //       ),
                                                      //       items: itemsCoin
                                                      //           .map((item) =>
                                                      //               DropdownMenuItem<
                                                      //                   String>(
                                                      //                 value:
                                                      //                     item,
                                                      //                 child:
                                                      //                     Text(
                                                      //                   item,
                                                      //                   style:
                                                      //                       TextStyle(
                                                      //                     fontSize:
                                                      //                         14,
                                                      //                     fontWeight:
                                                      //                         FontWeight.bold,
                                                      //                     color: myTheme
                                                      //                         .colorScheme
                                                      //                         .primary,
                                                      //                   ),
                                                      //                   overflow:
                                                      //                       TextOverflow.ellipsis,
                                                      //                 ),
                                                      //               ))
                                                      //           .toList(),
                                                      //       value: selectedCoin,
                                                      //       onChanged: (value) {
                                                      //         setState(
                                                      //           () {
                                                      //             selectedCoin =
                                                      //                 value
                                                      //                     as String;
                                                      //           },
                                                      //         );
                                                      //         fieldText.clear();
                                                      //         setState(() {
                                                      //           paidAmount =
                                                      //               priceToCurrencySelectedInput(
                                                      //                   remaining,
                                                      //                   selectedCoin);
                                                      //         });

                                                      //         print(
                                                      //             'Moneda cambiada');
                                                      //         print(
                                                      //             'Nuevo valor:');
                                                      //         print(paidAmount);
                                                      //       },
                                                      //       icon: const Icon(
                                                      //         Icons
                                                      //             .arrow_forward_ios_outlined,
                                                      //       ),
                                                      //       iconSize: 11,
                                                      //       iconEnabledColor:
                                                      //           myTheme
                                                      //               .colorScheme
                                                      //               .primary
                                                      //               .withOpacity(
                                                      //                   0.5),
                                                      //       iconDisabledColor:
                                                      //           Colors.grey,
                                                      //       buttonHeight: 50,
                                                      //       // buttonWidth: 200,
                                                      //       buttonPadding:
                                                      //           const EdgeInsets
                                                      //                   .only(
                                                      //               left: 14,
                                                      //               right: 14),
                                                      //       buttonDecoration:
                                                      //           BoxDecoration(
                                                      //         borderRadius:
                                                      //             BorderRadius
                                                      //                 .circular(
                                                      //                     5),
                                                      //         border:
                                                      //             Border.all(
                                                      //           color: myTheme
                                                      //               .colorScheme
                                                      //               .primary
                                                      //               .withOpacity(
                                                      //                   0.3),
                                                      //         ),
                                                      //         color:
                                                      //             Colors.white,
                                                      //       ),
                                                      //       buttonElevation: 0,
                                                      //       itemHeight: 40,
                                                      //       itemPadding:
                                                      //           const EdgeInsets
                                                      //                   .only(
                                                      //               left: 14,
                                                      //               right: 14),
                                                      //       dropdownMaxHeight:
                                                      //           200,
                                                      //       dropdownWidth: 200,
                                                      //       dropdownPadding:
                                                      //           null,
                                                      //       dropdownDecoration:
                                                      //           BoxDecoration(
                                                      //         borderRadius:
                                                      //             BorderRadius
                                                      //                 .circular(
                                                      //                     10),
                                                      //         color:
                                                      //             Colors.white,
                                                      //       ),
                                                      //       dropdownElevation:
                                                      //           8,
                                                      //       scrollbarRadius:
                                                      //           const Radius
                                                      //               .circular(10),
                                                      //       scrollbarThickness:
                                                      //           6,
                                                      //       scrollbarAlwaysShow:
                                                      //           true,
                                                      //       offset:
                                                      //           const Offset(
                                                      //               0, 0),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      // Fecha del registro del pago
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .date,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-regular',
                                                          color: myTheme
                                                              .colorScheme
                                                              .primary,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 10, 10),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 10, 10, 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          border: Border.all(
                                                            color: myTheme
                                                                .colorScheme
                                                                .primary
                                                                .withOpacity(
                                                                    0.3),
                                                          ),
                                                        ),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              formattedDate,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: myTheme
                                                                    .colorScheme
                                                                    .primary
                                                                    .withOpacity(
                                                                        0.7),
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 30,
                                                              width: 30,
                                                              margin: EdgeInsets
                                                                  .fromLTRB(0,
                                                                      0, 0, 5),
                                                              child: IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (selectedValueA!
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          'tarjeta')) {
                                                                    today =
                                                                        DateTime
                                                                            .now();
                                                                    return;
                                                                  }
                                                                  DateTime?
                                                                      newDate =
                                                                      await showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        today,
                                                                    firstDate:
                                                                        DateTime
                                                                            .now(),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2500),
                                                                  );
                                                                  if (newDate ==
                                                                      null) {
                                                                    return;
                                                                  }
                                                                  setState(() {
                                                                    today =
                                                                        newDate;
                                                                    formattedDate =
                                                                        dateFormatter
                                                                            .format(today);
                                                                  });
                                                                },
                                                                splashRadius: 5,
                                                                icon: Icon(
                                                                  Icons
                                                                      .calendar_month,
                                                                  color: myTheme
                                                                      .colorScheme
                                                                      .primary,
                                                                  size: 20,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      //  Monto del pago

                                                      selectedCoin == null
                                                          ? Container()
                                                          : Text(
                                                              '${AppLocalizations.of(context)!.amount}*',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-regular',
                                                                color: myTheme
                                                                    .colorScheme
                                                                    .primary,
                                                                fontSize: 14,
                                                              ),
                                                            ),

                                                      selectedCoin == null
                                                          ? Container()
                                                          : Container(
                                                              margin: EdgeInsets
                                                                  .fromLTRB(10,
                                                                      0, 10, 0),
                                                              height: 50,
                                                              // width: 200,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border:
                                                                    Border.all(
                                                                  color: myTheme
                                                                      .colorScheme
                                                                      .primary
                                                                      .withOpacity(
                                                                          0.3),
                                                                  // color: Colors.transparent,
                                                                ),
                                                              ),
                                                              child: TextField(
                                                                onChanged:
                                                                    (value) {
                                                                  if (value
                                                                      .isEmpty) {
                                                                    setState(
                                                                        () {
                                                                      paidAmount =
                                                                          0;
                                                                    });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      paidAmount =
                                                                          double.parse(
                                                                              value);
                                                                    });
                                                                  }
                                                                },
                                                                controller:
                                                                    fieldText,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Poppins-regular',
                                                                  color: myTheme
                                                                      .colorScheme
                                                                      .primary,
                                                                ),
                                                                //TODO:

                                                                inputFormatters: <
                                                                    TextInputFormatter>[
                                                                  FilteringTextInputFormatter
                                                                      .allow(
                                                                    RegExp(
                                                                        r'[0-9]+[,.]{0,1}[0-9]*'),
                                                                  ),
                                                                  TextInputFormatter
                                                                      .withFunction(
                                                                    (oldValue,
                                                                            newValue) =>
                                                                        newValue
                                                                            .copyWith(
                                                                      text: newValue
                                                                          .text
                                                                          .replaceAll(
                                                                              ',',
                                                                              '.'),
                                                                    ),
                                                                  ),
                                                                ],
                                                                keyboardType:
                                                                    TextInputType
                                                                        .phone,

                                                                maxLines: 1,
                                                                maxLength: 50,
                                                                textCapitalization:
                                                                    TextCapitalization
                                                                        .characters,

                                                                decoration:
                                                                    InputDecoration(
                                                                  prefixIcon:
                                                                      Container(
                                                                    width: 40,
                                                                    height: 40,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        symbolMoney(
                                                                            selectedCoin),
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Poppins-regular',
                                                                          fontSize:
                                                                              14,
                                                                          color: myTheme
                                                                              .colorScheme
                                                                              .primary,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .fromLTRB(
                                                                    14,
                                                                    0,
                                                                    0,
                                                                    0,
                                                                  ),
                                                                  hintText:
                                                                      '$paidAmount',
                                                                  // ' ${priceToCurrencySelectedInput(remaining, selectedCoin)}',
                                                                  hintStyle:
                                                                      TextStyle(
                                                                    height:
                                                                        1.85,
                                                                    fontFamily:
                                                                        'Poppins-regular',
                                                                    fontSize:
                                                                        14,
                                                                    color: myTheme
                                                                        .colorScheme
                                                                        .primary,
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                    ),
                                                                  ),
                                                                  counterText:
                                                                      '',
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                      selectedCoin != null
                                                          ? selectedValueA !=
                                                                  null
                                                              ? Column(
                                                                  children: [
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                          .fromLTRB(
                                                                        0,
                                                                        10,
                                                                        0,
                                                                        0,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        'Subtotal: ${priceFormatForPaidAmount(subTotal, selectedCoin).toString()} ',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Poppins-regular',
                                                                          color: myTheme
                                                                              .colorScheme
                                                                              .primary,
                                                                          fontSize:
                                                                              10,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'Descuento Maestro ($discountPercentage%): ${priceFormatForPaidAmount(discount, selectedCoin).toString()}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Poppins-regular',
                                                                        color: myTheme
                                                                            .colorScheme
                                                                            .primary,
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin:
                                                                          const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              5,
                                                                              0,
                                                                              0),
                                                                      child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceAround,
                                                                          children: [
                                                                            Text(
                                                                              'IVA ($percentageTax%): ${priceFormatForPaidAmount(tax, selectedCoin).toString()}',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins-regular',
                                                                                color: myTheme.colorScheme.primary,
                                                                                fontSize: 10,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              'Total: ${priceFormatForPaidAmount(invoiceTotal, selectedCoin).toString()}',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins-regular',
                                                                                color: myTheme.colorScheme.primary,
                                                                                fontSize: 10,
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    Text(
                                                                      // 'Saldo: ${priceFormatForPaidAmount(remaining.toStringAsFixed(4), selectedCoin)}',
                                                                      'Saldo: ${priceFormatForPaidAmount(remaining, selectedCoin)}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Poppins-regular',
                                                                        color: myTheme
                                                                            .colorScheme
                                                                            .onPrimaryContainer,
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                    Divider(),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                        0,
                                                                        5,
                                                                        0,
                                                                        0,
                                                                      ),
                                                                      child: identifyPaymentMethod(
                                                                          selectedValueA:
                                                                              selectedValueA!,
                                                                          client:
                                                                              client,
                                                                          invoiceDocumentID:
                                                                              invoiceDocumentID,
                                                                          paidAmount:
                                                                              paidAmount,
                                                                          totalOfTheOrder:
                                                                              invoiceTotal,
                                                                          date:
                                                                              today,
                                                                          context:
                                                                              context,
                                                                          remaining: double.parse(remaining.toStringAsFixed(
                                                                              2)),
                                                                          selectedCoin:
                                                                              selectedCoin!,
                                                                          noRetail:
                                                                              true,
                                                                          paymentBody: AddPaymentBodyAtt(
                                                                              client: client,
                                                                              currency: selectedCoin!,
                                                                              discount: 0,
                                                                              discountPercentage: 0,
                                                                              invoiceDocumentID: invoiceDocumentID,
                                                                              invoiceNumber: invoiceNumber,
                                                                              percentageTax: percentageTax,
                                                                              remaining: remaining,
                                                                              subTotal: subTotal,
                                                                              tax: tax)),
                                                                    )
                                                                  ],
                                                                )
                                                              : Container()
                                                          : Container(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        myTheme.colorScheme.primary,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .registerPayment,
                                    style: TextStyle(
                                      fontFamily: 'Poppins-regular',
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
      );
    },
  );
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
