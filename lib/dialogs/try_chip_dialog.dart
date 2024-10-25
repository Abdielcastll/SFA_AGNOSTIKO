import 'package:flutter/material.dart';

import '../src/services/utils/keypad.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> tryChipDialog(BuildContext context) {
  return showDialog(
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
          child: AlertDialog(
            actionsOverflowButtonSpacing: 1,
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            contentPadding: const EdgeInsets.only(left: 25, right: 25),
            title: const Text("Inserte Chip o intente con otra tarjeta"),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text(AppLocalizations.of(context)!.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      });
}
