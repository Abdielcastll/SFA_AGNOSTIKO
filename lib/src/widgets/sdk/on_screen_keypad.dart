import 'package:flutter/material.dart';

import 'package:agnostiko/agnostiko.dart';

import '../../widgets/sdk/accept_input_button.dart';

class OnScreenKeypad extends StatelessWidget {
  final void Function() onAccept;
  final void Function(int digitValue) onDigitTap;
  final void Function() onBackspaceTap;
  final void Function() onClearTap;

  const OnScreenKeypad({
    Key? key,
    required this.onAccept,
    required this.onDigitTap,
    required this.onBackspaceTap,
    required this.onClearTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AcceptInputButton(
          label: "Aceptar",
          onPressed: onAccept,
        ),
        NumericKeyboard(
          onDigitTap: onDigitTap,
          rightButtonIcon: Icon(Icons.backspace),
          onRightButtonTap: onBackspaceTap,
          leftButtonIcon: Icon(Icons.clear),
          onLeftButtonTap: onClearTap,
        ),
      ],
    );
  }
}
