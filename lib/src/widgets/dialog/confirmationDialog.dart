import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

confirmationDialog(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Advertencia"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Salir de este proceso hara que deba continuarlo desde el menu de facturas como registro manual",
            style: TextStyle(
              color: themeProvider.myTheme.colorScheme.primary,
              fontFamily: 'Poppins-regular',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            " ¿Esta seguro que quiere salir?",
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
          child: Text("No"),
        ),
        TextButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);

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
                          fontFamily: 'Poppins-Regular',
                        ),
                      ),
                      Text(
                        "Consulte lista de facturas",
                        style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                        ),
                      ),
                    ],
                  ),
                ),
              );
          },
          child: Text("Si"),
        ),
      ],
    ),
  );
}
