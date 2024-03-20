import 'package:flutter/material.dart';

import '../src/services/utils/keypad.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> showInfoDialog(
  BuildContext context,
  String message, {
  void Function()? onClose,
}) {
  return showDialog(
      context: context,
      barrierDismissible: onClose == null ? true : false,
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
          child: WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              actionsOverflowButtonSpacing: 1,
              actionsPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              contentPadding: EdgeInsets.only(left: 25, right: 25),
              title: Center(child: Text("Info")),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              content: Text(message),
              actions: <Widget>[
                ElevatedButton(
                  child: Text(AppLocalizations.of(context)!.close),
                  onPressed: onClose ??
                      () {
                        Navigator.pop(context);
                      },
                ),
              ],
            ),
          ),
        );
      });
}
