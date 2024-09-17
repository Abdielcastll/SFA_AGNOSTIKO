import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

goBackToCatalogue(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

  final orderActive = context.read<OrderProvider>();
  bool isKiosko = globalRemoteConfig.conversionKiosko!;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Advertencia"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isKiosko
                ? "Desea regresar a revisar su carrito?"
                : "Salir de este proceso hara que deba continuarlo desde el menu de facturas como registro manual",
            style: TextStyle(
              color: themeProvider.myTheme.colorScheme.primary,
              fontFamily: 'Poppins-regular',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            " ¿Esta seguro?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: themeProvider.myTheme.colorScheme.primary,
              fontFamily: 'Poppins-regular',
              fontSize: 14,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            if (isKiosko == false) {
              objectBox.delelteAllShoppingCart();
              orderActive.setOrder(false);
              final j = context.read<CounterLimitFirestore>();
              j.setNewScreen(1);
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    backgroundColor:
                        themeProvider.myTheme.colorScheme.onPrimaryContainer,
                    duration: const Duration(seconds: 3),
                    content: const Column(
                      children: [
                        Text(
                          "Facturación Pausada",
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                          ),
                        ),
                        Text(
                          "Consulte lista de facturas",
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            }
          },
          child: const Text("Si"),
        ),
      ],
    ),
  );
}
