import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

import '../src/services/utils/keypad.dart';

Future<T?> showConfirmDialog<T>(
  BuildContext context, {
  required String title,
  required String message,
  required void Function() onAccept,
  required void Function() onCancel,
  String textAccept = 'Aceptar',
  String textCancel = 'Cancelar',
}) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

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
          actionsOverflowButtonSpacing: 1,
          actionsPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          title: Center(child: Text(title)),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  themeProvider.myTheme.colorScheme.primary,
                ),
                foregroundColor:
                    MaterialStateProperty.all(Colors.grey.shade400),
              ),
              onPressed: onAccept,
              child: Text(
                textAccept,
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: onCancel,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.grey.shade400),
                foregroundColor:
                    MaterialStateProperty.all(Colors.grey.shade400),
              ),
              child: Text(
                textCancel,
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      );
    },
  );
}
