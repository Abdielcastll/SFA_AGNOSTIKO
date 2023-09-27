// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/add_payment.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/completed_pay.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/utils/requestFileBottomSheet.dart';
import 'package:pwa_sales2go_flutter/src/widgets/dialog/confirmed_payment_retail_dialog.dart';
import 'package:pwa_sales2go_flutter/src/widgets/dialog/go_back_to_catalogue_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

paymentCashRetail(
    double paidAmount,
    Client client,
    String invoiceDocumentID,
    double totalOfTheOrder,
    String selectedCoin,
    DateTime date,
    double remaining,
    coinExchangeRatio,
    String selectedValueA,
    double remainingConverted,
    String? currentCoin,
    AddPaymentBodyAtt paymentBody,
    String? coinSymbol,
    double moneyRecievedForRegisterMoney) {
  File? imageFile;

  final amountExchanged = priceDividedbyItsExchangeRatio(
    amount: paidAmount,
    exchange: coinExchangeRatio,
  );

  return StatefulBuilder(
    builder: (BuildContext context, setState) => Column(
      children: [
        Column(
          children: [
            Text(
              AppLocalizations.of(context)!.selectFile,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
            InkWell(
              onTap: () async {
                requestFileBottomSheet(context, (image) {
                  setState(() {
                    imageFile = image;
                  });
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.camera,
                      color: myTheme.colorScheme.secondary,
                    ),
                  ),
                  Text(
                    // AppLocalizations.of(context)!.gallery,
                    'Subir Imagen',
                    style: TextStyle(
                      color: myTheme.colorScheme.primary,
                      fontFamily: 'Poppins-regular',
                    ),
                  ),
                ],
              ),
            ),
            imageFile == null
                ? Container()
                : Container(
                    margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                    // height: 300,
                    // width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: myTheme.colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.file(
                        imageFile!,
                        fit: BoxFit.contain,
                        // height: 300,
                        // width: 300,
                      ),
                    ),
                  ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: moneyRecievedForRegisterMoney < paidAmount
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      goBackToCatalogue(context);
                      // Navigator.pop(context);
                      setState(() => imageFile = null);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        myTheme.colorScheme.primary,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    icon: const Icon(
                      MaterialIcons.arrow_back_ios,
                      size: 14,
                    ),
                    label: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins-regular',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  paidAmount == 0
                      ? Container()
                      : moneyRecievedForRegisterMoney < paidAmount
                          ? Container()
                          : ElevatedButton.icon(
                              onPressed: () async {
                                if (paidAmount is String) {
                                  paidAmount = paidAmount;
                                }
                                print('Cantidad permitida');
                                Fluttertoast.showToast(
                                  msg: 'Registrando Pago en Efectivo',
                                  backgroundColor: myTheme.colorScheme.primary,
                                  textColor: Colors.white,
                                );
                                try {
                                  await registerMoneyPayment(
                                    originalAmount: paidAmount,
                                    coinExchangeRatio: coinExchangeRatio,
                                    client: client,
                                    invoiceDocumentID: invoiceDocumentID,
                                    currency: selectedCoin,
                                    amount: amountExchanged,
                                    totalOfTheOrder: totalOfTheOrder,
                                    imageFile: imageFile,
                                    date: date,
                                  ).whenComplete(() async {
                                    await uploadReceiptImage(
                                        imageFile,
                                        invoiceDocumentID,
                                        paymentBody.payments.length + 1);
                                  }).whenComplete(() {
                                    checkIfInvoiceIsCompleted(
                                      paidAmount: paidAmount,
                                      remaining: remainingConverted,
                                      client: client,
                                      invoiceDocumentID: invoiceDocumentID,
                                    );
                                  });
                                  paymentBody.payments
                                      .add(PayMethod('Efectivo', paidAmount));

                                  print('IDENTIFY PAYMENTS');
                                  print(paymentBody.payments.length);

                                  if (paidAmount < remainingConverted) {
                                    showDialogForConfirmedPaymentRetail(
                                        context,
                                        coinSymbol,
                                        paidAmount,
                                        client,
                                        date,
                                        selectedValueA,
                                        paymentBody,
                                        amountExchanged,
                                        totalOfTheOrder);
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CompletedPayPage(
                                          client: client,
                                          total: totalOfTheOrder,
                                          method: "Efectivo",
                                          date:
                                              '${date.day}-${date.month}-${date.year} ${date.hour}:${(date).minute}',
                                          address: '',
                                          coinsExchangeRates: const [],
                                          addPaymentBody: paymentBody,
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  print(e);
                                  Fluttertoast.showToast(msg: e.toString());
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  myTheme.colorScheme.onPrimaryContainer,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              icon: const Icon(
                                MaterialCommunityIcons.hand_coin,
                                size: 14,
                              ),
                              label: const Text(
                                'Continuar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                ],
              ),
            ),
          ],
        )
      ],
    ),
  );
}
