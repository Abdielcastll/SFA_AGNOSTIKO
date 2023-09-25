import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

goBackToCatalogue(BuildContext context) {
  final orderActive = context.read<OrderProvider>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Advertencia"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Salir de este proceso hara que deba continuarlo desde el menu de facturas como registro manual",
            style: TextStyle(
              color: myTheme.colorScheme.primary,
              fontFamily: 'Poppins-regular',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            " ¿Esta seguro que quiere salir?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: myTheme.colorScheme.primary,
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
          child: Text("No"),
        ),
        TextButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            objectBox.delelteAllShoppingCart();
            orderActive.setOrder(false);
            final j = context.read<CounterLimitFirestore>();
            j.setNewScreen(1);
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: myTheme.colorScheme.onPrimaryContainer,
                  duration: const Duration(seconds: 3),
                  content: Column(
                    children: const [
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
            // Navigator.of(context).pop();
            // Navigator.of(context).pop();
            // Navigator.of(context).pop();
          },
          child: Text("Si"),
        ),
      ],
    ),
  );
}
