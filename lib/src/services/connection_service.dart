import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkInternetConnection(BuildContext context) async {
  var connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult.contains(ConnectivityResult.none)) {
    _showNoConnectionDialog(context);
    return false;
  } else {
    return true;
  }
}

void _showNoConnectionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Sin conexión'),
      content: Text('No se puede continuar sin conexión a internet.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Ok'),
        ),
      ],
    ),
  );
}
