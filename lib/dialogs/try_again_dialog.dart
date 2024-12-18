import 'dart:async';
import 'package:flutter/material.dart';
import '../src/services/utils/keypad.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> tryAgainDialog(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: rawKeypadHandler(
          context,
          onEscape: () {
            Navigator.popUntil(context, (route) => route.isFirst == true);
          },
        ),
        child: const CountdownDialog(),
      );
    },
  );
}

class CountdownDialog extends StatefulWidget {
  const CountdownDialog({Key? key}) : super(key: key);

  @override
  _CountdownDialogState createState() => _CountdownDialogState();
}

class _CountdownDialogState extends State<CountdownDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsOverflowButtonSpacing: 1,
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      contentPadding: const EdgeInsets.only(left: 25, right: 25),
      title: const Text("Error en la lectura"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Revise su tarjeta e intente de nuevo.\nEn caso de contactless acerquela con mas cuidado",
          ),
        ],
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            AppLocalizations.of(context)!.close,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
