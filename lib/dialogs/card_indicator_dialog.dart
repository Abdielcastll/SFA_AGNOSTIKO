import 'package:agnostiko/cards/src/card_reader.dart';
import 'package:flutter/material.dart';

/// Muestra el 'semáforo' para indicación de retiro de tarjeta.
///
/// Retorna una función que permite pasar un booleano para cambiar el estatus
/// [waiting] del semáforo.
void Function(bool) showCardIndicatorDialog(
  BuildContext context,
  bool waiting,
) {
  const pleaseWaitMessage = "No retire la tarjeta";
  const removeCardMessage = "Alejar la tarjeta";

  StateSetter? setStateDialog;

  Future? timer;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          timer = Future.delayed(
            const Duration(seconds: 30),
            () async {
              await closeCardReader();
            },
          );

          setStateDialog = setState;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: waiting ? Colors.green : Colors.red),
                SizedBox(width: 20),
                Text(
                    "${waiting ? pleaseWaitMessage : removeCardMessage}\nContactless...",
                    textAlign: TextAlign.center),
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
      timer = null;
    });
  };
}
