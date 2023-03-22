import 'package:agnostiko/agnostiko.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/transaction_args.dart';
import 'dart:ui' as ui;

import '../../services/utils/parameters.dart';
import 'add_payment.dart';

Future invoicePrintLayout(AddPaymentBodyAtt invoice, String currentCoin) async {
  final products = objectBox.getAllShoppingCartProducts();

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

  listOfTextLine.add(
    PrinterText("Factura #${invoice.invoiceNumber}".toUpperCase(),
        format: TextFormat(fontSize: 16, fontFamily: regularFont),
        alignment: TextAlignment.Center),
  );

  final date = DateTime.now();

  listOfTextLine.add(PrinterText(
    '${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}',
    format: TextFormat(fontSize: 16, fontFamily: regularFont),
  ));

  listOfTextLine.add(PrinterText.emptyLine(16));

  listOfTextLine.add(
    PrinterText("Cliente".toUpperCase(),
        format: TextFormat(fontSize: 16, fontFamily: regularFont),
        alignment: TextAlignment.Center),
  );

  listOfTextLine.add(PrinterText.emptyLine(8));

  listOfTextLine.add(
    PrinterText(
      'Nombre: ${invoice.client.name.toString().toUpperCase()}',
      format: TextFormat(fontSize: 16, fontFamily: regularFont),
    ),
  );

  listOfTextLine.add(
    PrinterText(
      'ID: ${invoice.client.id.toString().toUpperCase()}',
      format: TextFormat(fontSize: 16, fontFamily: regularFont),
    ),
  );

  listOfTextLine.add(
    PrinterText(
      'Telefono: ${invoice.client.phone1.toString().toUpperCase()}',
      format: TextFormat(fontSize: 16, fontFamily: regularFont),
    ),
  );

  listOfTextLine.add(PrinterText.emptyLine(16));

  listOfTextLine.add(
    PrinterText("Productos".toUpperCase(),
        format: TextFormat(fontSize: 16, fontFamily: regularFont),
        alignment: TextAlignment.Center),
  );

  listOfTextLine.add(PrinterText.emptyLine(16));

  var productsCant = 0;

  for (final product in products) {
    final productPrice = double.parse(product.unitPrice!);
    listOfTextLine.add(PrinterSplitText(
        product.name ?? '-',
        priceFormatForPaidAmount(
            (productPrice * product.productQuantity!), currentCoin),
        format: TextFormat(fontSize: 16, fontFamily: regularFont)));

    listOfTextLine.add(PrinterText(
        '${product.productQuantity}  X  ${priceFormatForPaidAmount(productPrice, currentCoin)}',
        format: TextFormat(fontSize: 16, fontFamily: regularFont)));

    productsCant += product.productQuantity!;
  }

  listOfTextLine.add(PrinterText('Total Productos: $productsCant'.toUpperCase(),
      format: TextFormat(fontSize: 16, fontFamily: regularFont),
      alignment: TextAlignment.Center));

  listOfTextLine.add(PrinterText.emptyLine(16));

  listOfTextLine.add(PrinterSplitText("SubTotal".toUpperCase(),
      priceFormatForPaidAmount(invoice.subTotal, currentCoin),
      format: TextFormat(fontSize: 16, fontFamily: regularFont)));

  listOfTextLine.add(PrinterSplitText("Descuento".toUpperCase(),
      priceFormatForPaidAmount(invoice.discount, currentCoin),
      format: TextFormat(fontSize: 16, fontFamily: regularFont)));

  listOfTextLine.add(PrinterSplitText("IVA (16%)".toUpperCase(),
      priceFormatForPaidAmount(invoice.tax, currentCoin),
      format: TextFormat(fontSize: 16, fontFamily: regularFont)));

  listOfTextLine.add(PrinterSplitText(
      "Total".toUpperCase(),
      priceFormatForPaidAmount(
          (invoice.subTotal - invoice.discount + invoice.tax)
              .toStringAsFixed(2),
          currentCoin),
      format: TextFormat(fontSize: 16, fontFamily: regularFont)));

  listOfTextLine.add(PrinterText.emptyLine(16));

  listOfTextLine.add(
    PrinterText("Metodo(s) de pago".toUpperCase(),
        format: TextFormat(fontSize: 16, fontFamily: regularFont),
        alignment: TextAlignment.Center),
  );

  listOfTextLine.add(PrinterText.emptyLine(16));

  for (final pay in invoice.payments) {
    listOfTextLine.add(PrinterSplitText(pay.name.toUpperCase(),
        priceFormatForPaidAmount(pay.amount, currentCoin),
        format: TextFormat(fontSize: 16, fontFamily: regularFont)));
  }

  listOfTextLine.add(PrinterText.emptyLine(16));

  print(invoice.subTotal);
  print(invoice.discount);
  print(invoice.tax);
  print(currentCoin);
  print(invoice.payments.length);

  final printerScript =
      PrinterScript(listOfTextLine, gray: GrayIntensity.Medium);
  printScript(printerScript);
}

double _amountOfPayments(List<PayMethod> payments) {
  return payments.fold<double>(0, (value, element) => value + element.amount);
}

priceFormatForPaidAmount(productPrice, coin) {
  print('Coin $coin');
  print('productPrice $productPrice');

  if (productPrice is String) {
    productPrice = double.parse(productPrice.replaceAll('\$', ''));
  }

  coin ??= 'Dolares - USD';

  double correctAmount = double.parse(productPrice.toStringAsFixed(2));
  if (coin!.contains('USD')) {
    return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
        .format(productPrice)
        .toString();
  } else if (coin.contains('VED')) {
    return NumberFormat.currency(
      locale: 'es_VE',
      decimalDigits: 2,
      symbol: "Bs.",
    ).format(correctAmount * 4.58).toString();
  } else if (coin.contains('EUR')) {
    return NumberFormat.currency(
      locale: 'es_ES',
      decimalDigits: 2,
      symbol: '€',
    ).format(correctAmount * 0.89).toString();
  } else if (coin.contains('MXN')) {
    return NumberFormat.currency(
      locale: 'es_MX',
      decimalDigits: 2,
      symbol: '\$',
    ).format(correctAmount * 19.43);
  } else if (coin.contains('BTC')) {
    return '฿ ${(correctAmount * 0.00011).toString()}';
  } else {
    return NumberFormat.currency(
      locale: 'es_VE',
      decimalDigits: 2,
      symbol: "PPR.",
    ).format(correctAmount * 4.58).toString();
  }
}
