import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/identify_payment_method_retail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

paymentTransferRetail(
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
) {
  String? selectedBank;
  File? imageFile;
  String referenceId = '';

  final amountExchanged = priceDividedbyItsExchangeRatio(
    amount: paidAmount,
    exchange: coinExchangeRatio,
  );

  return StatefulBuilder(
    builder: (context, setState) => Column(
      children: [
        Text(
          '${AppLocalizations.of(context)!.bank}*',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            color: myTheme.colorScheme.primary,
            fontSize: 14,
          ),
        ),
        selectedValueA == 'Transferencia'
            ? Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedBank ?? 'Seleccione una opción',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color:
                                  myTheme.colorScheme.primary.withOpacity(0.7),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: itemsBank
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: myTheme.colorScheme.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedBank,
                    onChanged: (value) {
                      setState(
                        () {
                          selectedBank = value as String;
                        },
                      );
                    },
                    iconStyleData: IconStyleData(
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 11,
                      iconEnabledColor:
                          myTheme.colorScheme.primary.withOpacity(0.5),
                      iconDisabledColor: Colors.grey,
                    ),
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: myTheme.colorScheme.primary.withOpacity(0.3),
                        ),
                        color: Colors.white,
                      ),
                      elevation: 0,
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 40,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: 200,
                      padding: null,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      elevation: 8,
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(10),
                        thickness: MaterialStateProperty.all<double>(6),
                        thumbVisibility: MaterialStateProperty.all<bool>(true),
                      ),
                      offset: const Offset(0, 0),
                    ),
                  ),
                ),
              )
            : Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedBank ?? 'Seleccione una opción',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color:
                                  myTheme.colorScheme.primary.withOpacity(0.7),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: itemsBankInter
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: myTheme.colorScheme.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedBank,
                    onChanged: (value) {
                      setState(
                        () {
                          selectedBank = value as String;
                        },
                      );
                    },
                    iconStyleData: IconStyleData(
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 11,
                      iconEnabledColor:
                          myTheme.colorScheme.primary.withOpacity(0.5),
                      iconDisabledColor: Colors.grey,
                    ),
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: myTheme.colorScheme.primary.withOpacity(0.3),
                        ),
                        color: Colors.white,
                      ),
                      elevation: 0,
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 40,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: 200,
                      padding: null,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      elevation: 8,
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(10),
                        thickness: MaterialStateProperty.all<double>(6),
                        thumbVisibility: MaterialStateProperty.all<bool>(true),
                      ),
                      offset: const Offset(0, 0),
                    ),
                  ),
                ),
              ),
        Text(
          '${AppLocalizations.of(context)!.referenceNumber}*',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            color: myTheme.colorScheme.primary,
            fontSize: 14,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          height: 70,
          // width: 200,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(10),
          //   border: Border.all(
          //     color: myTheme.colorScheme.primary.withOpacity(0.3),
          //     // color: Colors.transparent,
          //   ),
          // ),
          child: TextField(
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.primary,
            ),
            keyboardType: TextInputType.phone,
            maxLines: 1,
            maxLength: 25,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              referenceId = value;
              print(referenceId);
            },

            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF4f42ed),
                ),
              ),
              filled: true, //<-- SEE HERE
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: myTheme.colorScheme.primary.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: '00000000',
              hintStyle: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 14,
                color: myTheme.colorScheme.primary.withOpacity(0.2),
              ),

              // counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            // onChanged: searchClient,
          ),
        ),
        Column(
          children: [
            Text(
              '${AppLocalizations.of(context)!.selectFile}',
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
                    margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
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
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: paidAmount == 0
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
                    icon: Icon(
                      MaterialIcons.arrow_back_ios,
                      size: 14,
                    ),
                    label: Text(
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
                      : ElevatedButton.icon(
                          onPressed: () async {
                            if (selectedValueA == 'Transferencia') {
                              if (selectedBank == null) {
                                Fluttertoast.showToast(
                                    msg: 'Seleccione un banco por favor');
                              } else {
                                if (referenceId == '') {
                                  Fluttertoast.showToast(
                                      msg: 'Ingrese datos de cuenta validos');
                                } else {
                                  print('Cantidad permitida');
                                  Fluttertoast.showToast(
                                    msg: 'Registrando $selectedValueA',
                                    backgroundColor:
                                        myTheme.colorScheme.primary,
                                    textColor: Colors.white,
                                  );

                                  try {
                                    await registerTransferInterPayment(
                                      originalAmount: paidAmount,
                                      coinExchangeRatio: coinExchangeRatio,
                                      client: client,
                                      invoiceDocumentID: invoiceDocumentID,
                                      currency: selectedCoin,
                                      amount: amountExchanged,
                                      totalOfTheOrder: totalOfTheOrder,
                                      currentCoin: currentCoin,
                                      bank: selectedBank,
                                      referenceId: referenceId,
                                      imageFile: imageFile,
                                      date: date,
                                      remaining: remaining,
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
                                    paymentBody.payments.add(
                                        PayMethod('Transferencia', paidAmount));
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
                                        totalOfTheOrder,
                                      );
                                    } else {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              CompletedPayPage(
                                            client: client,
                                            total: totalOfTheOrder,
                                            method: "Transferencia",
                                            date:
                                                '${date.day}-${date.month}-${date.year} ${(date as DateTime).hour}:${(date).minute}',
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
                                  /* } */
                                }
                              }
                            } else if (selectedValueA ==
                                'Transf-internacional') {
                              if (selectedBank == null) {
                                Fluttertoast.showToast(
                                    msg: 'Seleccione un banco por favor');
                              } else {
                                if (referenceId == '') {
                                  Fluttertoast.showToast(
                                      msg: 'Ingrese datos de cuenta validos');
                                } else {
                                  print('Cantidad permitida');
                                  Fluttertoast.showToast(
                                    msg: 'Registrando $selectedValueA',
                                    backgroundColor:
                                        myTheme.colorScheme.primary,
                                    textColor: Colors.white,
                                  );

                                  try {
                                    await registerTransferPayment(
                                      originalAmount: paidAmount,
                                      coinExchangeRatio: coinExchangeRatio,
                                      client: client,
                                      invoiceDocumentID: invoiceDocumentID,
                                      currency: selectedCoin,
                                      amount: amountExchanged,
                                      totalOfTheOrder: totalOfTheOrder,
                                      currentCoin: currentCoin,
                                      bank: selectedBank,
                                      referenceId: referenceId,
                                      imageFile: imageFile,
                                      date: date,
                                      remaining: remaining,
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
                                    paymentBody.payments.add(PayMethod(
                                        'Transferencia-internacional',
                                        paidAmount));
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
                                        totalOfTheOrder,
                                      );
                                    } else {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              CompletedPayPage(
                                            client: client,
                                            total: totalOfTheOrder,
                                            method:
                                                "Transferencia - Internacional",
                                            date:
                                                '${date.day}-${date.month}-${date.year} ${(date as DateTime).hour}:${(date).minute}',
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
                                  /* } */
                                }
                              }
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
                          icon: Icon(
                            MaterialCommunityIcons.card,
                            size: 14,
                          ),
                          label: Text(
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
