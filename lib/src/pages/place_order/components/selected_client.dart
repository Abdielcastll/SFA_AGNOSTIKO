// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_rol_model.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class SelectedClient extends StatelessWidget {
  const SelectedClient({
    Key? key,
    required this.client,
    required this.isEditable,
  }) : super(key: key);

  final Clients? client;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<UserRole?>(context, listen: true);
    // print('User Role ${userRole?.name}');
    // print("Retail: ${userRole?.isRetail}");

    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(16, 10, 16, 5),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white,
            ),
          ),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(14, 5, 0, 2),
                    height: 16,
                    width: 180,
                    child: Text(
                      userRole?.name ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins-mediumm',
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  Container(
                    width: 250,
                    margin: EdgeInsets.fromLTRB(14, 8, 0, 10),
                    child: Text(
                      client?.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins-mediumm',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(14, 0, 0, 0),
                    height: 30,
                    width: 180,
                    child: Text(
                      client?.fiscalAdress ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins-mediumm',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ),
              isEditable
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        child: IconButton(
                          splashRadius: 30,
                          splashColor:
                              myTheme.colorScheme.secondary.withOpacity(0.7),
                          highlightColor:
                              myTheme.colorScheme.secondary.withOpacity(0.3),
                          onPressed: () {
                            // Regresar y elegir otro cliente
                            showDialog(
                              context: context,
                              barrierDismissible: false, // User must tap button
                              builder: (context) {
                                return AlertDialog(
                                  surfaceTintColor:
                                      Color.fromARGB(255, 222, 222, 222),
                                  title: Text(
                                    'Al cambiar el cliente la lista de precios estara cambiando, por lo que el carrito se reiniciara',
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        Text(
                                            '¿Esta seguro que quiere regresar?'),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('Regresar'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Aceptar'),
                                      onPressed: () {
                                        final orderActive =
                                            Provider.of<OrderProvider>(context,
                                                listen: false);
                                        orderActive.setOrder(false);
                                        objectBox.delelteAllShoppingCart();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Feather.edit,
                            color: myTheme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Divider(
                color: Colors.grey,
                height: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
