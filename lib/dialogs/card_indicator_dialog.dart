import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Muestra el 'semáforo' para indicación de retiro de tarjeta.
///
/// Retorna una función que permite pasar un booleano para cambiar el estatus
/// [waiting] del semáforo.
void Function(bool) showCardIndicatorDialog(
  BuildContext context,
  bool waiting,
) {
  final pleaseWaitMessage = AppLocalizations.of(context)!.pleaseWait;
  const removeCardMessage = "Alejar la tarjeta";

  StateSetter? setStateDialog;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          setStateDialog = setState;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: waiting ? Colors.green : Colors.red),
                SizedBox(width: 20),
                Text(waiting ? pleaseWaitMessage : removeCardMessage),
              ],
            ),
          );
        }),
      );
    },
  );

  return (bool flag) {
    setStateDialog!(() {
      waiting = flag;
    });
  };
}
