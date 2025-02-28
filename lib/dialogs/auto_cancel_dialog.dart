import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/services/utils/keypad.dart';

Future<bool?> displayAutoCancelDialog(BuildContext context,
    {String? title, String? message, Key? key}) async {
  await showConfirmDialog2(
    key: key,
    titleMessage: title ?? '¡Transacción Cancelada!',
    context,
    message: message ?? 'Tiempo de espera excedido',
    textAcceptButton: 'Aceptar',
    textCancelButton: 'Cancelar',
    secondButton: false,
    timeoutDialog: true,
    onAccept: () =>
        Navigator.popUntil(context, (route) => route.isFirst == true),
    onCancel: () {},
  );
  return true;
}

Future<bool?> showConfirmDialog2(
  BuildContext context, {
  Widget? icon,
  required String titleMessage,
  String message = '',
  String textAcceptButton = 'Aceptar',
  String textCancelButton = 'Cancelar',
  String textThirdButton = '',
  required void Function() onAccept,
  required void Function() onCancel,
  void Function()? onThirdButton,
  bool secondButton = true,
  bool thirdButton = false,
  bool timeoutDialog = false,
  Key? key,
}) {
  final backgroundColor = Theme.of(context).colorScheme.primary;

  final primaryColor = backgroundColor;

  final secondaryColor = Color.fromARGB(255, 151, 150, 150);

  if (textThirdButton.isEmpty || onThirdButton == null) {
    thirdButton = false;
  }

  print('showConfirmDialog Entro');
  return showDialog<bool?>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        key: key,
        onWillPop: () => Future.value(false),
        child: FutureBuilder(
          future: timeoutDialog
              ? Future.delayed(const Duration(seconds: 5))
                  .then((_) => onAccept())
              : null,
          builder: (context, snapshot) {
            return RawKeyboardListener(
              autofocus: true,
              focusNode: FocusNode(),
              onKey: rawKeypadHandler(
                context,
                onEnter: onAccept,
                onEscape: onCancel,
              ),
              child: AlertDialog(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                  icon: icon,
                  title: Text(titleMessage),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  content: message.isNotEmpty ? Text(message) : null,
                  actions: [
                    Wrap(
                      alignment: WrapAlignment
                          .center, // Centra los botones horizontalmente
                      spacing: 8.0, // Espacio entre botones
                      runSpacing: 8.0, // Espacio entre filas
                      children: <Widget>[
                        Visibility(
                          visible: thirdButton,
                          child: PrimaryButton(
                            onPressed: onThirdButton,
                            title: textThirdButton,
                            textColor: primaryColor,
                            borderRadius: 10,
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        PrimaryButton(
                          backgroundColor: primaryColor,
                          title: textAcceptButton,
                          textColor: const Color.fromARGB(255, 204, 202, 202),
                          borderRadius: 10,
                          onPressed: onAccept,
                        ),
                        Visibility(
                          visible: secondButton,
                          child: PrimaryButton(
                            onPressed: onCancel,
                            title: textCancelButton,
                            textColor: secondaryColor,
                            borderRadius: 10,
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ],
                    )
                  ]),
            );
          },
        ),
      );
    },
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.height = 55,
    this.width,
    required this.title,
    this.textStyle,
    this.backgroundColor,
    this.onPressed,
    this.borderRadius = 8,
    this.fontSize,
    this.textColor,
    this.disabledColor,
  });
  final String title;
  final double borderRadius;
  final double? height;
  final double? width;
  final double? fontSize;
  final Color? textColor;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? disabledColor;

  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0.5,
              backgroundColor: backgroundColor ?? colors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              )),
              disabledBackgroundColor: disabledColor),
          onPressed: onPressed,
          child: Text(title,
              textAlign: TextAlign.center,
              style: textStyle ??
                  TextStyle(
                      color: textColor ?? Colors.white, fontSize: fontSize))),
    );
  }
}
