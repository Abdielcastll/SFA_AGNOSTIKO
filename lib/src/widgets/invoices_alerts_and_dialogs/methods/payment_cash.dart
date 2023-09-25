import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/utils/requestFileBottomSheet.dart';
import 'package:pwa_sales2go_flutter/src/widgets/dialog/confirmed_pament_dialog.dart';

paymentCash(
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
    String? coinSymbol,
    double moneyRecievedForRegisterMoney,
    int? paymentsValidPayQuantity) {
  File? imageFile;

  return StatefulBuilder(
    builder: (BuildContext context, setState) => Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          // AppLocalizations.of(context)!.selectFile,
          'Subir comprobante',
          style: TextStyle(
            fontFamily: 'Poppins-medium',
            color: myTheme.colorScheme.primary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 149,
          height: 24,
          child: ElevatedButton(
            onPressed: () async {
              requestFileBottomSheet(context, (image) {
                setState(() {
                  imageFile = image;
                });
              });
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: myTheme.colorScheme.primary,
              backgroundColor: Color(0xFFDFE0FF),
              elevation: 0,
            ),
            child: Text(
              'Seleccionar archivo',
              style: TextStyle(
                color: myTheme.colorScheme.onPrimaryContainer,
                fontFamily: 'Poppins-medium',
                fontSize: 11,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        imageFile == null
            ? Container()
            : GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(
                    msg: 'Presione 2 veces para eliminar imagen seleccionada',
                    backgroundColor: myTheme.colorScheme.primary,
                    textColor: Colors.white,
                  );
                },
                onDoubleTap: () {
                  setState(() {
                    imageFile = null;
                  });
                  Fluttertoast.showToast(
                    msg: 'Imagen eliminada',
                    backgroundColor: Colors.green.shade600,
                    textColor: Colors.white,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: myTheme.colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => imageFile = null);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    // myTheme.colorScheme.primary,
                    Colors.white,
                  ),
                  elevation: MaterialStateProperty.all(0),
                  splashFactory: NoSplash.splashFactory,
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(
                        color: myTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: myTheme.colorScheme.primary,
                    fontFamily: 'Poppins-medium',
                    fontSize: 12,
                  ),
                ),
              ),
              paidAmount == 0
                  ? Container()
                  : moneyRecievedForRegisterMoney < paidAmount
                      ? Container()
                      : ElevatedButton(
                          onPressed: () async {
                            if (paidAmount is String) {
                              paidAmount = double.parse(paidAmount.toString());
                            }

                            print('Cantidad permitida');
                            print('REGISTRANDO PAGO EN EFECTIVO');
                            print('FACTURA: $invoiceDocumentID');
                            Fluttertoast.showToast(
                              msg: 'Registrando pago en efectivo',
                              backgroundColor: myTheme.colorScheme.primary,
                              textColor: Colors.white,
                            );
                            print('+++++++++++++++++++++++++++++++++');
                            print('DATOS A ENVIAR');
                            print('coinExchangeRatio: $coinExchangeRatio');
                            print('originalAmount: $paidAmount');
                            print('client: $client');
                            print('invoiceDocumentID: $invoiceDocumentID');
                            print('currency: $selectedCoin');
                            print(
                                'amount: ${exchangeAmount(amount: paidAmount, coin: selectedCoin, exchange: coinExchangeRatio)},');
                            print('totalOfTheOrder: $totalOfTheOrder');
                            print('imageFile: $imageFile');
                            print('date: $date');
                            print('remaining: $remaining');
                            print('imageFile: $imageFile');
                            print(
                                'paymentsValidPayQuantity: $paymentsValidPayQuantity');

                            await registerMoneyPayment(
                              coinExchangeRatio: coinExchangeRatio,
                              originalAmount: paidAmount,
                              client: client,
                              invoiceDocumentID: invoiceDocumentID,
                              currency: selectedCoin,
                              amount: priceDividedbyItsExchangeRatio(
                                amount: paidAmount,
                                exchange: coinExchangeRatio,
                              ),
                              totalOfTheOrder: totalOfTheOrder,
                              imageFile: imageFile,
                              date: date,
                            ).whenComplete(() async {
                              await uploadReceiptImage(
                                  imageFile,
                                  invoiceDocumentID,
                                  paymentsValidPayQuantity! + 1);
                            }).whenComplete(() {
                              checkIfInvoiceIsCompleted(
                                paidAmount: paidAmount,
                                remaining: remainingConverted,
                                client: client,
                                invoiceDocumentID: invoiceDocumentID,
                              );
                            }).whenComplete(() {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              showDialogForConfirmedPayment(
                                context,
                                coinSymbol,
                                paidAmount,
                                client,
                                date,
                                selectedValueA,
                              );
                            });
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
                          child: Text(
                            'Continuar',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins-medium',
                              fontSize: 12,
                            ),
                          ),
                        ),
            ],
          ),
        )
      ],
    ),
  );
}
