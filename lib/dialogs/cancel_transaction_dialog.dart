import 'package:flutter/material.dart';

import 'package:agnostiko/agnostiko.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';

import 'confirm_dialog.dart';

/// Retorna una función para asignar a callback 'onWillPop'.
///
/// Si se acepta, este Dialog cancela cualquier proceso de detección de tarjetas
/// o transacción que se esté llevando a cabo.
Future<bool> Function() cancelTransactionDialogFn(
  BuildContext context,
  Client? currentClient,
  int? nroCorrelativo,
  bool cancelPedido,
) {
  showDialogFn() async {
    final value = await showConfirmDialog(
      context,
      title: 'Confirmar',
      message: "¿Seguro que desea cancelar?",
      onAccept: () async {
        // Navigator.popUntil(context, (route) => route.isFirst == true);
        Navigator.pop(context, true);
        print("pop 1");

        if (globalRemoteConfig.conversionKiosko ??
            false || globalRemoteConfig.clientesEnabled == false) {
          Navigator.pop(context, true);
        } else if (globalRemoteConfig.onlyFullPaymentWithCard!) {
          print("pop 2 //maybe en pinpad no funciona igual");
          Navigator.pop(context, true);
          Navigator.pop(context, true);
        }
        // Importante cerrar estos procesos correctamente para no tener problemas
        await closeCardReader();
        print("closed readers");
        await cancelEmvTransaction();
        print("canceled emv");

        if (cancelPedido && globalRemoteConfig.onlyFullPaymentWithCard!) {
          await cancelPaymentProcess(currentClient!, nroCorrelativo!);
          print("cancel payment");
        }
      },
      onCancel: () {
        Navigator.pop(context, false);
      },
    );
    return value == true;
  }

  return showDialogFn;
}
