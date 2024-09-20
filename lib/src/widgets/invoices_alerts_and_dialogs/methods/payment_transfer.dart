import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/utils/requestFileBottomSheet.dart';
import 'package:pwa_sales2go_flutter/src/widgets/dialog/confirmed_pament_dialog.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/identify_payment_method_retail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

paymentTransfer(
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
  File? imageFile;
  String referenceId = '';

  return StatefulBuilder(builder: (context, setState) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context)!.bank}*',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            color: themeProvider.myTheme.colorScheme.primary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        selectedValueA == 'Transferencia'
            ? DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  hint: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedBank ?? 'Seleccione una opción',
                          style: TextStyle(
                            fontSize: 14,
                            color: themeProvider.myTheme.colorScheme.primary,
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
                                color:
                                    themeProvider.myTheme.colorScheme.primary,
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
                    iconEnabledColor: themeProvider.myTheme.colorScheme.primary
                        .withOpacity(0.5),
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
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
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
              )
            : DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  hint: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedBank ?? 'Seleccione una opción',
                          style: TextStyle(
                            fontSize: 14,
                            color: themeProvider.myTheme.colorScheme.primary,
                            fontFamily: "Poppins-regular",
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
                                color:
                                    themeProvider.myTheme.colorScheme.primary,
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
                    iconEnabledColor: themeProvider.myTheme.colorScheme.primary
                        .withOpacity(0.5),
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
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
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
        const SizedBox(height: 12),
        Text(
          '${AppLocalizations.of(context)!.referenceNumber}*',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            color: themeProvider.myTheme.colorScheme.primary,
            fontSize: 14,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
              referenceId = value;
              print(referenceId);
            },

            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
              hintText: '00000000',
              hintStyle: TextStyle(
                fontFamily: 'Poppins-Regular',
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
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            // onChanged: searchClient,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subir comprobante',
              style: TextStyle(
                fontFamily: 'Poppins-medium',
                color: themeProvider.myTheme.colorScheme.primary,
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
                  foregroundColor: themeProvider.myTheme.colorScheme.primary,
                  backgroundColor: const Color(0xFFDFE0FF),
                  elevation: 0,
                ),
                child: Text(
                  'Seleccionar archivo',
                  style: TextStyle(
                    color: themeProvider.myTheme.colorScheme.onPrimaryContainer,
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
                        msg:
                            'Presione 2 veces para eliminar imagen seleccionada',
                        backgroundColor:
                            themeProvider.myTheme.colorScheme.primary,
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
                          color: themeProvider.myTheme.colorScheme.primary,
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
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => imageFile = null);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        themeProvider.myTheme.colorScheme.primary,
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
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins-Regular',
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
                                    backgroundColor: themeProvider
                                        .myTheme.colorScheme.primary,
                                    textColor: Colors.white,
                                  );
                                  try {
                                    await registerTransferPayment(
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
                            } else if (selectedValueA ==
                                'Transf-internacional') {
                              if (selectedBank != null) {
                                if (referenceId != '') {
                                  print('Cantidad permitida');
                                  Fluttertoast.showToast(
                                    msg: 'Registrando $selectedValueA',
                                    backgroundColor: themeProvider
                                        .myTheme.colorScheme.primary,
                                    textColor: Colors.white,
                                  );
                                  try {
                                    await registerTransferInterPayment(
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
                                      referenceId: referenceId,
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
                                  // }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Ingrese datos de cuenta validos');
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Seleccione un banco por favor');
                              }
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              themeProvider
                                  .myTheme.colorScheme.onPrimaryContainer,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          icon: const Icon(
                            MaterialCommunityIcons.card,
                            size: 14,
                          ),
                          label: const Text(
                            'Continuar',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins-Regular',
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
