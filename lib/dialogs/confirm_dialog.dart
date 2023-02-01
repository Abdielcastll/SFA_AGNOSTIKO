import 'package:flutter/material.dart';

import '../src/services/utils/keypad.dart';

Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String message,
  required void Function() onAccept,
  required void Function() onCancel,
}) {
  return showDialog<bool?>(
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
          title: Center(child: Text("confirm")),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: new Text("accept"),
              onPressed: onAccept,
            ),
            ElevatedButton(
              child: new Text("cancel"),
              onPressed: onCancel,
            ),
          ],
        ),
      );
    },
  );
}
