// ignore_for_file: prefer_const_constructors
import 'dart:math' as math;

import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/identify_payment_method.dart';

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
) {
  final paidAmount = TextEditingController();
  var dateFormatter = DateFormat('dd-MM-yyyy');
  DateTime today = DateTime.now();
  String? selectedValueA;
  File? imageFile;
  final paymentsValidPay = invoicePayments
      .where((element) =>
          element['conciliado'] == true && element['anulado'] == false)
      .toList();
  // print(paymentsValidPay);
  var sumOfValidPayments = paymentsValidPay.fold(0, (i, element) {
    return i + element['monto'];
  });
  print(sumOfValidPayments);
  final remaining = invoiceTotal - sumOfValidPayments;
  final leftoverAmount;
  if (remaining < 0) {
    leftoverAmount = 0.00;
  } else {
    leftoverAmount = remaining;
  }

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
      return StatefulBuilder(
        builder: (context, setState) {
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
                        'Opciones',
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
                                      ),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: myTheme.colorScheme.primary,
                                ),
                                child: Text(
                                  'Ver Cliente',
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
                                                'Pago de factura #$invoiceNumber',
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
                                                        width: 300,
                                                        height: 300,
                                                        child:
                                                            invoicePayments
                                                                    .isEmpty
                                                                ? Container(
                                                                    width: 300,
                                                                    height: 300,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      'No hay pagos registrados',
                                                                    ),
                                                                  )
                                                                : Scrollbar(
                                                                    child: ListView
                                                                        .builder(
                                                                            itemCount:
                                                                                invoicePayments.length,
                                                                            itemBuilder: (context, index) {
                                                                              final payment = invoicePayments[index];
                                                                              final date = payment['fecha'];
                                                                              final unformattedDate = DateTime.parse(date.toDate().toString());
                                                                              final paymentDate = dateFormatter.format(unformattedDate);
                                                                              return ListTile(
                                                                                leading: Icon(
                                                                                  Icons.money_off_csred,
                                                                                  color: payment['anulado'] == false ? Colors.green : Colors.red,
                                                                                ),
                                                                                title: Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      '\$ ${payment['monto']}',
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'Poppins-regular',
                                                                                        color: Colors.grey.shade400,
                                                                                        fontSize: 14,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                                                                                      child: Text(
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
                                                                                subtitle: Text(
                                                                                  '${payment['metodo']}',
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'Poppins-regular',
                                                                                    color: Colors.grey.shade400,
                                                                                    fontSize: 12,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }),
                                                                  ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 30),
                                                    Text(
                                                      'Restante en USD: \$${remaining.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-regular',
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    // Text(
                                                    //   'Se genero NC: #25',
                                                    //   style: TextStyle(
                                                    //     fontFamily:
                                                    //         'Poppins-regular',
                                                    //     color: Colors.black,
                                                    //     fontSize: 12,
                                                    //     fontWeight:
                                                    //         FontWeight.bold,
                                                    //   ),
                                                    // ),
                                                    Text(
                                                      'Saldo confimado: \$$sumOfValidPayments',
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
                                                      'Por conciliar: \$$leftoverAmount',
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
                                                          'Regresar',
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
                                  'Ver pagos',
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
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        String formattedDate =
                                            dateFormatter.format(today);
                                        final List<String> items = [
                                          'Cheque',
                                          'Criptomoneda',
                                          'Deposito',
                                          'Efectivo',
                                          'Transferencia',
                                          'Transf-internacional',
                                          'Nota de credito',
                                        ];
                                        return StatefulBuilder(
                                          builder: ((context, setState) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              title: Text(
                                                'Registrar pago',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  color: Color.fromARGB(
                                                      255, 0, 24, 143),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              content: Container(
                                                // height: 150,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Metodo de Pago',
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
                                                                        '',
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
                                                            buttonWidth: 200,
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
                                                                200,
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
                                                                    -20, 0),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        'Fecha',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-regular',
                                                          color: myTheme
                                                              .colorScheme
                                                              .secondary,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 5, 10, 10),
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
                                                                  // Seleccionar fecha
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
                                                                            2023),
                                                                  );
                                                                  if (newDate ==
                                                                      null) {
                                                                    return;
                                                                  }
                                                                  setState(() {
                                                                    today =
                                                                        newDate;
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
                                                      Text(
                                                        'Monto *',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-regular',
                                                          color: myTheme
                                                              .colorScheme
                                                              .secondary,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 10, 0, 0),
                                                        height: 50,
                                                        // width: 200,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                            color: myTheme
                                                                .colorScheme
                                                                .primary
                                                                .withOpacity(
                                                                    0.3),
                                                            // color: Colors.transparent,
                                                          ),
                                                        ),
                                                        child: TextField(
                                                          style: TextStyle(
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
                                                                .allow(RegExp(
                                                                    r'[0-9]+[,.]{0,1}[0-9]*')),
                                                            TextInputFormatter
                                                                .withFunction(
                                                              (oldValue,
                                                                      newValue) =>
                                                                  newValue
                                                                      .copyWith(
                                                                text: newValue
                                                                    .text
                                                                    .replaceAll(
                                                                        '.',
                                                                        ','),
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
                                                          controller:
                                                              paidAmount,

                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                              14,
                                                              0,
                                                              0,
                                                              0,
                                                            ),
                                                            hintText:
                                                                '00000000',
                                                            hintStyle:
                                                                TextStyle(
                                                              fontFamily:
                                                                  'Poppins-regular',
                                                              fontSize: 14,
                                                              color: myTheme
                                                                  .colorScheme
                                                                  .primary
                                                                  .withOpacity(
                                                                      0.2),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                              ),
                                                            ),
                                                            counterText: '',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                              ),
                                                            ),
                                                          ),
                                                          // onChanged: searchClient,
                                                        ),
                                                      ),
                                                      Container(
                                                        child:
                                                            identifyPaymentMethod(
                                                                selectedValueA),
                                                      ),
                                                      Text(
                                                        'Seleccione un archivo',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-regular',
                                                          color: Colors
                                                              .grey.shade400,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          var pickedFile =
                                                              await getFromGallery(
                                                                  context);
                                                          if (pickedFile !=
                                                              null) {
                                                            print(
                                                                'Imagen seleccionada');
                                                            var croppedImage =
                                                                await cropImage(
                                                                    pickedFile
                                                                        .path,
                                                                    imageFile);
                                                            if (croppedImage !=
                                                                null) {
                                                              print(
                                                                  'Imagen recortada');
                                                              setState(() {
                                                                imageFile = File(
                                                                    croppedImage
                                                                        .path);
                                                              });
                                                            } else {
                                                              print(
                                                                  'Error croppeando');
                                                            }
                                                          } else {
                                                            print(
                                                                'error seleccionando');
                                                            return;
                                                          }
                                                        },
                                                        child: Row(
                                                          // ignore: prefer_const_literals_to_create_immutables
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: Icon(
                                                                Icons.camera,
                                                                color: myTheme
                                                                    .colorScheme
                                                                    .secondary,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Galeria',
                                                              style: TextStyle(
                                                                color: myTheme
                                                                    .colorScheme
                                                                    .primary,
                                                                fontFamily:
                                                                    'Poppins-regular',
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
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: myTheme
                                                                      .colorScheme
                                                                      .primary,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Image.file(
                                                                imageFile!,
                                                                height: 300,
                                                                width: 300,
                                                              ),
                                                            ),
                                                      Container(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 0, 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                setState(() =>
                                                                    imageFile =
                                                                        null);
                                                              },
                                                              child: Text(
                                                                'Regresar',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Poppins-regular',
                                                                  color: myTheme
                                                                      .colorScheme
                                                                      .primary,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 100,
                                                              height: 40,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                  color: myTheme
                                                                      .colorScheme
                                                                      .primary),
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  // Crear en DB una visita
                                                                  // TODO: Temporalmente regresara a antes
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              'Testeo de crear pago completado');
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      myTheme
                                                                          .colorScheme
                                                                          .primary,
                                                                ),
                                                                child: Text(
                                                                  'Aceptar',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Poppins-regular',
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
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
                                    'Registrar pago',
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
