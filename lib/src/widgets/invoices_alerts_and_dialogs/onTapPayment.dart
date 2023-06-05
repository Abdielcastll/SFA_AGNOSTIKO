// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:agnostiko/agnostiko.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pwa_sales2go_flutter/dialogs/circular_progress_dialog.dart';
import 'package:pwa_sales2go_flutter/dialogs/confirm_dialog.dart';
import 'package:pwa_sales2go_flutter/pharos/pharos.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/transaction_args.dart';
import 'package:pwa_sales2go_flutter/src/pages/card_input/card_input.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/add_payment.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/utils/parameters.dart';

/* Future<List?> onTapPayment(BuildContext context, payment, String pleaseWait,
    Client client, String invoiceId, int paymentIndex) async {
  if (payment['anulado'] == true ||
      payment['conciliado'] == true ||
      payment['refund'] == true) return null;

  final fecha = (payment['fecha'] as Timestamp).toDate();
  final hoy = DateTime.now();
  var permitirCancelacion = false;

  if (fecha.year == hoy.year &&
      fecha.month == hoy.month &&
      fecha.day == hoy.day &&
      fecha.hour < 22) {
    permitirCancelacion = true;
  }

  bool mostrarCancelacionDevolucion =
      payment['metodo'].toString().toLowerCase().contains('tarjeta') &&
          payment['stan'] != null;

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
                /* if (permitirCancelacion) */
                TextButton(
                  onPressed: () async {
                    final newPayments = await cancel(context, payment,
                        pleaseWait, client, invoiceId, paymentIndex);
                    Navigator.pop(context, newPayments);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.block_rounded),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Realizar cancelación'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => refund(context, payment, pleaseWait, client,
                      invoiceId, paymentIndex),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.currency_exchange_rounded),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Realizar devolución'),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
  return null;
} */

Future<List?> cancel(BuildContext context, payment, String pleaseWait,
    Client client, String invoiceId, int paymentIndex) async {
  final newPayments = await showConfirmDialog<List?>(context,
      title: 'Confirmar',
      message: '¿Cancelar transacción?\n#Stan: ${payment['stan']}',
      onAccept: () async {
    showCircularProgressDialog(context, 'Cancelando pago...');
    final res = await onVoidExecute(
        context, payment['stan'], pleaseWait, 'Cancelación');
    if (res) {
      await printCancelTicket(payment['stan'],
          payment['referenceNumber'].toString(), payment['montoOriginal']);
    }
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

  showDialog<List?>(
      context: context,
      builder: (_) {
        final amountController =
            TextEditingController(text: payment['montoOriginal'].toString());
        String? errorText;

        onAccept() {
          final amount = double.parse(amountController.text);
          if (amount > payment['montoOriginal']) {
            return;
          }

          if (amount <= 0) {
            return;
          }

          final transactionArgs = TransactionArgs(
              platformInfo: platformInfo,
              entryMode: EntryMode.Magstripe,
              showNumericKeyboard: !platformInfo.hasKeypad,
              supportedCardTypes: platformInfo.supportedCardTypes,
              emvTransactionType: EmvTransactionType.Refund,
              referenceNumber: payment["referenceNumber"].toString());

          transactionArgs.amountInCents = (amount * 100).toInt();
          transactionArgs.currencyCode = payment["currencyCode"];
          transactionArgs.invoice = InvoiceData(
              client,
              invoiceId,
              payment['codigoMoneda'],
              amount * -1,
              0,
              '',
              DateTime.now(),
              0,
              payment['tasaDeCambio']);

          Navigator.pushReplacementNamed(context, CardInputView.route,
              arguments: [transactionArgs, client, invoiceId, paymentIndex]);
        }

        onCancel() {
          Navigator.pop(context);
        }

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Center(child: Text('Confirmar')),
          content: SingleChildScrollView(
              child: Column(
            children: [
              Text(
                'Realizar devolución?\n# Referencia: ${payment['referenceNumber']}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Monto de la devolucion",
                    errorText: errorText,
                    helperText: 'No ingrese montos mayores al pago.'),
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  DecimalTextInputFormatter(decimalRange: 2),
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]*(\.[0-9]{0,2})?$'))
                ],
              ),
            ],
          )),
          actions: <Widget>[
            ElevatedButton(
              onPressed: onAccept,
              child: const Text("Aceptar"),
            ),
            ElevatedButton(
              onPressed: onCancel,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.grey.shade400),
                foregroundColor:
                    MaterialStateProperty.all(Colors.grey.shade400),
              ),
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        );
      });
}

Future printCancelTicket(int stan, String referenceNumber, double monto) async {
  final emv = EmvModule.instance;

  List<PrinterObject> listOfTextLine = [];
  final terminalParameters = await loadTerminalParameters();

  const assetsLogo = AssetImage("assets/images/agn_blue.png");

  ui.Image logo = await assetsLogo.toUiImage();

  final byteDataLogo =
      await logo.toByteData(format: ui.ImageByteFormat.rawRgba);
  final rgbaLogo = byteDataLogo?.buffer.asUint8List() ?? Uint8List.fromList([]);

  final maxWidth = await getPaperWidth();

  // final img = await bytesToUiImage(rgbaLogo, logo.width, logo.height);
  final imgLogo =
      PrinterImage(rgbaLogo, logo.width, logo.height, offsetX: maxWidth / 4);

  // final logo = await assetsLogo.toPrinterImage(offsetX: maxWidth / 4);

  const specialFont = "DancingScript";
  const regularFont = "Roboto";

  listOfTextLine.add(imgLogo);

  listOfTextLine.add(PrinterText("Agnostiko SFA".toUpperCase(),
      format: TextFormat(fontSize: 16, fontFamily: specialFont),
      alignment: TextAlignment.Center));

  final afiliacion = terminalParameters.acquirerId;
  final terminalId = terminalParameters.terminalId;

  final line3Part1 = afiliacion.toHexStr();
  final line3 = line3Part1 + "-" + terminalId;
  listOfTextLine.add(PrinterText(line3.toUpperCase(),
      format: TextFormat(fontSize: 16, fontFamily: specialFont),
      alignment: TextAlignment.Center));
  listOfTextLine.add(PrinterText.emptyLine(16));

  final dateFormatter = DateFormat('dd-MMM-yyyy');
  final timeFormatter = DateFormat('h:mm a');

  final date = dateFormatter.format(DateTime.now());
  final hora = timeFormatter.format(DateTime.now());
  listOfTextLine.add(PrinterSplitText(
    date..toUpperCase(),
    hora.toUpperCase(),
    format: TextFormat(fontSize: 16, fontFamily: regularFont),
  ));

  listOfTextLine.add(PrinterText.emptyLine(32));

  listOfTextLine.add(
    PrinterText("Cancelación".toUpperCase(),
        format: TextFormat(fontSize: 16, fontFamily: regularFont),
        alignment: TextAlignment.Center),
  );

  listOfTextLine.add(PrinterSplitText("Total:".toUpperCase(), monto.toString(),
      format: TextFormat(fontSize: 16, fontFamily: regularFont)));

  listOfTextLine.add(PrinterText.emptyLine(16));
  listOfTextLine.add(PrinterText("Stan: $stan".toUpperCase(),
      format: TextFormat(fontSize: 16, fontFamily: regularFont)));
  listOfTextLine.add(PrinterText(
      "Numero de Referencia: ${int.parse(referenceNumber)}".toUpperCase(),
      format: TextFormat(fontSize: 16, fontFamily: regularFont)));

  listOfTextLine.add(PrinterText.emptyLine(16));

  listOfTextLine.add(PrinterText('FIRMA:______________________________',
      format: TextFormat(fontSize: 16, fontFamily: regularFont)));

  listOfTextLine.add(PrinterText.emptyLine(16));

  listOfTextLine.add(PrinterText(
      'he leido y acepto los terminos y condiciones.'.toUpperCase(),
      format: TextFormat(fontSize: 14, fontFamily: regularFont),
      alignment: TextAlignment.Center));

  listOfTextLine.add(PrinterText('powered by pharos payments'.toUpperCase(),
      format: TextFormat(fontSize: 14, fontFamily: regularFont),
      alignment: TextAlignment.Center));

  listOfTextLine.add(PrinterText.emptyLine(16));

  final printerScript =
      PrinterScript(listOfTextLine, gray: GrayIntensity.Medium);
  printScript(printerScript);
}

String? getMonth(String monthNum) {
  switch (monthNum) {
    case "01":
      return "ENE";
    case "02":
      return "FEB";
    case "03":
      return "MAR";
    case "04":
      return "ABR";
    case "05":
      return "MAY";
    case "06":
      return "JUN";
    case "07":
      return "JUL";
    case "08":
      return "AGO";
    case "09":
      return "SEP";
    case "10":
      return "OCT";
    case "11":
      return "NOV";
    case "12":
      return "DIC";
  }
  return null;
}
