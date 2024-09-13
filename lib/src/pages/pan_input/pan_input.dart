import 'package:flutter/material.dart';

import 'package:agnostiko/agnostiko.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

import '../../../dialogs/cancel_transaction_dialog.dart';
import '../../models/transaction_args.dart';
import '../../pages/exp_date_input/exp_date_input.dart';
import '../../widgets/sdk/on_screen_keypad.dart';
import '../../services/utils/keypad.dart';

class PanInputView extends StatefulWidget {
  static String route = "/panInput";

  const PanInputView({super.key});

  @override
  _PanInputViewState createState() => _PanInputViewState();
}

class _PanInputViewState extends State<PanInputView> {
  final _panController = TextEditingController();
  final _maxLen = 16;

  String? _panError;

  TransactionArgs? transactionArgs;

  @override
  Widget build(BuildContext context) {
    transactionArgs =
        ModalRoute.of(context)?.settings.arguments as TransactionArgs;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return WillPopScope(
      onWillPop: cancelTransactionDialogFn(
        context,
        null,
        null,
        false,
      ),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: rawKeypadHandler(
          context,
          onDigit: _addDigit,
          onEnter: _acceptPan,
          onBackspace: _removeDigit,
          onEscape: cancelTransactionDialogFn(
            context,
            null,
            null,
            false,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: themeProvider.myTheme.colorScheme.primary,
            foregroundColor: Colors.white,
            title: Text("sale"),
          ),
          body: Column(children: [
            Expanded(child: Container()),
            Padding(
              child: TextField(
                autofocus: true,
                controller: _panController,
                decoration: InputDecoration(
                  labelText: "cardNumber",
                  errorText: _panError,
                ),
                maxLength: _maxLen,
                readOnly: true,
                style: TextStyle(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
            ),
            if (transactionArgs?.showNumericKeyboard == true)
              OnScreenKeypad(
                onAccept: _acceptPan,
                onDigitTap: _addDigit,
                onBackspaceTap: _removeDigit,
                onClearTap: _clearDigits,
              )
            else
              Expanded(child: Container())
          ]),
        ),
      ),
    );
  }

  void _addDigit(int digit) {
    if (_panController.text.length < _maxLen) {
      _panController.text += digit.toString();
    }
  }

  void _removeDigit() {
    final pan = _panController.text;
    _panController.text =
        pan.length > 0 ? pan.substring(0, pan.length - 1) : "";
  }

  void _clearDigits() {
    _panController.text = "";
  }

  void _acceptPan() {
    if (_validate()) {
      transactionArgs?.pan = _panController.text;
      Navigator.pushReplacementNamed(context, ExpDateInputView.route,
          arguments: transactionArgs);
    }
  }

  bool _validate() {
    final pan = _panController.text;
    bool isValid = pan.length > 1 && checkLuhn(pan);

    setState(() {
      _panError = isValid ? null : "invalidValue";
    });

    return isValid;
  }
}
