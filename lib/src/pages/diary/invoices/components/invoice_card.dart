// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class InvoiceCard extends StatefulWidget {
  const InvoiceCard(
      {Key? key,
      this.name,
      this.orderId,
      this.date,
      this.total,
      this.salesman,
      required this.completed})
      : super(key: key);

  final name;
  final orderId;
  final date;
  final total;
  final bool completed;
  final salesman;

  @override
  State<InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard> {
  DateTime today = DateTime.now();
  var dateFormatter = DateFormat('dd-MM-yyyy');
  String? selectedValueA;
  File? imageFile;

  identifyColor() {
    if (widget.completed == false) {
      return Colors.amber.shade300;
    } else if (widget.completed == true) {
      return Colors.green;
    }
  }

  identifyStatus() {
    if (widget.completed == false) {
      return 'En proceso';
    } else if (widget.completed == true) {
      return 'Facturado';
    }
  }

  void identifyFunction() {
    if (widget.completed == true) {
      return modalBottomSheetForInvoices(true);
    } else if (widget.completed == false) {
      return modalBottomSheetForInvoices(false);
    }
  }

  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _cropImage(pickedFile.path);
    } else {
      return;
    }
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void modalBottomSheetForInvoices(bool completed) {
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
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        myTheme.colorScheme.primary,
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
                                                  'Pago de factura #000',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-regular',
                                                    color: myTheme
                                                        .colorScheme.secondary,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        leading: Icon(
                                                          Icons.money_off_csred,
                                                          color: Colors.green,
                                                        ),
                                                        title: Row(
                                                          children: [
                                                            Text(
                                                              '\$ 1.20',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-regular',
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .fromLTRB(20,
                                                                      0, 0, 10),
                                                              child: Text(
                                                                '00/00/0000',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Poppins-regular',
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                  fontSize: 10,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        subtitle: Text(
                                                          'Efectivo',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins-regular',
                                                            color: Colors
                                                                .grey.shade400,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      ListTile(
                                                        leading: Icon(
                                                          Icons
                                                              .attach_money_rounded,
                                                          color: Colors.amber,
                                                        ),
                                                        title: Row(
                                                          children: [
                                                            Text(
                                                              '\$ 5.00',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-regular',
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .fromLTRB(20,
                                                                      0, 0, 10),
                                                              child: Text(
                                                                '00/00/0000',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Poppins-regular',
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                  fontSize: 10,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        subtitle: Text(
                                                          'Transferencia',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins-regular',
                                                            color: Colors
                                                                .grey.shade400,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      ListTile(
                                                        leading: Icon(
                                                          Icons
                                                              .attach_money_rounded,
                                                          color: Colors.amber,
                                                        ),
                                                        title: Row(
                                                          children: [
                                                            Text(
                                                              '\$ 5.00',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-regular',
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .fromLTRB(20,
                                                                      0, 0, 10),
                                                              child: Text(
                                                                '00/00/0000',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Poppins-regular',
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                  fontSize: 10,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        subtitle: Text(
                                                          'Credito',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins-regular',
                                                            color: Colors
                                                                .grey.shade400,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 30),
                                                      Text(
                                                        'Restante en USD: \$00.00',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-regular',
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Se genero NC: #25',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-regular',
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Saldo confimado: \$ 44.40',
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
                                                        'Por conciliar: \$11.00',
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
                                                        alignment: Alignment
                                                            .centerRight,
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
                                                                  FontWeight
                                                                      .bold,
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
                                    foregroundColor:
                                        myTheme.colorScheme.primary,
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
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                                                    fontFamily:
                                                        'Poppins-regular',
                                                    color: myTheme
                                                        .colorScheme.secondary,
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
                                                            color: myTheme
                                                                .colorScheme
                                                                .secondary,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(10, 5,
                                                                  10, 10),
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
                                                                            FontWeight.bold,
                                                                        color: myTheme
                                                                            .colorScheme
                                                                            .primary
                                                                            .withOpacity(0.7),
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
                                                                            color:
                                                                                myTheme.colorScheme.primary,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ))
                                                                  .toList(),
                                                              value:
                                                                  selectedValueA,
                                                              onChanged:
                                                                  (value) {
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
                                                                      right:
                                                                          14),
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
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              buttonElevation:
                                                                  0,
                                                              itemHeight: 40,
                                                              itemPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 14,
                                                                      right:
                                                                          14),
                                                              dropdownMaxHeight:
                                                                  200,
                                                              dropdownWidth:
                                                                  200,
                                                              dropdownPadding:
                                                                  null,
                                                              dropdownDecoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .white,
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
                                                          margin: EdgeInsets
                                                              .fromLTRB(10, 5,
                                                                  10, 10),
                                                          padding: EdgeInsets
                                                              .fromLTRB(10, 10,
                                                                  10, 10),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
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
                                                                style:
                                                                    TextStyle(
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
                                                                    .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        5),
                                                                child:
                                                                    IconButton(
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
                                                                    setState(
                                                                        () {
                                                                      today =
                                                                          newDate;
                                                                    });
                                                                  },
                                                                  splashRadius:
                                                                      5,
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
                                                          onTap: () {
                                                            _getFromGallery();
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
                                                                        .all(
                                                                            4.0),
                                                                child: Icon(
                                                                  Icons.camera,
                                                                  color: myTheme
                                                                      .colorScheme
                                                                      .secondary,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Galeria',
                                                                style:
                                                                    TextStyle(
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
                                                        // SizedBox(height: 100),
                                                        Container(),
                                                        Container(
                                                          alignment: Alignment
                                                              .bottomCenter,
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
                                                                    fontSize:
                                                                        14,
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
                                                                        BorderRadius.circular(
                                                                            16),
                                                                    color: myTheme
                                                                        .colorScheme
                                                                        .primary),
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    // Crear en DB una visita
                                                                  },
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    foregroundColor: myTheme
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        identifyFunction();
      },
      child: Padding(
        padding: EdgeInsets.only(top: 5, left: 16, right: 16, bottom: 5),
        child: Container(
          width: 360.0,
          height: 63,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 14, top: 10),
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 14, top: 10),
                    child: Text(
                      widget.salesman,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 100),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      widget.total,
                      style: TextStyle(
                        color: identifyColor(),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 14),
                    child: Container(
                      height: 13,
                      width: 150,
                      child: Text(
                        widget.orderId,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: 13,
                      width: 95,
                      child: Text(
                        'Fecha: ${widget.date}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: 13,
                      width: 60,
                      child: Text(
                        identifyStatus(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: identifyColor(),
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
  }
}
