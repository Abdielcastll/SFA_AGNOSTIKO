import 'package:agnostiko/cards/src/card_reader.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<T?> displayCustomDialog<T>({
  required BuildContext context,
  AlertType? alertType,
  bool dismissible = false,
  IconData? icon,
  required String title,
  List<String>? messages,
  String? actionButton1,
  String? actionButton2,
}) {
  print('==> CustomDialog::displayCustomDialog');

  return showDialog(
    barrierDismissible: dismissible,
    context: context,
    builder: (context) {
      if (alertType == AlertType.FALLBACK_ERROR ||
          alertType == AlertType.FINISH_EMV_TANSAC) {
        waitUntilICCardRemoved().then((_) {
          Navigator.pop(context);
        });
      }

      return WillPopScope(
        onWillPop: () => Future.value(dismissible),
        child: AlertDialog(
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          icon: Icon(
            icon,
            size: 30,
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
          content: (messages != null && messages.isNotEmpty)
              ? Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: buildAlertContent(messages),
                  ),
                )
              : null,
          actionsAlignment: MainAxisAlignment.center,
          actions: buildActionTextButtons(
              context: context, button1: actionButton1, button2: actionButton2),
        ),
      );
    },
  );
}

List<Widget> buildAlertContent(List<String> messages) {
  List<Widget> messagesList = [];

  for (var lineText in messages) {
    messagesList.add(Text(lineText));
    messagesList.add(const SizedBox(height: 25));
  }

  return messagesList;
}

List<Widget> buildActionTextButtons(
    {required BuildContext context, String? button1, String? button2}) {
  final backgroundColor = Theme.of(context).colorScheme.primary;

  final bool hasFirstButton =
      button1 != null && button1.isNotEmpty ? true : false;
  final bool hasSecondButton =
      button2 != null && button2.isNotEmpty ? true : false;

  final bool hasTwoButtons = hasFirstButton && hasSecondButton ? true : false;

  final primaryColor = MaterialStatePropertyAll<Color>(backgroundColor);
  const secondaryColor =
      MaterialStatePropertyAll<Color>(Color.fromARGB(255, 255, 255, 255));

  const primaryTextColor = Color.fromARGB(255, 204, 202, 202);
  const secondaryTextColor = Color.fromARGB(255, 151, 150, 150);

  final firstButtonColor = hasTwoButtons
      ? secondaryColor
      : hasFirstButton
          ? primaryColor
          : secondaryColor;
  final firstButtonTextColor = hasTwoButtons
      ? secondaryTextColor
      : hasFirstButton
          ? primaryTextColor
          : secondaryTextColor;

  final secondButtonColor = hasTwoButtons
      ? primaryColor
      : hasSecondButton
          ? primaryColor
          : secondaryColor;
  final secondButtonTextColor = hasTwoButtons
      ? primaryTextColor
      : hasSecondButton
          ? primaryTextColor
          : secondaryTextColor;

  const buttonSize = MaterialStatePropertyAll<Size>(Size(110, 50));

  List<Widget> actionButtons = [];
  if (hasFirstButton) {
    actionButtons.add(
      ElevatedButton(
        style: ButtonStyle(
            minimumSize: buttonSize,
            maximumSize: buttonSize,
            shape: const MaterialStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            )),
            backgroundColor: firstButtonColor),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(button1, style: TextStyle(color: firstButtonTextColor)),
      ),
    );
  }
  if (hasSecondButton) {
    actionButtons.add(
      ElevatedButton(
        style: ButtonStyle(
            minimumSize: buttonSize,
            maximumSize: buttonSize,
            shape: const MaterialStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            )),
            backgroundColor: secondButtonColor),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          button2,
          style: TextStyle(color: secondButtonTextColor),
        ),
      ),
    );
  }

  return actionButtons;
}

enum AlertType {
  USE_CHIP,
  FALLBACK_ERROR,
  LAST_PIN_INPUT_TRY,
  PIN_ERROR,
  PIN_ERROR_LAST_TRY,
  NO_PIN_ENTRY_TRIES,
  PIN_OK,
  FINISH_EMV_TANSAC,
  CARD_READER_ERROR
}
