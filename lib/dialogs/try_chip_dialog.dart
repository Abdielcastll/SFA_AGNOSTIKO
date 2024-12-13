import 'dart:async';
import 'package:flutter/material.dart';
import '../src/services/utils/keypad.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> tryChipDialog(BuildContext context) {
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
  late Timer _timer;
  int _countdown = 3;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          _isButtonEnabled = true;
        });
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsOverflowButtonSpacing: 1,
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      contentPadding: const EdgeInsets.only(left: 25, right: 25),
      title: const Text("Error en la transacción"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Revise su tarjeta e inserte el chip o intente con otra tarjeta.\n\nEl pago no fue realizado",
          ),
        ],
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: _isButtonEnabled
              ? () {
                  Navigator.pop(context);
                }
              : null,
          child: Text(
            _isButtonEnabled
                ? AppLocalizations.of(context)!.close
                : "$_countdown",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
