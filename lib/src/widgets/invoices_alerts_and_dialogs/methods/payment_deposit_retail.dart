// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
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

paymentDepositRetail(
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
  String accountNumber = '';
  File? imageFile;
  String voucherNumber = '';

  final amountExchanged = priceDividedbyItsExchangeRatio(
    amount: paidAmount,
    exchange: coinExchangeRatio,
  );

  return StatefulBuilder(builder: (context, setState) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Column(
      children: [
        Text(
          '${AppLocalizations.of(context)!.bank}*',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            color: themeProvider.myTheme.colorScheme.primary,
            fontSize: 14,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                        color: themeProvider.myTheme.colorScheme.primary
                            .withOpacity(0.7),
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
                            color: themeProvider.myTheme.colorScheme.primary,
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
                    themeProvider.myTheme.colorScheme.primary.withOpacity(0.5),
                iconDisabledColor: Colors.grey,
              ),
              buttonStyleData: ButtonStyleData(
                height: 50,
                padding: const EdgeInsets.only(left: 14, right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: themeProvider.myTheme.colorScheme.primary
                        .withOpacity(0.3),
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
          '${AppLocalizations.of(context)!.voucherNumber}*',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            color: themeProvider.myTheme.colorScheme.primary,
            fontSize: 14,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          height: 70,
          // width: 200,

          child: TextField(
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins-regular',
              color: themeProvider.myTheme.colorScheme.primary,
            ),
            keyboardType: TextInputType.phone,
            maxLines: 1,
            maxLength: 25,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              voucherNumber = value;
              print(voucherNumber);
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
                  color: themeProvider.myTheme.colorScheme.primary
                      .withOpacity(0.3),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: '0112345678',
              hintStyle: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 14,
                color:
                    themeProvider.myTheme.colorScheme.primary.withOpacity(0.2),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            // onChanged: searchClient,
          ),
        ),
        Text(
          '${AppLocalizations.of(context)!.accountNumber}*',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            color: themeProvider.myTheme.colorScheme.primary,
            fontSize: 14,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: 70,
          // width: 200,

          child: TextField(
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins-regular',
              color: themeProvider.myTheme.colorScheme.primary,
            ),
            keyboardType: TextInputType.phone,
            maxLines: 1,
            maxLength: 25,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              // setState(() {
              accountNumber = value;
              // });
              print(accountNumber);
            },

            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
              hintText: '0112345678',
              hintStyle: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 14,
                color:
                    themeProvider.myTheme.colorScheme.primary.withOpacity(0.2),
              ),
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
                  color: themeProvider.myTheme.colorScheme.primary
                      .withOpacity(0.3),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
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
                      color: themeProvider.myTheme.colorScheme.secondary,
                    ),
                  ),
                  Text(
                    // AppLocalizations.of(context)!.gallery,
                    'Subir Imagen',
                    style: TextStyle(
                      color: themeProvider.myTheme.colorScheme.primary,
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
                        color: themeProvider.myTheme.colorScheme.primary,
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
                      setState(() => imageFile = null);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        themeProvider.myTheme.colorScheme.primary,
                      ),
                      foregroundColor: MaterialStateProperty.all(
                        Colors.white,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                        ),
                      ),
                    ),
                    icon: Icon(
                      MaterialIcons.arrow_back_ios,
                      size: 14,
                      color: Colors.white,
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
                            if (selectedBank == null) {
                              Fluttertoast.showToast(
                                  msg: 'Seleccione un banco por favor');
                            } else {
                              if (accountNumber == '' && voucherNumber == '') {
                                Fluttertoast.showToast(
                                    msg: 'Ingrese datos de cuenta validos');
                              } else {
                                print('Cantidad permitida');
                                Fluttertoast.showToast(
                                  msg: 'Registrando Deposito',
                                  backgroundColor:
                                      themeProvider.myTheme.colorScheme.primary,
                                  textColor: Colors.white,
                                );

                                try {
                                  await registerDepositPayment(
                                    originalAmount: paidAmount,
                                    coinExchangeRatio: coinExchangeRatio,
                                    client: client,
                                    invoiceDocumentID: invoiceDocumentID,
                                    currency: selectedCoin,
                                    amount: amountExchanged,
                                    totalOfTheOrder: totalOfTheOrder,
                                    currentCoin: currentCoin,
                                    bank: selectedBank,
                                    accountNumber: accountNumber,
                                    voucherNumber: voucherNumber,
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

                                  paymentBody.payments
                                      .add(PayMethod('Deposito', paidAmount));

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
                                          method: "Deposito",
                                          date:
                                              '${date.day}-${date.month}-${date.year} ${(date).hour}:${(date).minute}',
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
                              }
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              themeProvider.myTheme.colorScheme.primary,
                            ),
                            foregroundColor: MaterialStateProperty.all(
                              Colors.white,
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  16,
                                ),
                              ),
                            ),
                          ),
                          icon: Icon(
                            MaterialCommunityIcons.bank,
                            size: 14,
                            color: Colors.white,
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
    );
  });
}
