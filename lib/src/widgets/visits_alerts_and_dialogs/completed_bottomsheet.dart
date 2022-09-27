// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/services/database_create.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

void modalBottomSheetForCompleted(
  context,
  commentary,
  currentClientName,
  idType,
  id,
  specialContributor,
  currentClientPhone,
  currentClientEmail,
  currentClientAddress,
  currentClientDispatchAdress,
  currentClientZones,
  currentClientPrices,
  currentDiscountMaster,
  clientReferenceId,
  userUID,
  visitDocumentId,
  currentClientId,
  currentClientIdType,
) {
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
      return FractionallySizedBox(
        heightFactor: 0.6,
        child: StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        '$commentary',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
                          color: myTheme.colorScheme.primary.withOpacity(0.5),
                        ),
                      ),
                    ),
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
                                              onPressed: () async {
                                                // Eliminar Visita en proceso de DB
                                                var result = deleteVisit(
                                                  visitDocumentId,
                                                  userUID,
                                                );
                                                Navigator.pop(context);
                                                Navigator.pop(context);
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
                            // onPressed: () {
                            //   showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return AlertDialog(
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(20),
                            //         ),
                            //         title: Text(
                            //           'Informacion',
                            //           style: TextStyle(
                            //             fontFamily: 'Poppins-regular',
                            //             color: myTheme.colorScheme.secondary,
                            //             fontSize: 14,
                            //             fontWeight: FontWeight.bold,
                            //           ),
                            //         ),
                            //         content: SingleChildScrollView(
                            //           physics: BouncingScrollPhysics(),
                            //           child: Column(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.center,
                            //             children: [
                            //               Text(
                            //                 'Nombre/Razon Social',
                            //                 style: TextStyle(
                            //                   fontFamily: 'Poppins-regular',
                            //                   color:
                            //                       myTheme.colorScheme.primary,
                            //                   fontSize: 12,
                            //                 ),
                            //               ),
                            //               TextBoxWidget(
                            //                 message: currentClientName,
                            //               ),
                            //               Text(
                            //                 'Documento de Identidad',
                            //                 style: TextStyle(
                            //                   fontFamily: 'Poppins-regular',
                            //                   color:
                            //                       myTheme.colorScheme.primary,
                            //                   fontSize: 12,
                            //                 ),
                            //               ),
                            //               Row(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.center,
                            //                 children: [
                            //                   TextBoxWidget(
                            //                     message: idType,
                            //                   ),
                            //                   TextBoxWidget(
                            //                     message: id,
                            //                   ),
                            //                 ],
                            //               ),
                            //               Row(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.center,
                            //                 children: [
                            //                   Checkbox(
                            //                       value: specialContributor,
                            //                       onChanged: null),
                            //                   // SizedBox(width: 10),
                            //                   Text(
                            //                     'Contribuidor Especial',
                            //                     style: TextStyle(
                            //                       fontFamily: 'Poppins-regular',
                            //                       color: myTheme
                            //                           .colorScheme.primary,
                            //                       fontSize: 12,
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //               Text(
                            //                 'Telefono',
                            //                 style: TextStyle(
                            //                   fontFamily: 'Poppins-regular',
                            //                   color:
                            //                       myTheme.colorScheme.primary,
                            //                   fontSize: 12,
                            //                 ),
                            //               ),
                            //               TextBoxWidget(
                            //                 message: currentClientPhone,
                            //               ),
                            //               Text(
                            //                 'Correo',
                            //                 style: TextStyle(
                            //                   fontFamily: 'Poppins-regular',
                            //                   color:
                            //                       myTheme.colorScheme.primary,
                            //                   fontSize: 12,
                            //                 ),
                            //               ),
                            //               TextBoxWidget(
                            //                 message: currentClientEmail,
                            //               ),
                            //               Text(
                            //                 'Direccion Fiscal',
                            //                 style: TextStyle(
                            //                   fontFamily: 'Poppins-regular',
                            //                   color:
                            //                       myTheme.colorScheme.primary,
                            //                   fontSize: 12,
                            //                 ),
                            //               ),
                            //               TextBoxWidget(
                            //                 message: currentClientAddress,
                            //               ),
                            //               Text(
                            //                 'Direccion de despacho',
                            //                 style: TextStyle(
                            //                   fontFamily: 'Poppins-regular',
                            //                   color:
                            //                       myTheme.colorScheme.primary,
                            //                   fontSize: 12,
                            //                 ),
                            //               ),
                            //               TextBoxWidget(
                            //                 message:
                            //                     currentClientDispatchAdress,
                            //               ),
                            //               Text(
                            //                 'Zona / Lista de Prcios',
                            //                 style: TextStyle(
                            //                   fontFamily: 'Poppins-regular',
                            //                   color:
                            //                       myTheme.colorScheme.primary,
                            //                   fontSize: 12,
                            //                 ),
                            //               ),
                            //               Row(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.center,
                            //                 children: [
                            //                   TextBoxWidget(
                            //                     message: currentClientZones,
                            //                   ),
                            //                   TextBoxWidget(
                            //                     message: currentClientPrices,
                            //                   ),
                            //                 ],
                            //               ),
                            //               Text(
                            //                 'Descuento Maestro (%)',
                            //                 style: TextStyle(
                            //                   fontFamily: 'Poppins-regular',
                            //                   color:
                            //                       myTheme.colorScheme.primary,
                            //                   fontSize: 12,
                            //                 ),
                            //               ),
                            //               TextBoxWidget(
                            //                 message: currentDiscountMaster,
                            //               ),
                            //               Row(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.end,
                            //                 children: [
                            //                   TextButton(
                            //                     onPressed: () {
                            //                       Navigator.pop(context);
                            //                     },
                            //                     child: Text(
                            //                       'Regresar',
                            //                       style: TextStyle(
                            //                         fontFamily:
                            //                             'Poppins-regular',
                            //                         color: myTheme
                            //                             .colorScheme.primary,
                            //                         fontSize: 14,
                            //                         fontWeight: FontWeight.bold,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //   );
                            // },
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ClientDetails(
                                    specialContribuyer: specialContributor,
                                    masterDiscount: currentDiscountMaster,
                                    fiscalAddress: currentClientAddress,
                                    email: currentClientEmail,
                                    listOfPrices: currentClientPrices,
                                    name: currentClientName,
                                    tlf1: currentClientPhone,
                                    tlf2: currentClientPhone,
                                    zone: currentClientZones,
                                    nameId: currentClientId,
                                    typeId: currentClientIdType,
                                    clientDocumentReferenceID:
                                        clientReferenceId,
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
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

class TextBoxWidget extends StatelessWidget {
  const TextBoxWidget({
    Key? key,
    this.message,
  }) : super(key: key);

  final message;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 350,
      // height: 40,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(10, 15, 0, 10),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(
          color: myTheme.colorScheme.primary.withOpacity(0.5),
        ),
      ),
      child: Text(
        '$message',
        // maxLines: 3,
        // overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'Poppins-regular',
          fontSize: 14,
          color: myTheme.colorScheme.primary.withOpacity(0.5),
        ),
      ),
    );
  }
}
