// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

void modalBottomSheetForCompleted(context) {
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
                                              color:
                                                  myTheme.colorScheme.primary),
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
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (BuildContext context) =>
                            //         ClientDetails(
                            //             specialContribuyer: true,
                            //             masterDiscount: 10,
                            //             fiscalAddress: 'Example',
                            //             email: 'example@tech.com',
                            //             listOfPrices: 'GER-03',
                            //             name: 'Example',
                            //             tlf1: '0000000',
                            //             tlf2: '0000000000',
                            //             zone: 'Territorio example',
                            //             nameId: 555666,
                            //             typeId: 'J'),
                            //   ),
                            // );
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
