// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({
    Key? key,
    this.name,
    this.clientId,
    this.orderId,
    this.date,
    this.total,
    this.completed,
    this.failed,
  }) : super(key: key);

  final name;
  final clientId;
  final orderId;
  final date;
  final total;
  final completed;
  final failed;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  identifyStatusColor() {
    if (widget.completed == 'true' && widget.failed == 'false') {
      return Colors.green;
    } else if (widget.completed == 'true' && widget.failed == 'true') {
      return Colors.red;
    } else if (widget.completed == 'false' && widget.failed == 'false') {
      return Colors.amber.shade300;
    }
  }

  identifyStatus() {
    if (widget.completed == 'true' && widget.failed == 'false') {
      return 'Completado';
    } else if (widget.completed == 'true' && widget.failed == 'true') {
      return 'Fallido';
    } else if (widget.completed == 'false' && widget.failed == 'false') {
      return 'En proceso';
    }
  }

  void identifyFunction() {
    if (widget.completed == 'true') {
      return modalBottomSheetForOrders(true);
    } else if (widget.completed == 'false') {
      return modalBottomSheetForOrders(false);
    }
  }

  void modalBottomSheetForOrders(bool completed) {
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
                          'Comentario del pedido',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 14,
                            color: myTheme.colorScheme.primary.withOpacity(0.5),
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
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            title: Text(
                                              'Pedido',
                                              style: TextStyle(
                                                fontFamily: 'Poppins-regular',
                                                color: myTheme
                                                    .colorScheme.secondary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            content: Column(
                                              children: [
                                                ListTile(
                                                  leading: Icon(
                                                    Icons.photo,
                                                    color: Colors.grey.shade400,
                                                  ),
                                                  title: Text(
                                                    'ALMOHADA CLASS KING NAC NIEVE FIRME',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-regular',
                                                      color:
                                                          Colors.grey.shade400,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                              'AC1K0002',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-regular',
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Text(
                                                              'A Pagar: NaN x 1',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-regular',
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ]),
                                                ),
                                                ListTile(
                                                  leading: Icon(
                                                    Icons.photo,
                                                    color: Colors.grey.shade400,
                                                  ),
                                                  title: Text(
                                                    'ALMOHADA CLASS STD NAC NIEVE FIRME',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-regular',
                                                      color:
                                                          Colors.grey.shade400,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                              'AC1K0003',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-regular',
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Text(
                                                              'A Pagar: NaN x 1',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-regular',
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ]),
                                                ),
                                                ListTile(
                                                  leading: Icon(
                                                    Icons.photo,
                                                    color: Colors.grey.shade400,
                                                  ),
                                                  title: Text(
                                                    'ALMOHADA CLASS KING  2DA NAC NIEVE FIRME',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-regular',
                                                      color:
                                                          Colors.grey.shade400,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                              'AC1K0002',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-regular',
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Text(
                                                              'A Pagar: NaN x 1',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins-regular',
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ]),
                                                ),
                                                SizedBox(height: 30),
                                                Text(
                                                  'Sub-Total: \$00.00',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-regular',
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'Descuento Maestro: 00%',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-regular',
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'IVA: 16%',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-regular',
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'Total a Pagar: \$00.00',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-regular',
                                                    color: Colors.green,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
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
                                  child: Text(
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
                                      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: myTheme.colorScheme.primary),
                                      child: TextButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  title: Text(
                                                    '¿Quiere pasar a facturas este pedido?',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-regular',
                                                      color: myTheme.colorScheme
                                                          .secondary,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  content: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      TextButton(
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
                                                      Container(
                                                        width: 150,
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
                                                            // Mandar pedido a Facturar
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                myTheme
                                                                    .colorScheme
                                                                    .primary,
                                                          ),
                                                          child: Text(
                                                            'Facturar',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins-regular',
                                                              color:
                                                                  Colors.white,
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
                                                );
                                              });
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              myTheme.colorScheme.primary,
                                        ),
                                        child: Text(
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
                                margin: EdgeInsets.only(top: 5.0),
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
                                                color: myTheme
                                                    .colorScheme.secondary,
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
                                                          BorderRadius.circular(
                                                              16),
                                                      color: myTheme
                                                          .colorScheme.primary),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      // Eliminar Visita en proceso de DB
                                                    },
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: myTheme
                                                          .colorScheme.primary,
                                                    ),
                                                    child: Text(
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
                                  icon: Icon(Icons.delete_forever_outlined,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Redireccionar a detalles del pedido
        print('Redireccionar a detalles de pedido');
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
                      '\$${widget.total}',
                      style: TextStyle(
                        color: identifyStatusColor(),
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
                        'Hora: ${widget.date}',
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
                          color: identifyStatusColor(),
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
