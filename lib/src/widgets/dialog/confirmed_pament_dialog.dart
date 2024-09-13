import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

showDialogForConfirmedPayment(BuildContext context, String? coinSymbol,
    double paidAmount, Client client, DateTime date, String selectedValueA) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Color.fromARGB(255, 222, 222, 222),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(18),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "¡PAGO REGISTRADO!",
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 18,
                            color: themeProvider
                                .myTheme.colorScheme.onPrimaryContainer,
                            // color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeProvider.myTheme.colorScheme.primary
                                  .withOpacity(0.6)),
                          width: 100,
                          height: 100,
                          child: Opacity(
                              opacity: 0.8,
                              child: Icon(
                                Icons.check,
                                color: themeProvider
                                    .myTheme.colorScheme.onPrimaryContainer,
                                size: 50,
                              )),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  'Monto pagado: $coinSymbol ${paidAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    fontSize: 12,
                                    color: themeProvider
                                        .myTheme.colorScheme.primary,
                                    // color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  '${client.name}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    fontSize: 12,
                                    color: themeProvider
                                        .myTheme.colorScheme.primary,
                                    // color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  'Fecha: $date',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    fontSize: 12,
                                    color: themeProvider
                                        .myTheme.colorScheme.primary,
                                    // color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  selectedValueA,
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    fontSize: 12,
                                    color: themeProvider
                                        .myTheme.colorScheme.primary,
                                    // color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 50),
                          alignment: Alignment.center,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              // Navigator.pop(
                              //     context);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                themeProvider.myTheme.colorScheme.primary,
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
