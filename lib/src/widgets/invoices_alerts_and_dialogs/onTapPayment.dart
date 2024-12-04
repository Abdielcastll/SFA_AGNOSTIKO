// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

import 'package:agnostiko/agnostiko.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/utils/parameters.dart';
import 'package:pwa_sales2go_flutter/src/utils/multitenant-config.dart';

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
          surfaceTintColor: Color.fromARGB(255, 222, 222, 222),
          actionsOverflowButtonSpacing: 1,
          actionsPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
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

Future<ui.Image?> networkImageToUiImage(String imageUrl) async {
  try {
    // Use the default cache manager to fetch the image file
    final cacheManager = DefaultCacheManager();
    final file = await cacheManager.getSingleFile(imageUrl);

    if (file != null) {
      // Read the file as bytes
      final Uint8List imageData = await file.readAsBytes();

      // Convert the raw bytes into a ui.Image
      final Completer<ui.Image> completer = Completer();
      ui.decodeImageFromList(imageData, (ui.Image img) {
        completer.complete(img);
      });

      return completer.future;
    } else {
      print('Failed to load image from cache.');
      return null;
    }
  } catch (e) {
    print('Error loading image: $e');
    return null;
  }
}

Future<String?> getDownloadUrl(String filePath) async {
  try {
    // Reference the file in Firebase Storage using the provided file path
    String downloadUrl =
        await FirebaseStorage.instanceFor(app: multitenantConfig.tenantApp!)
            .ref(filePath)
            .getDownloadURL();

    return downloadUrl;
  } catch (e) {
    print('Error fetching download URL: $e');
    return null;
  }
}

Future<String?> fetchDownloadLink() async {
  String? filePath = globalRemoteConfig.refLogoTicket!;
  String? downloadUrl = await getDownloadUrl(filePath);

  if (downloadUrl != null) {
    print('Download URL: $downloadUrl');
    return downloadUrl;
  } else {
    print('Failed to retrieve download URL');
    return null;
  }
}

Future printCancelTicket(int stan, String referenceNumber, double monto) async {
  List<PrinterObject> listOfTextLine = [];
  final terminalParameters = await loadTerminalParameters();

  String? urlLogoTicket = await fetchDownloadLink();
  ui.Image? logo = await networkImageToUiImage(urlLogoTicket ?? '');

  final byteDataLogo =
      await logo!.toByteData(format: ui.ImageByteFormat.rawRgba);
  final rgbaLogo = byteDataLogo?.buffer.asUint8List() ?? Uint8List.fromList([]);

  final maxWidth = await getPaperWidth();

  final imgLogo = PrinterImage(rgbaLogo, logo.width, logo.height,
      offsetX: (maxWidth / 2) - (logo.width / 2));

  // final logo = await assetsLogo.toPrinterImage(offsetX: maxWidth / 4);

  const specialFont = "DancingScript";
  const regularFont = "Roboto";

  listOfTextLine.add(imgLogo);

  listOfTextLine.add(PrinterText(
      "Promoción y Operación S.A. de C.V.".toUpperCase(),
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

  final printerScript = PrinterScript(listOfTextLine, gray: GrayIntensity.Dark);
  await printScript(printerScript, bottomFeed: true);
  await cutPaper();
}
