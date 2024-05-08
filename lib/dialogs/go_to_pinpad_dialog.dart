import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

void showGoToPinpadDialog(BuildContext context, String message,
    {Future<bool> Function()? onWillPop}) {
  // por defecto no se permite cerrar el dialog
  if (onWillPop == null) onWillPop = () async => false;

  bool enableAnimation = true;
  if (Platform.isLinux) {
    enableAnimation = false;
  }
  Timer? timer = Timer(Duration(seconds: 20), () {
    Navigator.of(context).pop();
  });
  showDialog(
    barrierColor: Color.fromARGB(197, 255, 255, 255),
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: onWillPop,
        child: Dialog(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (enableAnimation)
                  Image.asset(
                    'assets/images/ver_pinpad.gif',
                    fit: BoxFit.fitHeight,
                    width: 300,
                    height: 300,
                  ),
                const SizedBox(height: 20),
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: myTheme.colorScheme.primary,
                      fontFamily: 'Poppins-regular',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ).then((value) {
    timer?.cancel();
    timer = null;
  });
}
