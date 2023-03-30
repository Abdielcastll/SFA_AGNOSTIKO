import 'package:flutter/material.dart';

import '../src/services/utils/keypad.dart';

Future<T?> showConfirmDialog<T>(
  BuildContext context, {
  required String title,
  required String message,
  required void Function() onAccept,
  required void Function() onCancel,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: rawKeypadHandler(
          context,
          onEnter: onAccept,
          onEscape: onCancel,
        ),
        child: AlertDialog(
          contentPadding: EdgeInsets.only(left: 25, right: 25),
          title: Center(child: Text(title)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Aceptar"),
              onPressed: onAccept,
            ),
            ElevatedButton(
              child: Text(
                "Cancelar",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: onCancel,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.grey.shade400),
                foregroundColor:
                    MaterialStateProperty.all(Colors.grey.shade400),
              ),
            )
          ],
        ),
      );
    },
  );
}
