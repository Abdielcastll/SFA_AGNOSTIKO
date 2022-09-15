// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class VisitCard extends StatefulWidget {
  const VisitCard({
    Key? key,
    this.name,
    this.adress,
    this.hour,
    this.date,
    this.status,
  }) : super(key: key);

  final name;
  final adress;
  final hour;
  final date;
  final status;

  @override
  State<VisitCard> createState() => _VisitCardState();
}

class _VisitCardState extends State<VisitCard> {
  final List<String> items = [
    'Completada',
    'Cancelada',
  ];

  String? selectedValue;

  identifyColor() {
    if (widget.status == 'On process') {
      return Colors.amber.shade300;
    } else if (widget.status == 'Completed') {
      return Colors.green;
    } else if (widget.status == 'Cancelled') {
      return Colors.red;
    }
  }

  void identifyFunction() {
    if (widget.status == 'On process') {
      return modalBottomSheetForOnProcess();
    }
    if (widget.status == 'Completed' || widget.status == 'Cancelled') {
      return modalBottomSheetForCompleted();
    }
  }

  void modalBottomSheetForOnProcess() {
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
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        'Comentario',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: myTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10, 30, 0, 0),
                      child: TextField(
                        style: TextStyle(
                          fontSize: 14,
                          color: myTheme.colorScheme.primary,
                        ),
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        maxLength: 200,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                          hintText: 'Comentario sobre la visita',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: myTheme.colorScheme.primary.withOpacity(0.4),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color:
                                  myTheme.colorScheme.primary.withOpacity(0.5),
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          // CAmbiar valor dentro del comentario
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 15),
                      child: Text(
                        'Estato de la visita',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: myTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        // ignore: prefer_const_literals_to_create_immutables
                        hint: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedValue ?? 'Seleccione un estado',
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
                        items: items
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
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;
                          });
                          // Mover la funcion en la base de datos para cambiar la lista
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios_outlined,
                        ),
                        iconSize: 11,
                        iconEnabledColor:
                            myTheme.colorScheme.primary.withOpacity(0.5),
                        iconDisabledColor: Colors.grey,
                        buttonHeight: 50,
                        buttonWidth: 300,
                        buttonPadding:
                            const EdgeInsets.only(left: 14, right: 14),
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
                        offset: const Offset(-20, 0),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Regresar',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: Text(
                                        '¿Seguro que quiere actualizar el estado de esta visita?',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme.colorScheme.secondary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Regresar',
                                              style: TextStyle(
                                                fontFamily: 'Poppins-regular',
                                                color:
                                                    myTheme.colorScheme.primary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: myTheme
                                                    .colorScheme.primary),
                                            child: TextButton(
                                              onPressed: () {
// Actualizar estado dentro de la DB
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    myTheme.colorScheme.primary,
                                              ),
                                              child: Text(
                                                'Actualizar estado',
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
                                    );
                                  });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: myTheme.colorScheme.primary,
                            ),
                            child: Text(
                              'Guardar Cambios',
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.red),
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: Text(
                                        '¿Quiere Eliminar esta Visita en proceso?',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme.colorScheme.secondary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Regresar',
                                              style: TextStyle(
                                                fontFamily: 'Poppins-regular',
                                                color:
                                                    myTheme.colorScheme.primary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: myTheme
                                                    .colorScheme.primary),
                                            child: TextButton(
                                              onPressed: () {
// Eliminar Visita en proceso de DB
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    myTheme.colorScheme.primary,
                                              ),
                                              child: Text(
                                                'Eliminar visita',
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
                                    );
                                  });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            icon: Icon(Icons.delete_forever_outlined,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void modalBottomSheetForCompleted() {
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
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                      child: Text(
                        'Comentario',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: myTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Container(
                      width: 350,
                      height: 40,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10, 15, 0, 10),
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade300,
                        border: Border.all(
                          color: myTheme.colorScheme.primary.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        'Comentario sobre la visita',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
                          color: myTheme.colorScheme.primary.withOpacity(0.5),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.red),
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: Text(
                                        '¿Quiere Eliminar esta Visita en proceso?',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme.colorScheme.secondary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Regresar',
                                              style: TextStyle(
                                                fontFamily: 'Poppins-regular',
                                                color:
                                                    myTheme.colorScheme.primary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: myTheme
                                                    .colorScheme.primary),
                                            child: TextButton(
                                              onPressed: () {
// Eliminar Visita en proceso de DB
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    myTheme.colorScheme.primary,
                                              ),
                                              child: Text(
                                                'Eliminar visita',
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
                                    );
                                  });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            icon: Icon(Icons.delete_forever_outlined,
                                color: Colors.white),
                          ),
                        ),
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
                                          specialContribuyer: true,
                                          masterDiscount: 10,
                                          fiscalAddress: 'Example',
                                          email: 'example@tech.com',
                                          listOfPrices: 'GER-03',
                                          name: 'Example',
                                          tlf1: '0000000',
                                          tlf2: '0000000000',
                                          zone: 'Territorio example',
                                          nameId: 555666,
                                          typeId: 'J'),
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
                      ],
                    ),
                  ],
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
    // print(date);
    return GestureDetector(
      onTap: () {
        print('Redireccionar a detalles de visita');
        // Redireccionar a detallesd e la visita
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
                  SizedBox(width: 150),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      widget.date,
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
                        widget.adress,
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
                        'Hora: ${widget.hour}',
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
                        widget.status,
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
