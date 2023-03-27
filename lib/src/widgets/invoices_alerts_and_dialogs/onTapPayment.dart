import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/dialogs/confirm_dialog.dart';
import 'package:pwa_sales2go_flutter/pharos/pharos.dart';

onTapPayment(BuildContext context, payment, String pleaseWait) async {
  if (payment['metodo'].toString().toLowerCase().contains('tarjeta') &&
      payment['stan'] != null) {
    showConfirmDialog(context,
        title: 'Confirmar',
        message: '¿Cancelar transacción?\n#Stan: ${payment['stan']}',
        onAccept: () async {
      await onVoidExecute(context, payment['stan'], pleaseWait, 'Cancelación');
      Navigator.pop(context);
    }, onCancel: () {
      Navigator.pop(context);
    });
  }
}
