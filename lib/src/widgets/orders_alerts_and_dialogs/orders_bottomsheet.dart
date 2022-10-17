// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

void modalBottomSheetForOrders(
  bool completed,
  context,
  commentary,
  clientID,
  products,
  subTotal,
  discountMaster,
  tax,
  total,
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
  orderDocumentId,
  currentClientId,
  currentClientIdType,
) {
  showModalBottomSheet(
    elevation: 0,
    backgroundColor: Colors.white,
    barrierColor: myTheme.colorScheme.secondary.withOpacity(0.5),
    // isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.fromLTRB(10, 20, 0, 0),
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
                      margin: const EdgeInsets.fromLTRB(10, 15, 0, 10),
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
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
                    const SizedBox(height: 25),
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
                                // onPressed: () {
                                //   showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) {
                                //       return AlertDialog(
                                //         shape: RoundedRectangleBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(20),
                                //         ),
                                //         title: Text(
                                //           'Informacion',
                                //           style: TextStyle(
                                //             fontFamily: 'Poppins-regular',
                                //             color:
                                //                 myTheme.colorScheme.secondary,
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
                                //                   color: myTheme
                                //                       .colorScheme.primary,
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
                                //                   color: myTheme
                                //                       .colorScheme.primary,
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
                                //                       fontFamily:
                                //                           'Poppins-regular',
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
                                //                   color: myTheme
                                //                       .colorScheme.primary,
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
                                //                   color: myTheme
                                //                       .colorScheme.primary,
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
                                //                   color: myTheme
                                //                       .colorScheme.primary,
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
                                //                   color: myTheme
                                //                       .colorScheme.primary,
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
                                //                   color: myTheme
                                //                       .colorScheme.primary,
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
                                //                     message:
                                //                         currentClientPrices,
                                //                   ),
                                //                 ],
                                //               ),
                                //               Text(
                                //                 'Descuento Maestro (%)',
                                //                 style: TextStyle(
                                //                   fontFamily: 'Poppins-regular',
                                //                   color: myTheme
                                //                       .colorScheme.primary,
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
                                //                             .colorScheme
                                //                             .primary,
                                //                         fontSize: 14,
                                //                         fontWeight:
                                //                             FontWeight.bold,
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
                                  print(clientReferenceId);
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
                                child: const Text(
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
                            const SizedBox(width: 15),
                            Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: myTheme.colorScheme.primary),
                              child: TextButton(
                                onPressed: () {
                                  print(products.length);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          title: Text(
                                            'Pedido',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-regular',
                                              color:
                                                  myTheme.colorScheme.secondary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Column(
                                            children: [
                                              SingleChildScrollView(
                                                child: Container(
                                                  width: 300,
                                                  height: 300,
                                                  child: Scrollbar(
                                                    child: ListView.builder(
                                                      itemCount:
                                                          products.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final product =
                                                            products[index];
                                                        return ListTile(
                                                          leading: Icon(
                                                            Icons.photo,
                                                            color: Colors
                                                                .grey.shade400,
                                                          ),
                                                          title: Text(
                                                            '${product['nombre']}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-regular',
                                                              color: Colors.grey
                                                                  .shade400,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          subtitle: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                      '${product['codigo']}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Poppins-regular',
                                                                        color: Colors
                                                                            .grey
                                                                            .shade400,
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'A Pagar: ${product['monto'].toStringAsFixed(2)}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Poppins-regular',
                                                                        color: Colors
                                                                            .grey
                                                                            .shade400,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ]),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 30),
                                              Text(
                                                'Sub-Total: \$$subTotal',
                                                // ignore: prefer_const_constructors
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Descuento Maestro: \$$currentDiscountMaster',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'IVA: \$${tax.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Total a Pagar: \$${total.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  color: Colors.green,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 30),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
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
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: myTheme.colorScheme.primary,
                                ),
                                child: const Text(
                                  'Ver productos',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            completed
                                ? Container()
                                : Container(
                                    width: 260,
                                    height: 40,
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                title: Text(
                                                  '¿Quiere pasar a facturas este pedido?',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-regular',
                                                    color: myTheme
                                                        .colorScheme.secondary,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
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
                                                    Container(
                                                      width: 150,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          color: myTheme
                                                              .colorScheme
                                                              .primary),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          // Mandar pedido a Facturar
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              myTheme
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                        child: const Text(
                                                          'Facturar',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins-regular',
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                        foregroundColor:
                                            myTheme.colorScheme.primary,
                                      ),
                                      child: const Text(
                                        'Facturar',
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
                              margin: const EdgeInsets.only(top: 5.0),
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
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          title: Text(
                                            '¿Quiere Eliminar esta pedido en proceso?',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-regular',
                                              color:
                                                  myTheme.colorScheme.secondary,
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
                                                    fontFamily:
                                                        'Poppins-regular',
                                                    color: myTheme
                                                        .colorScheme.primary,
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
                                                        BorderRadius.circular(
                                                            16),
                                                    color: myTheme
                                                        .colorScheme.primary),
                                                child: TextButton(
                                                  onPressed: () async {
                                                    // Eliminar Visita en proceso de DB
                                                    var result = deleteOrder(
                                                      orderDocumentId,
                                                      clientReferenceId,
                                                    );
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: myTheme
                                                        .colorScheme.primary,
                                                  ),
                                                  child: const Text(
                                                    'Eliminar visita',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-regular',
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                icon: const Icon(Icons.delete_forever_outlined,
                                    color: Colors.white),
                              ),
                            ),
                          ],
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
