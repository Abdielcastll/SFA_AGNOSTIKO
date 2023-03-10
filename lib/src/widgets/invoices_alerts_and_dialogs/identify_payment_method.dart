// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unnecessary_cast, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/completed_pay.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';

import '../../pages/place_order/add_payment.dart';
import '../payment_method/payment_card.dart';

getFromGallery(context) async {
  XFile? pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return pickedFile;
  } else {
    return;
  }
}

cropImage(filePath, imageFile) async {
  CroppedFile? croppedImage = await ImageCropper().cropImage(
    sourcePath: filePath,
    maxHeight: 1080,
    maxWidth: 1080,
  );
  if (croppedImage != null) {
    return croppedImage;
  }
}

priceToCurrencySelected(double productPrice, String coin) {
  double correctAmount = double.parse(productPrice.toStringAsFixed(2));
  if (coin.contains('USD')) {
    return correctAmount;
  } else if (coin.contains('VED')) {
    return correctAmount * 4.58;
  } else if (coin.contains('EUR')) {
    return correctAmount * 0.89;
  } else if (coin.contains('MXN')) {
    return correctAmount * 19.43;
  } else if (coin.contains('BTC')) {
    return correctAmount * 0.00011;
  } else {
    return correctAmount * 4.58;
  }
}

testPrint() {
  print('//////////////////////////////////');
  print('TESTEO: PHOSPHOPHYLLITE');
  print('//////////////////////////////////');
}

identifyPaymentMethod({
  required String selectedValueA,
  required Client client,
  required String invoiceDocumentID,
  required double paidAmount,
  required double totalOfTheOrder,
  required DateTime date,
  context,
  required double remaining,
  required String selectedCoin,
  Function? updatePayed,
  AddPaymentBodyAtt? paymentBody,
  noRetail = false,
}) {
  File? imageFile;
  String accountHolder = '';
  String accountNumber = '';
  String transactionId = '';
  String voucherNumber = '';
  String referenceId = '';
  String? selectedBank;
  // String? selectedCoin;
  List<String> itemsBank = [
    'BANCO CENTRAL',
    'BANCO BICENTENARIO',
    'BANCO DE VENEZUELA',
    'BANESCO',
    'BOD',
    'BNC',
  ];
  List<String> itemsBankInter = [
    'BANK OF AMERICA',
    'CITIBANK',
    'HSBC',
    'WELLSFARGO',
  ];
  // List<String> itemsCoin = [
  //   'USD',
  //   'BTC',
  //   'EUR',
  //   'VED',
  // ];
  // List<String> itemsCoinVED = [
  //   'VED',
  // ];
  // final currentCoin = sharedPreferences!.getString('currentCoin');
  final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;

  priceFormat(productPrice) {
    double correctAmount = double.parse(productPrice.toStringAsFixed(2));
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

  print('Metodo: $selectedValueA');
  print('currentCoin: $currentCoin');
  // print('totalOfTheOrder: $totalOfTheOrder');
  print('paidAmount: $paidAmount');
  print('remaining: $remaining');

  if (selectedValueA == 'Tarjeta de Debito' ||
      selectedValueA == 'Tarjeta de Credito') {
    return paymentCard(paidAmount, client, invoiceDocumentID, totalOfTheOrder,
        selectedCoin, date, remaining,
        updatePayed: updatePayed, paymentBody: paymentBody, noRetail: noRetail);
  }

  if (selectedValueA == 'Cheque') {
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
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                // ignore: prefer_const_literals_to_create_immutables
                hint: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedBank ?? 'Seleccione una opción',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: myTheme.colorScheme.primary.withOpacity(0.7),
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
                      accountNumber = '';
                      accountHolder = '';
                    },
                  );
                },
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 11,
                iconEnabledColor: myTheme.colorScheme.primary.withOpacity(0.5),
                iconDisabledColor: Colors.grey,
                buttonHeight: 50,
                // buttonWidth: 200,
                buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: myTheme.colorScheme.primary.withOpacity(0.3),
                  ),
                  color: Colors.white,
                ),
                buttonElevation: 0,
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                dropdownMaxHeight: 200,
                dropdownWidth: 200,
                dropdownPadding: null,
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                dropdownElevation: 8,
                scrollbarRadius: const Radius.circular(10),
                scrollbarThickness: 6,
                scrollbarAlwaysShow: true,
                offset: const Offset(0, 0),
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
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: myTheme.colorScheme.primary.withOpacity(0.3),
                // color: Colors.transparent,
              ),
            ),
            child: TextField(
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.primary,
              ),
              keyboardType: TextInputType.phone,
              maxLines: 1,
              maxLength: 20,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                // setState(() {
                accountNumber = value;
                // });
                print(accountNumber);
              },
              // textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                hintText: '0112345678',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14,
                  color: myTheme.colorScheme.primary.withOpacity(0.2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                counterText: '',
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
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              '${AppLocalizations.of(context)!.accountHolder}*',
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.primary,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            height: 50,
            // width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: myTheme.colorScheme.primary.withOpacity(0.3),
                // color: Colors.transparent,
              ),
            ),
            child: TextField(
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.primary,
              ),
              keyboardType: TextInputType.name,
              maxLines: 1,
              maxLength: 50,
              textCapitalization: TextCapitalization.characters,

              onChanged: (value) {
                // setState(() {
                accountHolder = value;
                // });
                print(accountHolder);
              },

              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                hintText: 'John Doe / Jane Doe',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14,
                  color: myTheme.colorScheme.primary.withOpacity(0.2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                counterText: '',
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
              SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.selectFile,
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  var pickedFile = await getFromGallery(context);
                  if (pickedFile != null) {
                    print('Imagen seleccionada');
                    var croppedImage =
                        await cropImage(pickedFile.path, imageFile);
                    if (croppedImage != null) {
                      print('Imagen recortada');
                      setState(() {
                        imageFile = File(croppedImage.path);
                      });
                    } else {
                      print('Error croppeando');
                    }
                  } else {
                    print('error seleccionando');
                    return;
                  }
                },
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
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
                      AppLocalizations.of(context)!.gallery,
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
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: myTheme.colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.file(
                        imageFile!,
                        height: 300,
                        width: 300,
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
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
                  paidAmount! == 0
                      ? Container()
                      : Container(
                          // width: 125,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              // Crear en DB una visita
                              if (selectedCoin != null) {
                                if (paidAmount != null ||
                                    paidAmount != null ||
                                    paidAmount! <= totalOfTheOrder!) {
                                  if (selectedBank != null) {
                                    if (accountNumber != '' ||
                                        accountHolder != '') {
                                      print('Registrando pago en cheque');
                                      if (double.parse(paidAmount.toString()) >
                                          remaining!) {
                                        Fluttertoast.showToast(
                                          msg:
                                              'La cantidad a pagar excede de la deuda pendiente',
                                          backgroundColor:
                                              myTheme.colorScheme.secondary,
                                          textColor: Colors.white,
                                        );
                                      } else {
                                        print('Cantidad permitida');
                                        Fluttertoast.showToast(
                                          msg: 'Registrando Cheque',
                                          backgroundColor:
                                              myTheme.colorScheme.primary,
                                          textColor: Colors.white,
                                        );
                                        try {
                                          await registerBankCheckPayment(
                                            client: client,
                                            invoiceDocumentID:
                                                invoiceDocumentID,
                                            currency: selectedCoin,
                                            amount: paidAmount,
                                            totalOfTheOrder: totalOfTheOrder,
                                            currentCoin: currentCoin,
                                            bank: selectedBank,
                                            accountNumber: accountNumber,
                                            accountHolder: accountHolder,
                                            imageFile: imageFile,
                                            date: date,
                                            remaining: remaining,
                                          ).whenComplete(
                                            () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);

                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .all(18),
                                                              child: Center(
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      "¡PAGO REGISTRADO!",
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Poppins-regular',
                                                                        fontSize:
                                                                            18,
                                                                        color: myTheme
                                                                            .colorScheme
                                                                            .onPrimaryContainer,
                                                                        // color: Colors.green,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              15,
                                                                              0,
                                                                              0),
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: myTheme
                                                                              .colorScheme
                                                                              .primary
                                                                              .withOpacity(0.6)),
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      child: Opacity(
                                                                          opacity: 0.8,
                                                                          child: Icon(
                                                                            Icons.check,
                                                                            color:
                                                                                myTheme.colorScheme.onPrimaryContainer,
                                                                            size:
                                                                                50,
                                                                          )),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              0),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 10),
                                                                            child:
                                                                                Text(
                                                                              'Monto pagado: ${priceFormat(paidAmount)}',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins-regular',
                                                                                fontSize: 12,
                                                                                color: myTheme.colorScheme.primary,
                                                                                // color: Colors.green,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 10),
                                                                            child:
                                                                                Text(
                                                                              '${client!.name}',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins-regular',
                                                                                fontSize: 12,
                                                                                color: myTheme.colorScheme.primary,
                                                                                // color: Colors.green,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 10),
                                                                            child:
                                                                                Text(
                                                                              'Fecha: $date',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins-regular',
                                                                                fontSize: 12,
                                                                                color: myTheme.colorScheme.primary,
                                                                                // color: Colors.green,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 10),
                                                                            child:
                                                                                Text(
                                                                              '$selectedValueA',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins-regular',
                                                                                fontSize: 12,
                                                                                color: myTheme.colorScheme.primary,
                                                                                // color: Colors.green,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 50),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: ElevatedButton
                                                                          .icon(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          // Navigator.pop(
                                                                          //     context);
                                                                        },
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(
                                                                            myTheme.colorScheme.primary,
                                                                          ),
                                                                          shape:
                                                                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(18.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        icon:
                                                                            Icon(
                                                                          MaterialIcons
                                                                              .arrow_back_ios,
                                                                          size:
                                                                              12,
                                                                        ),
                                                                        label:
                                                                            Text(
                                                                          'Aceptar',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontFamily:
                                                                                'Poppins-regular',
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                          );
                                          // Navigator.pop(context);
                                        } catch (e) {
                                          Fluttertoast.showToast(
                                              msg: e.toString());
                                        }
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Ingrese datos de cuenta validos');
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'Seleccione un banco por favor');
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Monto a pagar no valido');
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Complete los datos porfavor');
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
                              MaterialCommunityIcons.bank,
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
                        ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  } else if (selectedValueA == 'Criptomoneda') {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          Text(
            '${AppLocalizations.of(context)!.transactionID} *',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.secondary,
              fontSize: 14,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            height: 50,
            // width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: myTheme.colorScheme.primary.withOpacity(0.3),
                // color: Colors.transparent,
              ),
            ),
            child: TextField(
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.primary,
              ),
              keyboardType: TextInputType.phone,
              maxLines: 1,
              maxLength: 50,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                transactionId = value;
                print(transactionId);
              },

              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                hintText: '00000000',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14,
                  color: myTheme.colorScheme.primary.withOpacity(0.2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                counterText: '',
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
                  var pickedFile = await getFromGallery(context);
                  if (pickedFile != null) {
                    print('Imagen seleccionada');
                    var croppedImage =
                        await cropImage(pickedFile.path, imageFile);
                    if (croppedImage != null) {
                      print('Imagen recortada');
                      setState(() {
                        imageFile = File(croppedImage.path);
                      });
                    } else {
                      print('Error croppeando');
                    }
                  } else {
                    print('error seleccionando');
                    return;
                  }
                },
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
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
                      AppLocalizations.of(context)!.gallery,
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
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: myTheme.colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.file(
                        imageFile!,
                        height: 300,
                        width: 300,
                      ),
                    ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() => imageFile = null);
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
                    Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: myTheme.colorScheme.primary),
                      child: TextButton(
                        onPressed: () async {
                          // Crear en DB una visita
                          // registerCriptoPayment();
                          if (transactionId != '') {
                            if (paidAmount != null) {
                              if (paidAmount > remaining) {
                                Fluttertoast.showToast(
                                  msg:
                                      'La cantidad a pagar excede de la deuda pendiente',
                                  backgroundColor: myTheme.colorScheme.primary,
                                  textColor: Colors.white,
                                );
                              } else {
                                print('Cantidad permitida');
                                Fluttertoast.showToast(
                                  msg: 'Registrando Pago en Criptomonedas',
                                  backgroundColor: myTheme.colorScheme.primary,
                                  textColor: Colors.white,
                                );
                                await registerCriptoPayment(
                                  client!,
                                  invoiceDocumentID,
                                  'BTC',
                                  paidAmount,
                                  totalOfTheOrder,
                                  transactionId,
                                  imageFile,
                                  date,
                                  remaining,
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            }
                          } else {
                            Fluttertoast.showToast(msg: 'Ingrese ID porfavor');
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: myTheme.colorScheme.primary,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.orderContinue,
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
              ),
            ],
          )
        ],
      );
    });
  } else if (selectedValueA == 'Deposito') {
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
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                // ignore: prefer_const_literals_to_create_immutables
                hint: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedBank ?? 'Seleccione una opción',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: myTheme.colorScheme.primary.withOpacity(0.7),
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
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 11,
                iconEnabledColor: myTheme.colorScheme.primary.withOpacity(0.5),
                iconDisabledColor: Colors.grey,
                buttonHeight: 50,
                // buttonWidth: 200,
                buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: myTheme.colorScheme.primary.withOpacity(0.3),
                  ),
                  color: Colors.white,
                ),
                buttonElevation: 0,
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                // dropdownMaxHeight: 200,
                // dropdownWidth: 200,
                dropdownPadding: null,
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                dropdownElevation: 8,
                scrollbarRadius: const Radius.circular(10),
                scrollbarThickness: 6,
                scrollbarAlwaysShow: true,
                offset: const Offset(0, 0),
              ),
            ),
          ),
          Text(
            '${AppLocalizations.of(context)!.voucherNumber}*',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.primary,
              fontSize: 14,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            height: 50,
            // width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: myTheme.colorScheme.primary.withOpacity(0.3),
                // color: Colors.transparent,
              ),
            ),
            child: TextField(
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.primary,
              ),
              keyboardType: TextInputType.phone,
              maxLines: 1,
              maxLength: 50,
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
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                counterText: '',
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
          Text(
            '${AppLocalizations.of(context)!.accountNumber}*',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.primary,
              fontSize: 14,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            height: 50,
            // width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: myTheme.colorScheme.primary.withOpacity(0.3),
                // color: Colors.transparent,
              ),
            ),
            child: TextField(
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.primary,
              ),
              keyboardType: TextInputType.phone,
              maxLines: 1,
              maxLength: 50,
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
                  color: myTheme.colorScheme.primary.withOpacity(0.2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                counterText: '',
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
              SizedBox(height: 10),
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
                  var pickedFile = await getFromGallery(context);
                  if (pickedFile != null) {
                    print('Imagen seleccionada');
                    var croppedImage =
                        await cropImage(pickedFile.path, imageFile);
                    if (croppedImage != null) {
                      print('Imagen recortada');
                      setState(() {
                        imageFile = File(croppedImage.path);
                      });
                    } else {
                      print('Error croppeando');
                    }
                  } else {
                    print('error seleccionando');
                    return;
                  }
                },
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
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
                      AppLocalizations.of(context)!.gallery,
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
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: myTheme.colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.file(
                        imageFile!,
                        height: 300,
                        width: 300,
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
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() => imageFile = null);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          myTheme.colorScheme.primary,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                              // Crear en DB una visita

                              if (selectedCoin != null) {
                                if (paidAmount != null ||
                                    paidAmount != null ||
                                    paidAmount! <= totalOfTheOrder!) {
                                  if (selectedBank != null) {
                                    if (accountNumber != '' ||
                                        voucherNumber != '') {
                                      if (paidAmount! > remaining!) {
                                        Fluttertoast.showToast(
                                          msg:
                                              'La cantidad a pagar excede de la deuda pendiente',
                                          backgroundColor:
                                              myTheme.colorScheme.primary,
                                          textColor: Colors.white,
                                        );
                                      } else {
                                        print('Cantidad permitida');
                                        Fluttertoast.showToast(
                                          msg:
                                              'Registrando Pago en Criptomonedas',
                                          backgroundColor:
                                              myTheme.colorScheme.primary,
                                          textColor: Colors.white,
                                        );
                                        try {
                                          await registerDepositPayment(
                                            client: client,
                                            invoiceDocumentID:
                                                invoiceDocumentID,
                                            currency: selectedCoin,
                                            amount: paidAmount,
                                            totalOfTheOrder: totalOfTheOrder,
                                            currentCoin: currentCoin,
                                            bank: selectedBank,
                                            accountNumber: accountNumber,
                                            voucherNumber: voucherNumber,
                                            imageFile: imageFile,
                                            date: date,
                                            remaining: remaining,
                                          ).whenComplete(() {
                                            Navigator.pop(context);
                                            Navigator.pop(context);

                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    18),
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    "¡PAGO REGISTRADO!",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Poppins-regular',
                                                                      fontSize:
                                                                          18,
                                                                      color: myTheme
                                                                          .colorScheme
                                                                          .onPrimaryContainer,
                                                                      // color: Colors.green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            15,
                                                                            0,
                                                                            0),
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: myTheme
                                                                            .colorScheme
                                                                            .primary
                                                                            .withOpacity(0.6)),
                                                                    width: 100,
                                                                    height: 100,
                                                                    child: Opacity(
                                                                        opacity: 0.8,
                                                                        child: Icon(
                                                                          Icons
                                                                              .check,
                                                                          color: myTheme
                                                                              .colorScheme
                                                                              .onPrimaryContainer,
                                                                          size:
                                                                              50,
                                                                        )),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(top: 10),
                                                                          child:
                                                                              Text(
                                                                            'Monto pagado: ${priceFormat(paidAmount)}',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Poppins-regular',
                                                                              fontSize: 12,
                                                                              color: myTheme.colorScheme.primary,
                                                                              // color: Colors.green,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(top: 10),
                                                                          child:
                                                                              Text(
                                                                            '${client!.name}',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Poppins-regular',
                                                                              fontSize: 12,
                                                                              color: myTheme.colorScheme.primary,
                                                                              // color: Colors.green,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(top: 10),
                                                                          child:
                                                                              Text(
                                                                            'Fecha: $date',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Poppins-regular',
                                                                              fontSize: 12,
                                                                              color: myTheme.colorScheme.primary,
                                                                              // color: Colors.green,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(top: 10),
                                                                          child:
                                                                              Text(
                                                                            '$selectedValueA',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Poppins-regular',
                                                                              fontSize: 12,
                                                                              color: myTheme.colorScheme.primary,
                                                                              // color: Colors.green,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                50),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        ElevatedButton
                                                                            .icon(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        // Navigator.pop(
                                                                        //     context);
                                                                      },
                                                                      style:
                                                                          ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all(
                                                                          myTheme
                                                                              .colorScheme
                                                                              .primary,
                                                                        ),
                                                                        shape: MaterialStateProperty.all<
                                                                            RoundedRectangleBorder>(
                                                                          RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(18.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      icon:
                                                                          Icon(
                                                                        MaterialIcons
                                                                            .arrow_back_ios,
                                                                        size:
                                                                            12,
                                                                      ),
                                                                      label:
                                                                          Text(
                                                                        'Aceptar',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontFamily:
                                                                              'Poppins-regular',
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          });
                                        } catch (e) {
                                          print(e);
                                        }
                                        // Navigator.pop(context);
                                        // Navigator.pop(context);
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Ingrese datos de cuenta validos');
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'Seleccione un banco por favor');
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Monto a pagar no valido');
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Complete los datos porfavor');
                              }
                              // print(itemsBank);
                              // print(itemsBankInter);
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
                              MaterialCommunityIcons.bank,
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
  } else if (selectedValueA == 'Efectivo' ||
      selectedValueA == 'Nota de credito') {
    return StatefulBuilder(
      builder: (BuildContext context, setState) => Column(
        children: [
          selectedValueA == 'Nota de credito'
              ? Container(
                  child: Text(
                    'Disponible en Nota de Credito: \$0.00',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      color: myTheme.colorScheme.secondary,
                      fontSize: 14,
                    ),
                  ),
                )
              : Container(),
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
                  var pickedFile = await getFromGallery(context);
                  if (pickedFile != null) {
                    print('Imagen seleccionada');
                    var croppedImage =
                        await cropImage(pickedFile.path, imageFile);
                    if (croppedImage != null) {
                      print('Imagen recortada');
                      setState(() {
                        imageFile = File(croppedImage.path);
                      });
                    } else {
                      print('Error croppeando');
                    }
                  } else {
                    print('error seleccionando');
                    return;
                  }
                },
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
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
                      AppLocalizations.of(context)!.gallery,
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
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: myTheme.colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.file(
                        imageFile!,
                        height: 300,
                        width: 300,
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
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() => imageFile = null);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          myTheme.colorScheme.primary,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                    Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: myTheme.colorScheme.primary),
                      child: TextButton(
                        onPressed: () async {
                          // Crear en DB una visita
                          if (paidAmount != null) {
                            /* if (paidAmount > remaining) {
                              Fluttertoast.showToast(
                                msg:
                                    'La cantidad a pagar excede de la deuda pendiente',
                                backgroundColor: myTheme.colorScheme.primary,
                                textColor: Colors.white,
                              );
                            } else {
                              print('Cantidad permitida');
                              Fluttertoast.showToast(
                                msg: 'Registrando Pago en Efectivo',
                                backgroundColor: myTheme.colorScheme.primary,
                                textColor: Colors.white,
                              );
                            } */
                            Fluttertoast.showToast(
                              msg: 'Registrando Pago en Efectivo',
                              backgroundColor: myTheme.colorScheme.primary,
                              textColor: Colors.white,
                            );
                            print(invoiceDocumentID);
                            await registerMoneyPayment(
                              client: client,
                              invoiceDocumentID: invoiceDocumentID,
                              currency: selectedCoin,
                              amount: paidAmount,
                              totalOfTheOrder: totalOfTheOrder,
                              imageFile: imageFile,
                              date: date,
                              remaining: remaining,
                            ).whenComplete(() {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      content: SingleChildScrollView(
                                        child: Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(18),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "¡PAGO REGISTRADO!",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-regular',
                                                        fontSize: 18,
                                                        color: myTheme
                                                            .colorScheme
                                                            .onPrimaryContainer,
                                                        // color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 15, 0, 0),
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: myTheme
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(
                                                                  0.6)),
                                                      width: 100,
                                                      height: 100,
                                                      child: Opacity(
                                                          opacity: 0.8,
                                                          child: Icon(
                                                            Icons.check,
                                                            color: myTheme
                                                                .colorScheme
                                                                .onPrimaryContainer,
                                                            size: 50,
                                                          )),
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 10, 0, 0),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            child: Text(
                                                              'Monto pagado: ${priceFormat(paidAmount)}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-regular',
                                                                fontSize: 12,
                                                                color: myTheme
                                                                    .colorScheme
                                                                    .primary,
                                                                // color: Colors.green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            child: Text(
                                                              '${client!.name}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-regular',
                                                                fontSize: 12,
                                                                color: myTheme
                                                                    .colorScheme
                                                                    .primary,
                                                                // color: Colors.green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            child: Text(
                                                              'Fecha: $date',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-regular',
                                                                fontSize: 12,
                                                                color: myTheme
                                                                    .colorScheme
                                                                    .primary,
                                                                // color: Colors.green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            child: Text(
                                                              '$selectedValueA',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-regular',
                                                                fontSize: 12,
                                                                color: myTheme
                                                                    .colorScheme
                                                                    .primary,
                                                                // color: Colors.green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 50),
                                                      alignment:
                                                          Alignment.center,
                                                      child:
                                                          ElevatedButton.icon(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          // Navigator.pop(
                                                          //     context);
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(
                                                            myTheme.colorScheme
                                                                .primary,
                                                          ),
                                                          shape: MaterialStateProperty
                                                              .all<
                                                                  RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          18.0),
                                                            ),
                                                          ),
                                                        ),
                                                        icon: Icon(
                                                          MaterialIcons
                                                              .arrow_back_ios,
                                                          size: 12,
                                                        ),
                                                        label: Text(
                                                          'Aceptar',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Poppins-regular',
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            });
                            // Navigator.pop(context);

                            // if (paidAmount < remaining && paymentBody != null) {
                            //   Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //       settings:
                            //           const RouteSettings(name: 'PAGO-DIRECTO'),
                            //       builder: (BuildContext context) =>
                            //           AddPaymentPage(
                            //         remaining: paymentBody.remaining,
                            //         subTotal: paymentBody.subTotal,
                            //         discountPercentage:
                            //             paymentBody.discountPercentage,
                            //         discount: paymentBody.discount,
                            //         tax: paymentBody.tax,
                            //         percentageTax: paymentBody.percentageTax,
                            //         client: paymentBody.client,
                            //         invoiceDocumentID:
                            //             paymentBody.invoiceDocumentID,
                            //         amountPayed:
                            //             (paymentBody.amountPaied ?? 0) +
                            //                 paidAmount,
                            //         // updatePayed: updatePayed,
                            //       ),
                            //     ),
                            //   );
                            // } else {
                            //   Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (BuildContext context) =>
                            //           CompletedPayPage(
                            //               client: client.name,
                            //               total: totalOfTheOrder,
                            //               method: "Efectivo",
                            //               date:
                            //                   '${date.day}-${date.month}-${date.year} ${(date as DateTime).hour}:${(date).minute}',
                            //               address: '',
                            //               coinsExchangeRates: const []),
                            //     ),
                            //   );
                            // }
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Ingrese Monto porfavor');
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: myTheme.colorScheme.primary,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.orderContinue,
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
              ),
            ],
          )
        ],
      ),
    );
  } else if (selectedValueA == 'Transferencia' ||
      selectedValueA == 'Transf-internacional') {
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
                      // ignore: prefer_const_literals_to_create_immutables
                      hint: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedBank ?? 'Seleccione una opción',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: myTheme.colorScheme.primary
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
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 11,
                      iconEnabledColor:
                          myTheme.colorScheme.primary.withOpacity(0.5),
                      iconDisabledColor: Colors.grey,
                      buttonHeight: 50,
                      // buttonWidth: 200,
                      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                      buttonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: myTheme.colorScheme.primary.withOpacity(0.3),
                        ),
                        color: Colors.white,
                      ),
                      buttonElevation: 0,
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 200,
                      dropdownWidth: 200,
                      dropdownPadding: null,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(10),
                      scrollbarThickness: 6,
                      scrollbarAlwaysShow: true,
                      offset: const Offset(0, 0),
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      // ignore: prefer_const_literals_to_create_immutables
                      hint: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedBank ?? 'Seleccione una opción',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: myTheme.colorScheme.primary
                                    .withOpacity(0.7),
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
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 11,
                      iconEnabledColor:
                          myTheme.colorScheme.primary.withOpacity(0.5),
                      iconDisabledColor: Colors.grey,
                      buttonHeight: 50,
                      // buttonWidth: 200,
                      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                      buttonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: myTheme.colorScheme.primary.withOpacity(0.3),
                        ),
                        color: Colors.white,
                      ),
                      buttonElevation: 0,
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 200,
                      dropdownWidth: 200,
                      dropdownPadding: null,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(10),
                      scrollbarThickness: 6,
                      scrollbarAlwaysShow: true,
                      offset: const Offset(0, 0),
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
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            height: 50,
            // width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: myTheme.colorScheme.primary.withOpacity(0.3),
                // color: Colors.transparent,
              ),
            ),
            child: TextField(
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.primary,
              ),
              keyboardType: TextInputType.phone,
              maxLines: 1,
              maxLength: 50,
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
                hintText: '00000000',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14,
                  color: myTheme.colorScheme.primary.withOpacity(0.2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                counterText: '',
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
                  var pickedFile = await getFromGallery(context);
                  if (pickedFile != null) {
                    print('Imagen seleccionada');
                    var croppedImage =
                        await cropImage(pickedFile.path, imageFile);
                    if (croppedImage != null) {
                      print('Imagen recortada');
                      setState(() {
                        imageFile = File(croppedImage.path);
                      });
                    } else {
                      print('Error croppeando');
                    }
                  } else {
                    print('error seleccionando');
                    return;
                  }
                },
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
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
                      AppLocalizations.of(context)!.gallery,
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
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: myTheme.colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.file(
                        imageFile!,
                        height: 300,
                        width: 300,
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
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() => imageFile = null);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          myTheme.colorScheme.primary,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                              // TODO: Temporalmente regresara a antes
                              if (selectedValueA == 'Transferencia') {
                                // Crear en DB una visita
                                // TODO: Temporalmente regresara a antes

                                if (selectedCoin != null) {
                                  if (paidAmount != null ||
                                      paidAmount != null ||
                                      paidAmount! <= totalOfTheOrder!) {
                                    if (selectedBank != null) {
                                      if (referenceId != '') {
                                        if (paidAmount! > remaining!) {
                                          Fluttertoast.showToast(
                                            msg:
                                                'La cantidad a pagar excede de la deuda pendiente',
                                            backgroundColor:
                                                myTheme.colorScheme.primary,
                                            textColor: Colors.white,
                                          );
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
                                              client: client,
                                              invoiceDocumentID:
                                                  invoiceDocumentID,
                                              currency: selectedCoin,
                                              amount: paidAmount,
                                              totalOfTheOrder: totalOfTheOrder,
                                              currentCoin: currentCoin,
                                              bank: selectedBank,
                                              referenceId: referenceId,
                                              imageFile: imageFile,
                                              date: date,
                                              remaining: remaining,
                                            ).whenComplete(() {
                                              Navigator.pop(context);
                                              Navigator.pop(context);

                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .all(18),
                                                              child: Center(
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      "¡PAGO REGISTRADO!",
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Poppins-regular',
                                                                        fontSize:
                                                                            18,
                                                                        color: myTheme
                                                                            .colorScheme
                                                                            .onPrimaryContainer,
                                                                        // color: Colors.green,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              15,
                                                                              0,
                                                                              0),
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: myTheme
                                                                              .colorScheme
                                                                              .primary
                                                                              .withOpacity(0.6)),
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      child: Opacity(
                                                                          opacity: 0.8,
                                                                          child: Icon(
                                                                            Icons.check,
                                                                            color:
                                                                                myTheme.colorScheme.onPrimaryContainer,
                                                                            size:
                                                                                50,
                                                                          )),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              0),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 10),
                                                                            child:
                                                                                Text(
                                                                              'Monto pagado: ${priceFormat(paidAmount)}',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins-regular',
                                                                                fontSize: 12,
                                                                                color: myTheme.colorScheme.primary,
                                                                                // color: Colors.green,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 10),
                                                                            child:
                                                                                Text(
                                                                              '${client!.name}',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins-regular',
                                                                                fontSize: 12,
                                                                                color: myTheme.colorScheme.primary,
                                                                                // color: Colors.green,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 10),
                                                                            child:
                                                                                Text(
                                                                              'Fecha: $date',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins-regular',
                                                                                fontSize: 12,
                                                                                color: myTheme.colorScheme.primary,
                                                                                // color: Colors.green,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 10),
                                                                            child:
                                                                                Text(
                                                                              '$selectedValueA',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins-regular',
                                                                                fontSize: 12,
                                                                                color: myTheme.colorScheme.primary,
                                                                                // color: Colors.green,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 50),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: ElevatedButton
                                                                          .icon(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          // Navigator.pop(
                                                                          //     context);
                                                                        },
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(
                                                                            myTheme.colorScheme.primary,
                                                                          ),
                                                                          shape:
                                                                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(18.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        icon:
                                                                            Icon(
                                                                          MaterialIcons
                                                                              .arrow_back_ios,
                                                                          size:
                                                                              12,
                                                                        ),
                                                                        label:
                                                                            Text(
                                                                          'Aceptar',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontFamily:
                                                                                'Poppins-regular',
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            });
                                          } catch (e) {
                                            print(e);
                                          }

                                          // Navigator.pop(context);
                                          // Navigator.pop(context);
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Ingrese datos de cuenta validos');
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'Seleccione un banco por favor');
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'Monto a pagar no valido');
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Complete los datos porfavor');
                                }
                              } else if (selectedValueA ==
                                  'Transf-internacional') {
                                if (selectedCoin != null) {
                                  if (paidAmount != null ||
                                      paidAmount != null ||
                                      paidAmount! <= totalOfTheOrder!) {
                                    if (selectedBank != null) {
                                      if (referenceId != '') {
                                        if (paidAmount! > remaining!) {
                                          Fluttertoast.showToast(
                                            msg:
                                                'La cantidad a pagar excede de la deuda pendiente',
                                            backgroundColor:
                                                myTheme.colorScheme.primary,
                                            textColor: Colors.white,
                                          );
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
                                              client: client,
                                              invoiceDocumentID:
                                                  invoiceDocumentID,
                                              currency: selectedCoin,
                                              amount: paidAmount,
                                              totalOfTheOrder: totalOfTheOrder,
                                              currentCoin: currentCoin,
                                              bank: selectedBank,
                                              referenceId: referenceId,
                                              imageFile: imageFile,
                                              date: date,
                                              remaining: remaining,
                                            ).whenComplete(() {
                                              Navigator.pop(context);
                                              Navigator.pop(context);

                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .all(18),
                                                              child: Center(
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      "¡PAGO REGISTRADO!",
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Poppins-regular',
                                                                        fontSize:
                                                                            18,
                                                                        color: myTheme
                                                                            .colorScheme
                                                                            .onPrimaryContainer,
                                                                        // color: Colors.green,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              15,
                                                                              0,
                                                                              0),
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: myTheme
                                                                              .colorScheme
                                                                              .primary
                                                                              .withOpacity(0.6)),
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      child: Opacity(
                                                                          opacity: 0.8,
                                                                          child: Icon(
                                                                            Icons.check,
                                                                            color:
                                                                                myTheme.colorScheme.onPrimaryContainer,
                                                                            size:
                                                                                50,
                                                                          )),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              0),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 10),
                                                                            child:
                                                                                Text(
                                                                              'Monto pagado: ${priceFormat(paidAmount)}',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins-regular',
                                                                                fontSize: 12,
                                                                                color: myTheme.colorScheme.primary,
                                                                                // color: Colors.green,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 10),
                                                                            child:
                                                                                Text(
                                                                              '${client!.name}',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins-regular',
                                                                                fontSize: 12,
                                                                                color: myTheme.colorScheme.primary,
                                                                                // color: Colors.green,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 10),
                                                                            child:
                                                                                Text(
                                                                              'Fecha: $date',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins-regular',
                                                                                fontSize: 12,
                                                                                color: myTheme.colorScheme.primary,
                                                                                // color: Colors.green,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 10),
                                                                            child:
                                                                                Text(
                                                                              '$selectedValueA',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins-regular',
                                                                                fontSize: 12,
                                                                                color: myTheme.colorScheme.primary,
                                                                                // color: Colors.green,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 50),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: ElevatedButton
                                                                          .icon(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          // Navigator.pop(
                                                                          //     context);
                                                                        },
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(
                                                                            myTheme.colorScheme.primary,
                                                                          ),
                                                                          shape:
                                                                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(18.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        icon:
                                                                            Icon(
                                                                          MaterialIcons
                                                                              .arrow_back_ios,
                                                                          size:
                                                                              12,
                                                                        ),
                                                                        label:
                                                                            Text(
                                                                          'Aceptar',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontFamily:
                                                                                'Poppins-regular',
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            });
                                          } catch (e) {
                                            print(e);
                                          }
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Ingrese datos de cuenta validos');
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'Seleccione un banco por favor');
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'Monto a pagar no valido');
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Complete los datos porfavor');
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
}
// }
