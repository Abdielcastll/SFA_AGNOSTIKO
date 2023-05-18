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

Future getFromGallery(context) async {
  try {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile;
    } else {
      return;
    }
  } on PlatformException catch (e) {
    print('ERROR ESCOGIENDO IMAGEN');
    print(e);
  }
}

Future getFromCamera(context) async {
  try {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return pickedFile;
    } else {
      return;
    }
  } on PlatformException catch (e) {
    print('ERROR ESCOGIENDO IMAGEN');
    print(e);
  }
}

Future cropImage(filePath, imageFile) async {
  CroppedFile? croppedImage = await ImageCropper().cropImage(
    sourcePath: filePath,
    maxHeight: 1080,
    maxWidth: 1080,
  );
  if (croppedImage != null) {
    return croppedImage;
  }
}

identifyPaymentMethodRetail({
  String? coinName,
  int? coinDecimals,
  double? coinExchangeRatio,
  String? coinSymbol,
  String? coinCode,
  required String selectedValueA,
  required String invoiceDocumentID,
  required String selectedCoin,
  required Client client,
  required double moneyRecievedForRegisterMoney,
  required double paidAmount,
  required double totalOfTheOrder,
  required double remaining,
  required double remainingConverted,
  required DateTime date,
  context,
  required Function updatePayed,
  required AddPaymentBodyAtt paymentBody,
  noRetail = false,
}) {
  print('amountToPay IDENTIFY $paidAmount');
  print('selectedCoin IDENTIFY $selectedCoin');
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
  final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;

  final amountExchanged = priceDividedbyItsExchangeRatio(
    amount: paidAmount,
    exchange: coinExchangeRatio,
  );

  final totalPayed = paymentBody.payments.fold<double>(
      0.0, (previousValue, element) => previousValue + element.amount);

  print('Metodo: $selectedValueA');
  print('currentCoin: $currentCoin');
  print('totalOfTheOrder: $totalOfTheOrder');
  print('paidAmount: $paidAmount');
  print('remaining: $remaining');
  print('amountExCHANGED $amountExchanged');

  if (selectedValueA == 'Tarjeta de Debito' ||
      selectedValueA == 'Tarjeta de Credito') {
    if (paidAmount is String) {
      paidAmount = double.parse(paidAmount.toString().replaceAll('\$', ''));
    }
    // return paymentCard(paidAmount, client, invoiceDocumentID, totalOfTheOrder,
    //     selectedCoin, date, remaining, coinExchangeRatio,
    //     updatePayed: updatePayed, paymentBody: paymentBody, noRetail: noRetail);
    return paymentCard(
      paidAmount,
      client,
      invoiceDocumentID,
      totalOfTheOrder,
      selectedCoin,
      date,
      remaining,
      // remainingConverted,
      coinExchangeRatio,
      updatePayed: updatePayed,
      paymentBody: paymentBody,
      noRetail: noRetail,
    );
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
              color: Colors.white,
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
              color: Colors.white,
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
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.camera_alt,
                              color: myTheme.colorScheme.onPrimaryContainer,
                            ),
                            title: Text(
                              'Camara',
                              style: TextStyle(
                                color: myTheme.colorScheme.primary,
                                fontFamily: 'Poppins-regular',
                              ),
                            ),
                            onTap: () async {
                              Navigator.of(context).pop();
                              var pickedFile = await getFromCamera(context);
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
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(
                              Icons.photo_camera_back_rounded,
                              color: myTheme.colorScheme.onPrimaryContainer,
                            ),
                            title: Text(
                              'Galeria',
                              style: TextStyle(
                                color: myTheme.colorScheme.primary,
                                fontFamily: 'Poppins-regular',
                              ),
                            ),
                            onTap: () async {
                              Navigator.of(context).pop();
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
                          ),
                        ],
                      );
                    },
                  );
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
                        ),
                      ),
                    ),
              Row(
                mainAxisAlignment: paidAmount == 0
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceAround,
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
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (selectedBank == null) {
                                Fluttertoast.showToast(
                                    msg: 'Seleccione un banco por favor');
                              } else {
                                if (accountNumber == '' &&
                                    accountHolder == '') {
                                  Fluttertoast.showToast(
                                      msg: 'Ingrese datos de cuenta validos');
                                } else {
                                  print('Registrando pago en cheque');
                                  print('Cantidad permitida');

                                  Fluttertoast.showToast(
                                    msg: 'Registrando Cheque',
                                    backgroundColor:
                                        myTheme.colorScheme.primary,
                                    textColor: Colors.white,
                                  );

                                  try {
                                    await registerBankCheckPayment(
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
                                      accountHolder: accountHolder,
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
                                        .add(PayMethod('Cheque', paidAmount));

                                    print('amountExCHANGED $amountExchanged');

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
                                            method: "Cheque",
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
    // return StatefulBuilder(builder: (context, setState) {
    //   return Column(
    //     children: [
    //       Text(
    //         '${AppLocalizations.of(context)!.transactionID} *',
    //         style: TextStyle(
    //           fontFamily: 'Poppins-regular',
    //           color: myTheme.colorScheme.secondary,
    //           fontSize: 14,
    //         ),
    //       ),
    //       Container(
    //         margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
    //         height: 50,
    //         // width: 200,
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(10),
    //           border: Border.all(
    //             color: myTheme.colorScheme.primary.withOpacity(0.3),
    //             // color: Colors.transparent,
    //           ),
    //         ),
    //         child: TextField(
    //           style: TextStyle(
    //             fontSize: 14,
    //             fontFamily: 'Poppins-regular',
    //             color: myTheme.colorScheme.primary,
    //           ),
    //           keyboardType: TextInputType.phone,
    //           maxLines: 1,
    //           maxLength: 50,
    //           textCapitalization: TextCapitalization.characters,
    //           inputFormatters: [
    //             FilteringTextInputFormatter.digitsOnly,
    //           ],
    //           onChanged: (value) {
    //             transactionId = value;
    //             print(transactionId);
    //           },

    //           decoration: InputDecoration(
    //             contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
    //             hintText: '00000000',
    //             hintStyle: TextStyle(
    //               fontFamily: 'Poppins-regular',
    //               fontSize: 14,
    //               color: myTheme.colorScheme.primary.withOpacity(0.2),
    //             ),
    //             enabledBorder: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(5),
    //               borderSide: BorderSide(
    //                 color: Colors.transparent,
    //               ),
    //             ),
    //             counterText: '',
    //             border: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(5),
    //               borderSide: BorderSide(
    //                 color: Colors.transparent,
    //               ),
    //             ),
    //           ),
    //           // onChanged: searchClient,
    //         ),
    //       ),
    //       Column(
    //         children: [
    //           Text(
    //             AppLocalizations.of(context)!.selectFile,
    //             style: TextStyle(
    //               fontFamily: 'Poppins-regular',
    //               color: Colors.grey.shade400,
    //               fontSize: 14,
    //             ),
    //           ),
    //           InkWell(
    //             onTap: () async {
    //               showModalBottomSheet(
    //                 context: context,
    //                 builder: (context) {
    //                   return Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                       ListTile(
    //                         leading: Icon(
    //                           Icons.camera_alt,
    //                           color: myTheme.colorScheme.onPrimaryContainer,
    //                         ),
    //                         title: Text(
    //                           'Camara',
    //                           style: TextStyle(
    //                             color: myTheme.colorScheme.primary,
    //                             fontFamily: 'Poppins-regular',
    //                           ),
    //                         ),
    //                         onTap: () async {
    //                           Navigator.of(context).pop();
    //                           var pickedFile = await getFromCamera(context);
    //                           if (pickedFile != null) {
    //                             print('Imagen seleccionada');
    //                             var croppedImage =
    //                                 await cropImage(pickedFile.path, imageFile);
    //                             if (croppedImage != null) {
    //                               print('Imagen recortada');
    //                               setState(() {
    //                                 imageFile = File(croppedImage.path);
    //                               });
    //                             } else {
    //                               print('Error croppeando');
    //                             }
    //                           } else {
    //                             print('error seleccionando');
    //                             return;
    //                           }
    //                         },
    //                       ),
    //                       Divider(),
    //                       ListTile(
    //                         leading: Icon(
    //                           Icons.photo_camera_back_rounded,
    //                           color: myTheme.colorScheme.onPrimaryContainer,
    //                         ),
    //                         title: Text(
    //                           'Galeria',
    //                           style: TextStyle(
    //                             color: myTheme.colorScheme.primary,
    //                             fontFamily: 'Poppins-regular',
    //                           ),
    //                         ),
    //                         onTap: () async {
    //                           Navigator.of(context).pop();
    //                           var pickedFile = await getFromGallery(context);
    //                           if (pickedFile != null) {
    //                             print('Imagen seleccionada');
    //                             var croppedImage =
    //                                 await cropImage(pickedFile.path, imageFile);
    //                             if (croppedImage != null) {
    //                               print('Imagen recortada');
    //                               setState(() {
    //                                 imageFile = File(croppedImage.path);
    //                               });
    //                             } else {
    //                               print('Error croppeando');
    //                             }
    //                           } else {
    //                             print('error seleccionando');
    //                             return;
    //                           }
    //                         },
    //                       ),
    //                     ],
    //                   );
    //                 },
    //               );
    //             },
    //             child: Row(
    //               // ignore: prefer_const_literals_to_create_immutables
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Padding(
    //                   padding: EdgeInsets.all(4.0),
    //                   child: Icon(
    //                     Icons.camera,
    //                     color: myTheme.colorScheme.secondary,
    //                   ),
    //                 ),
    //                 Text(
    //                   // AppLocalizations.of(context)!.gallery,
    //                   'Subir Imagen',
    //                   style: TextStyle(
    //                     color: myTheme.colorScheme.primary,
    //                     fontFamily: 'Poppins-regular',
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           imageFile == null
    //               ? Container()
    //               : Container(
    //                   margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
    //                   // height: 300,
    //                   // width: 300,
    //                   decoration: BoxDecoration(
    //                     border: Border.all(
    //                       color: myTheme.colorScheme.primary,
    //                     ),
    //                     borderRadius: BorderRadius.circular(10),
    //                   ),
    //                   child: ClipRRect(
    //                     borderRadius: BorderRadius.circular(9),
    //                     child: Image.file(
    //                       imageFile!,
    //                       fit: BoxFit.contain,
    //                       // height: 300,
    //                       // width: 300,
    //                     ),
    //                   ),
    //                 ),
    //           Container(
    //             alignment: Alignment.bottomCenter,
    //             margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.end,
    //               children: [
    //                 TextButton(
    //                   onPressed: () {
    //                     Navigator.pop(context);
    //                     setState(() => imageFile = null);
    //                   },
    //                   child: Text(
    //                     AppLocalizations.of(context)!.goBack,
    //                     style: TextStyle(
    //                       fontFamily: 'Poppins-regular',
    //                       color: myTheme.colorScheme.primary,
    //                       fontSize: 14,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 100,
    //                   height: 40,
    //                   decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(16),
    //                       color: myTheme.colorScheme.primary),
    //                   child: TextButton(
    //                     onPressed: () async {
    //                       // Crear en DB una visita
    //                       if (transactionId != '') {
    //                         if (paidAmount != null) {
    //                           /* if (exchangeAmount(selectedCoin, paidAmount) >
    //                               remaining) {
    //                             Fluttertoast.showToast(
    //                               msg:
    //                                   'La cantidad a pagar excede de la deuda pendiente',
    //                               backgroundColor: myTheme.colorScheme.primary,
    //                               textColor: Colors.white,
    //                             );
    //                           } else { */
    //                           print('Cantidad permitida');
    //                           Fluttertoast.showToast(
    //                             msg: 'Registrando Pago en Criptomonedas',
    //                             backgroundColor: myTheme.colorScheme.primary,
    //                             textColor: Colors.white,
    //                           );

    //                           try {
    //                             // await registerCriptoPayment(
    //                             //   client!,
    //                             //   invoiceDocumentID,
    //                             //   'BTC',
    //                             //   paidAmount,
    //                             //   totalOfTheOrder,
    //                             //   transactionId,
    //                             //   imageFile,
    //                             //   date,
    //                             //   remaining,
    //                             // );

    //                             // paymentBody.payments.add(
    //                             //     PayMethod('Criptomoneda', amountExchanged));

    //                             // print('IDENTIFY PAYMENTS');
    //                             // print(paymentBody?.payments.length);

    //                             if (amountExchanged <
    //                                 double.parse(
    //                                     (remaining).toStringAsFixed(4))) {
    //                               showDialog(
    //                                   context: context,
    //                                   builder: (BuildContext context) {
    //                                     return AlertDialog(
    //                                       contentPadding: EdgeInsets.zero,
    //                                       shape: RoundedRectangleBorder(
    //                                         borderRadius:
    //                                             BorderRadius.circular(20),
    //                                       ),
    //                                       content: SingleChildScrollView(
    //                                         child: Stack(
    //                                           children: [
    //                                             Container(
    //                                               height: 400,
    //                                               width: 300,
    //                                               child: Opacity(
    //                                                 opacity: 1,
    //                                                 child: ClipRRect(
    //                                                   borderRadius:
    //                                                       BorderRadius.circular(
    //                                                           20),
    //                                                   child: Image.asset(
    //                                                     'assets/images/payment-background.png',
    //                                                     fit: BoxFit.fill,
    //                                                   ),
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                             Container(
    //                                               margin: EdgeInsets.all(18),
    //                                               child: Center(
    //                                                 child: Column(
    //                                                   children: [
    //                                                     Text(
    //                                                       "¡PAGO REGISTRADO!",
    //                                                       style: TextStyle(
    //                                                         fontFamily:
    //                                                             'Poppins-regular',
    //                                                         fontSize: 18,
    //                                                         color: myTheme
    //                                                             .colorScheme
    //                                                             .onPrimaryContainer,
    //                                                         // color: Colors.green,
    //                                                         fontWeight:
    //                                                             FontWeight.bold,
    //                                                       ),
    //                                                     ),
    //                                                     Container(
    //                                                       margin: EdgeInsets
    //                                                           .fromLTRB(
    //                                                               0, 15, 0, 0),
    //                                                       decoration: BoxDecoration(
    //                                                           shape: BoxShape
    //                                                               .circle,
    //                                                           color: myTheme
    //                                                               .colorScheme
    //                                                               .primary
    //                                                               .withOpacity(
    //                                                                   0.6)),
    //                                                       width: 100,
    //                                                       height: 100,
    //                                                       child: Opacity(
    //                                                           opacity: 0.8,
    //                                                           child: Icon(
    //                                                             Icons.check,
    //                                                             color: myTheme
    //                                                                 .colorScheme
    //                                                                 .onPrimaryContainer,
    //                                                             size: 50,
    //                                                           )),
    //                                                     ),
    //                                                     Container(
    //                                                       margin: EdgeInsets
    //                                                           .fromLTRB(
    //                                                               0, 10, 0, 0),
    //                                                       alignment:
    //                                                           Alignment.center,
    //                                                       child: Column(
    //                                                         mainAxisAlignment:
    //                                                             MainAxisAlignment
    //                                                                 .center,
    //                                                         crossAxisAlignment:
    //                                                             CrossAxisAlignment
    //                                                                 .center,
    //                                                         children: [
    //                                                           Container(
    //                                                             margin: EdgeInsets
    //                                                                 .only(
    //                                                                     top:
    //                                                                         10),
    //                                                             child: Text(
    //                                                               'Monto pagado: $coinSymbol $paidAmount',
    //                                                               style:
    //                                                                   TextStyle(
    //                                                                 fontFamily:
    //                                                                     'Poppins-regular',
    //                                                                 fontSize:
    //                                                                     12,
    //                                                                 color: myTheme
    //                                                                     .colorScheme
    //                                                                     .primary,
    //                                                                 // color: Colors.green,
    //                                                                 fontWeight:
    //                                                                     FontWeight
    //                                                                         .bold,
    //                                                               ),
    //                                                             ),
    //                                                           ),
    //                                                           Container(
    //                                                             margin: EdgeInsets
    //                                                                 .only(
    //                                                                     top:
    //                                                                         10),
    //                                                             child: Text(
    //                                                               '${client!.name}',
    //                                                               style:
    //                                                                   TextStyle(
    //                                                                 fontFamily:
    //                                                                     'Poppins-regular',
    //                                                                 fontSize:
    //                                                                     12,
    //                                                                 color: myTheme
    //                                                                     .colorScheme
    //                                                                     .primary,
    //                                                                 // color: Colors.green,
    //                                                                 fontWeight:
    //                                                                     FontWeight
    //                                                                         .bold,
    //                                                               ),
    //                                                             ),
    //                                                           ),
    //                                                           Container(
    //                                                             margin: EdgeInsets
    //                                                                 .only(
    //                                                                     top:
    //                                                                         10),
    //                                                             child: Text(
    //                                                               'Fecha: $date',
    //                                                               style:
    //                                                                   TextStyle(
    //                                                                 fontFamily:
    //                                                                     'Poppins-regular',
    //                                                                 fontSize:
    //                                                                     12,
    //                                                                 color: myTheme
    //                                                                     .colorScheme
    //                                                                     .primary,
    //                                                                 // color: Colors.green,
    //                                                                 fontWeight:
    //                                                                     FontWeight
    //                                                                         .bold,
    //                                                               ),
    //                                                             ),
    //                                                           ),
    //                                                           Container(
    //                                                             margin: EdgeInsets
    //                                                                 .only(
    //                                                                     top:
    //                                                                         10),
    //                                                             child: Text(
    //                                                               '$selectedValueA',
    //                                                               style:
    //                                                                   TextStyle(
    //                                                                 fontFamily:
    //                                                                     'Poppins-regular',
    //                                                                 fontSize:
    //                                                                     12,
    //                                                                 color: myTheme
    //                                                                     .colorScheme
    //                                                                     .primary,
    //                                                                 // color: Colors.green,
    //                                                                 fontWeight:
    //                                                                     FontWeight
    //                                                                         .bold,
    //                                                               ),
    //                                                             ),
    //                                                           ),
    //                                                         ],
    //                                                       ),
    //                                                     ),
    //                                                     Container(
    //                                                       margin:
    //                                                           EdgeInsets.only(
    //                                                               top: 50),
    //                                                       alignment:
    //                                                           Alignment.center,
    //                                                       child: ElevatedButton
    //                                                           .icon(
    //                                                         onPressed: () {
    //                                                           print(
    //                                                               'paymentBody.payments:${paymentBody.payments}');
    //                                                           // Navigator
    //                                                           //     .pushReplacement(
    //                                                           //   context,
    //                                                           //   MaterialPageRoute(
    //                                                           //       settings:
    //                                                           //           const RouteSettings(
    //                                                           //               name:
    //                                                           //                   'PAGO-DIRECTO'),
    //                                                           //       builder: (BuildContext
    //                                                           //               context) =>
    //                                                           //           AddPaymentPage(
    //                                                           //             remaining:
    //                                                           //                 paymentBody.remaining - amountExchanged,
    //                                                           //             subTotal:
    //                                                           //                 paymentBody.subTotal,
    //                                                           //             discountPercentage:
    //                                                           //                 paymentBody.discountPercentage,
    //                                                           //             discount:
    //                                                           //                 paymentBody.discount,
    //                                                           //             tax: paymentBody
    //                                                           //                 .tax,
    //                                                           //             percentageTax:
    //                                                           //                 paymentBody.percentageTax,
    //                                                           //             client:
    //                                                           //                 paymentBody.client,
    //                                                           //             invoiceDocumentID:
    //                                                           //                 paymentBody.invoiceDocumentID,
    //                                                           //             invoiceNumber:
    //                                                           //                 paymentBody.invoiceNumber,
    //                                                           //             amountPayed:
    //                                                           //                 (paymentBody.amountPaied ?? 0) + amountExchanged,
    //                                                           //             payments:
    //                                                           //                 paymentBody.payments,
    //                                                           //             // updatePayed: updatePayed,
    //                                                           //           )),
    //                                                           // );
    //                                                           // Navigator.pop(
    //                                                           //     context);
    //                                                         },
    //                                                         style: ButtonStyle(
    //                                                           backgroundColor:
    //                                                               MaterialStateProperty
    //                                                                   .all(
    //                                                             myTheme
    //                                                                 .colorScheme
    //                                                                 .primary,
    //                                                           ),
    //                                                           shape: MaterialStateProperty
    //                                                               .all<
    //                                                                   RoundedRectangleBorder>(
    //                                                             RoundedRectangleBorder(
    //                                                               borderRadius:
    //                                                                   BorderRadius
    //                                                                       .circular(
    //                                                                           18.0),
    //                                                             ),
    //                                                           ),
    //                                                         ),
    //                                                         icon: Icon(
    //                                                           MaterialIcons
    //                                                               .arrow_back_ios,
    //                                                           size: 12,
    //                                                         ),
    //                                                         label: Text(
    //                                                           'Aceptar',
    //                                                           style: TextStyle(
    //                                                             color: Colors
    //                                                                 .white,
    //                                                             fontFamily:
    //                                                                 'Poppins-regular',
    //                                                             fontSize: 12,
    //                                                             fontWeight:
    //                                                                 FontWeight
    //                                                                     .bold,
    //                                                           ),
    //                                                         ),
    //                                                       ),
    //                                                     )
    //                                                   ],
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                     );
    //                                   });
    //                             } else {
    //                               Navigator.pushReplacement(
    //                                 context,
    //                                 MaterialPageRoute(
    //                                   builder: (BuildContext context) =>
    //                                       CompletedPayPage(
    //                                           client: client,
    //                                           total:
    //                                               totalPayed + amountExchanged,
    //                                           method: "Criptomoneda",
    //                                           date:
    //                                               '${date.day}-${date.month}-${date.year} ${(date as DateTime).hour}:${(date).minute}',
    //                                           address: '',
    //                                           coinsExchangeRates: const [],
    //                                           addPaymentBody: paymentBody),
    //                                 ),
    //                               );
    //                             }
    //                           } catch (e) {
    //                             print(e);
    //                           }
    //                           /* } */
    //                         }
    //                       } else {
    //                         Fluttertoast.showToast(msg: 'Ingrese ID porfavor');
    //                       }
    //                     },
    //                     style: TextButton.styleFrom(
    //                       foregroundColor: myTheme.colorScheme.primary,
    //                     ),
    //                     child: Text(
    //                       AppLocalizations.of(context)!.orderContinue,
    //                       style: TextStyle(
    //                         fontFamily: 'Poppins-regular',
    //                         color: Colors.white,
    //                         fontSize: 14,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       )
    //     ],
    //   );
    // });
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
              color: myTheme.colorScheme.primary,
              fontSize: 14,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            height: 50,
            // width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
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
              color: Colors.white,
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
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.camera_alt,
                              color: myTheme.colorScheme.onPrimaryContainer,
                            ),
                            title: Text(
                              'Camara',
                              style: TextStyle(
                                color: myTheme.colorScheme.primary,
                                fontFamily: 'Poppins-regular',
                              ),
                            ),
                            onTap: () async {
                              Navigator.of(context).pop();
                              var pickedFile = await getFromCamera(context);
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
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(
                              Icons.photo_camera_back_rounded,
                              color: myTheme.colorScheme.onPrimaryContainer,
                            ),
                            title: Text(
                              'Galeria',
                              style: TextStyle(
                                color: myTheme.colorScheme.primary,
                                fontFamily: 'Poppins-regular',
                              ),
                            ),
                            onTap: () async {
                              Navigator.of(context).pop();
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
                          ),
                        ],
                      );
                    },
                  );
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
                                    msg: 'Registrando Deposito',
                                    backgroundColor:
                                        myTheme.colorScheme.primary,
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
          // selectedValueA == 'Nota de credito'
          //     ? Container(
          //         child: Text(
          //           'Disponible en Nota de Credito: \$0.00',
          //           style: TextStyle(
          //             fontFamily: 'Poppins-regular',
          //             color: myTheme.colorScheme.secondary,
          //             fontSize: 14,
          //           ),
          //         ),
          //       )
          //     : Container(),
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
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.camera_alt,
                              color: myTheme.colorScheme.onPrimaryContainer,
                            ),
                            title: Text(
                              'Camara',
                              style: TextStyle(
                                color: myTheme.colorScheme.primary,
                                fontFamily: 'Poppins-regular',
                              ),
                            ),
                            onTap: () async {
                              Navigator.of(context).pop();
                              var pickedFile = await getFromCamera(context);
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
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(
                              Icons.photo_camera_back_rounded,
                              color: myTheme.colorScheme.onPrimaryContainer,
                            ),
                            title: Text(
                              'Galeria',
                              style: TextStyle(
                                color: myTheme.colorScheme.primary,
                                fontFamily: 'Poppins-regular',
                              ),
                            ),
                            onTap: () async {
                              Navigator.of(context).pop();
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
                          ),
                        ],
                      );
                    },
                  );
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
                  mainAxisAlignment: moneyRecievedForRegisterMoney < paidAmount
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                                    backgroundColor:
                                        myTheme.colorScheme.primary,
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
                                  MaterialCommunityIcons.hand_coin,
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
                          thumbVisibility:
                              MaterialStateProperty.all<bool>(true),
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
                          thumbVisibility:
                              MaterialStateProperty.all<bool>(true),
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
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            height: 50,
            // width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
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
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.camera_alt,
                              color: myTheme.colorScheme.onPrimaryContainer,
                            ),
                            title: Text(
                              'Camara',
                              style: TextStyle(
                                color: myTheme.colorScheme.primary,
                                fontFamily: 'Poppins-regular',
                              ),
                            ),
                            onTap: () async {
                              Navigator.of(context).pop();
                              var pickedFile = await getFromCamera(context);
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
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(
                              Icons.photo_camera_back_rounded,
                              color: myTheme.colorScheme.onPrimaryContainer,
                            ),
                            title: Text(
                              'Galeria',
                              style: TextStyle(
                                color: myTheme.colorScheme.primary,
                                fontFamily: 'Poppins-regular',
                              ),
                            ),
                            onTap: () async {
                              Navigator.of(context).pop();
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
                          ),
                        ],
                      );
                    },
                  );
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
                                      paymentBody.payments.add(PayMethod(
                                          'Transferencia', paidAmount));
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
}

Future<dynamic> showDialogForConfirmedPaymentRetail(
    BuildContext context,
    String? coinSymbol,
    double paidAmount,
    Client client,
    DateTime date,
    String selectedValueA,
    AddPaymentBodyAtt paymentBody,
    double amountExchanged,
    double totalOfTheOrder) {
  return showDialog(
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
                            fontFamily: 'Poppins-regular',
                            fontSize: 18,
                            color: myTheme.colorScheme.onPrimaryContainer,
                            // color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  myTheme.colorScheme.primary.withOpacity(0.6)),
                          width: 100,
                          height: 100,
                          child: Opacity(
                              opacity: 0.8,
                              child: Icon(
                                Icons.check,
                                color: myTheme.colorScheme.onPrimaryContainer,
                                size: 50,
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  'Monto pagado: $coinSymbol ${paidAmount.toStringAsFixed(2)}',
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
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  '${client.name}',
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
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
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
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
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
                          margin: EdgeInsets.only(top: 50),
                          alignment: Alignment.center,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              print(
                                  'paymentBody.payments:${paymentBody.payments}');
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    settings: const RouteSettings(
                                        name: 'PAGO-DIRECTO'),
                                    builder: (BuildContext context) =>
                                        AddPaymentPage(
                                          remaining: paymentBody.remaining -
                                              amountExchanged,
                                          subTotal: paymentBody.subTotal,
                                          discountPercentage:
                                              paymentBody.discountPercentage,
                                          discount: paymentBody.discount,
                                          tax: paymentBody.tax,
                                          percentageTax:
                                              paymentBody.percentageTax,
                                          client: paymentBody.client,
                                          invoiceDocumentID:
                                              paymentBody.invoiceDocumentID,
                                          invoiceNumber:
                                              paymentBody.invoiceNumber,
                                          amountPayed:
                                              (paymentBody.amountPaied ?? 0) +
                                                  amountExchanged,
                                          payments: paymentBody.payments,
                                          invoiceTotal: totalOfTheOrder,
                                          // updatePayed: updatePayed,
                                        )),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                myTheme.colorScheme.primary,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            icon: Icon(
                              MaterialIcons.arrow_back_ios,
                              size: 12,
                            ),
                            label: Text(
                              'Aceptar',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins-regular',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
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
}
// }
