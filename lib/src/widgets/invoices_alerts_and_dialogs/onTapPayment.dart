import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/dialogs/circular_progress_dialog.dart';
import 'package:pwa_sales2go_flutter/dialogs/confirm_dialog.dart';
import 'package:pwa_sales2go_flutter/pharos/pharos.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';

Future<List?> onTapPayment(BuildContext context, payment, String pleaseWait,
    Client client, String invoiceId, int paymentIndex) async {
  if (payment['anulado'] == true || payment['conciliado'] == true) return null;

  if (payment['metodo'].toString().toLowerCase().contains('tarjeta') &&
      payment['stan'] != null) {
    final newPayments = await showConfirmDialog<List?>(context,
        title: 'Confirmar',
        message: '¿Cancelar transacción?\n#Stan: ${payment['stan']}',
        onAccept: () async {
      await onVoidExecute(context, payment['stan'], pleaseWait, 'Cancelación');
      showCircularProgressDialog(context, 'Cancelando pago...');
      final newPayments = await cancelPayment(client, invoiceId, paymentIndex);
      Navigator.pop(context);
      Navigator.pop(context, newPayments);
    }, onCancel: () {
      Navigator.pop(context, null);
    });

    return newPayments;
  }
}
