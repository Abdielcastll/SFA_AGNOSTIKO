// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/utils/requestFileBottomSheet.dart';
import 'package:pwa_sales2go_flutter/src/widgets/dialog/confirmed_pament_dialog.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/identify_payment_method_retail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

paymentDeposit(
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
    int? paymentsValidPayQuantity) {
  String? selectedBank;
  String accountNumber = '';
  File? imageFile;
  String voucherNumber = '';

  return StatefulBuilder(
    builder: (context, setState) => Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context)!.bank}*',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            color: myTheme.colorScheme.primary,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 12),
        Container(
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
                        color: myTheme.colorScheme.primary,
                        fontFamily: "Poppins-regular",
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
                            color: myTheme.colorScheme.primary,
                            fontFamily: "Poppins-regular",
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
                iconEnabledColor: myTheme.colorScheme.primary.withOpacity(0.5),
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
                padding: null,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                elevation: 8,
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(8),
                  thickness: MaterialStateProperty.all<double>(6),
                  thumbVisibility: MaterialStateProperty.all<bool>(true),
                ),
                offset: const Offset(0, 0),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        Text(
          '${AppLocalizations.of(context)!.voucherNumber}*',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            color: myTheme.colorScheme.primary,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 70,
          // width: 200,

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
              voucherNumber = value;
              print(voucherNumber);
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
              hintText: '0112345678',
              hintStyle: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 14,
                color: myTheme.colorScheme.primary.withOpacity(0.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
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
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
        Text(
          '${AppLocalizations.of(context)!.accountNumber}*',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            color: myTheme.colorScheme.primary,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 70,
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
              accountNumber = value;
              print(accountNumber);
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
              hintText: '0112345678',
              hintStyle: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 14,
                color: myTheme.colorScheme.primary.withOpacity(0.2),
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
                  color: myTheme.colorScheme.primary.withOpacity(0.3),
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
          ),
        ),
        Column(
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
            SizedBox(height: 8),
            Container(
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
            SizedBox(height: 12),
            imageFile == null
                ? Container()
                : GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                        msg:
                            'Presione 2 veces para eliminar imagen seleccionada',
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
            SizedBox(height: 20),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 104,
                    child: ElevatedButton(
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                  ),
                  paidAmount == 0
                      ? Container()
                      : Container(
                          width: 104,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Crear en DB una visita

                              if (selectedBank == null) {
                                Fluttertoast.showToast(
                                    msg: 'Seleccione un banco por favor');
                              } else {
                                if (accountNumber == '' &&
                                    voucherNumber == '') {
                                  Fluttertoast.showToast(
                                      msg: 'Ingrese datos de cuenta validos');
                                } else {
                                  print('Cantidad permitida');
                                  Fluttertoast.showToast(
                                    msg: 'Registrando Pago con deposito',
                                    backgroundColor:
                                        myTheme.colorScheme.primary,
                                    textColor: Colors.white,
                                  );
                                  try {
                                    await registerDepositPayment(
                                      coinExchangeRatio: coinExchangeRatio,
                                      originalAmount: paidAmount,
                                      client: client,
                                      invoiceDocumentID: invoiceDocumentID,
                                      currency: selectedCoin,
                                      amount: priceDividedbyItsExchangeRatio(
                                          amount: paidAmount,
                                          exchange: coinExchangeRatio),
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
                                          selectedValueA);
                                    });
                                  } catch (e) {
                                    print(e);
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
                            child: Text(
                              'Continuar',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins-medium',
                                fontSize: 12,
                              ),
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
