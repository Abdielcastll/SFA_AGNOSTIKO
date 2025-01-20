import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

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
    barrierColor: Color.fromARGB(255, 212, 212, 212),
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: onWillPop,
        child: Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (enableAnimation)
                  FittedBox(
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      'assets/images/ver_pinpad.gif',
                      fit: BoxFit.fitWidth,
                      width: 340,
                      height: 300,
                    ),
                  ),
                const SizedBox(height: 20),
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Poppins-Regular',
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
