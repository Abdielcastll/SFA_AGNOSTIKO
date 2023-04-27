// ignore_for_file: use_build_context_synchronously

import 'package:agnostiko/agnostiko.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/dialogs/circular_progress_dialog.dart';
import 'package:pwa_sales2go_flutter/dialogs/confirm_dialog.dart';
import 'package:pwa_sales2go_flutter/pharos/pharos.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/transaction_args.dart';
import 'package:pwa_sales2go_flutter/src/pages/card_input/card_input.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';

Future<List?> onTapPayment(BuildContext context, payment, String pleaseWait,
    Client client, String invoiceId, int paymentIndex) async {
  if (payment['anulado'] == true || payment['conciliado'] == true) return null;

  final fecha = (payment['fecha'] as Timestamp).toDate();
  final hoy = DateTime.now();
  var permitirCancelacion = false;

  if (fecha.year == hoy.year &&
      fecha.month == hoy.month &&
      fecha.day == hoy.day &&
      fecha.hour < 22) {
    permitirCancelacion = true;
  }

  if (payment['metodo'].toString().toLowerCase().contains('tarjeta') &&
      payment['stan'] != null) {
    return await showDialog<List?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                if (permitirCancelacion)
                  TextButton(
                      onPressed: () async {
                        final newPayments = await cancel(context, payment,
                            pleaseWait, client, invoiceId, paymentIndex);
                        Navigator.pop(context, newPayments);
                      },
                      child: const Text('Realizar cancelación')),
                TextButton(
                    onPressed: () => refund(context, payment, pleaseWait,
                        client, invoiceId, paymentIndex),
                    child: const Text('Realizar devolución'))
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<List?> cancel(BuildContext context, payment, String pleaseWait,
    Client client, String invoiceId, int paymentIndex) async {
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

Future refund(BuildContext context, payment, String pleaseWait, Client client,
    String invoiceId, int paymentIndex) async {
  final platformInfo = await getPlatformInfo();

  showConfirmDialog(context,
      title: 'Confirmar',
      message: 'Realizar devolución?\n#Stan: ${payment['stan']}', onAccept: () {
    final transactionArgs = TransactionArgs(
      platformInfo: platformInfo,
      entryMode: EntryMode.Magstripe,
      showNumericKeyboard: !platformInfo.hasKeypad,
      supportedCardTypes: platformInfo.supportedCardTypes,
      emvTransactionType: EmvTransactionType.Refund,
    );
    transactionArgs.amountInCents = (payment['montoOriginal'] * 100).toInt();

    Navigator.pushReplacementNamed(context, CardInputView.route,
        arguments: [transactionArgs]);
  }, onCancel: () {
    Navigator.pop(context);
  });
}
