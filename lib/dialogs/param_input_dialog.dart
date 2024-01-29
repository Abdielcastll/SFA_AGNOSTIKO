import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Abre un dialog para el ingreso del valor de un parámetro.
Future<String?> showParamInputDialog(
  BuildContext context, {
  required String paramName,
  required String paramValue,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  int? maxLength,
  MaxLengthEnforcement? maxLengthEnforcement,
}) {
  final _textController = TextEditingController();
  _textController.text = paramValue;

  return showDialog<String?>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        surfaceTintColor: Colors.white,
        actionsOverflowButtonSpacing: 1,
        actionsPadding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        contentPadding: EdgeInsets.only(left: 25, right: 25),
        title: Center(child: Text(paramName)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        content: TextField(
          controller: _textController,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          maxLengthEnforcement:
              maxLengthEnforcement ?? MaxLengthEnforcement.none,
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text("accept"),
            onPressed: () {
              Navigator.pop(context, _textController.text);
            },
          ),
          ElevatedButton(
            child: Text("cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
