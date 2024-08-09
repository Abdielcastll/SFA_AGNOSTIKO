import 'package:flutter/material.dart';

import 'package:agnostiko/agnostiko.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';

import 'confirm_dialog.dart';

/// Retorna una función para asignar a callback 'onWillPop'.
///
/// Si se acepta, este Dialog cancela cualquier proceso de detección de tarjetas
/// o transacción que se esté llevando a cabo.
Future<bool> Function() cancelTransactionDialogFn(BuildContext context) {
  showDialogFn() async {
    final value = await showConfirmDialog(
      context,
      title: 'Confirmar',
      message: "¿Seguro que desea cancelar?",
      onAccept: () async {
        // Importante cerrar estos procesos correctamente para no tener problemas
        await closeCardReader();
        await cancelEmvTransaction();

        // Navigator.popUntil(context, (route) => route.isFirst == true);
        Navigator.pop(context, true);
        if (globalRemoteConfig.conversionKiosko! ||
            globalRemoteConfig.clientesEnabled! == false) {
          Navigator.pop(context, true);
          Navigator.pop(context, true);
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
