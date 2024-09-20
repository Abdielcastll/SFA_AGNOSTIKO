import 'dart:async';

import 'package:agnostiko/agnostiko.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/utils/multitenant-config.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

import '../../services/utils/parameters.dart';
import 'add_payment.dart';

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

Future<ui.Image?> networkImageToUiImage(String imageUrl) async {
  try {
    // Fetch the image data from the network
    final http.Response response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      // Convert the raw bytes into a ui.Image
      Uint8List imageData = response.bodyBytes;
      final Completer<ui.Image> completer = Completer();

      ui.decodeImageFromList(imageData, (ui.Image img) {
        completer.complete(img);
      });

      return completer.future;
    } else {
      print('Failed to load image. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error loading image: $e');
    return null;
  }
}

Future invoicePrintLayout(AddPaymentBodyAtt invoice, String currentCoin) async {
  final products = objectBox.getAllShoppingCartProducts();

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

  listOfTextLine.add(
    PrinterText("TICKET #${invoice.invoiceNumber}".toUpperCase(),
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
    PrinterText(
      'ID: ${invoice.client.id.toString().toUpperCase()}',
      format: TextFormat(
        fontSize: 16,
        fontFamily: regularFont,
      ),
    ),
  );

  listOfTextLine.add(
    PrinterText(
      'Telefono: ${invoice.client.phone1.toString().toUpperCase()}',
      format: TextFormat(
        fontSize: 16,
        fontFamily: regularFont,
      ),
    ),
  );

  listOfTextLine.add(PrinterText.emptyLine(16));

  listOfTextLine.add(
    PrinterText(
      "Productos".toUpperCase(),
      format: TextFormat(
        fontSize: 16,
        fontFamily: regularFont,
      ),
      alignment: TextAlignment.Center,
    ),
  );

  listOfTextLine.add(
    PrinterText.emptyLine(16),
  );

  var productsCant = 0;

  for (final product in products) {
    final productPrice = double.parse(product.unitPrice!);
    listOfTextLine.add(
      PrinterSplitText(
        product.name ?? '-',
        priceFormatForPaidAmount(
            (productPrice * product.productQuantity!), currentCoin),
        format: TextFormat(
          fontSize: 16,
          fontFamily: regularFont,
        ),
      ),
    );

    listOfTextLine.add(
      PrinterText(
        '${product.productQuantity}  X  ${priceFormatForPaidAmount(productPrice, currentCoin)}',
        format: TextFormat(
          fontSize: 16,
          fontFamily: regularFont,
        ),
      ),
    );

    productsCant += product.productQuantity!;
  }

  listOfTextLine.add(
    PrinterText('Total Productos: $productsCant'.toUpperCase(),
        format: TextFormat(fontSize: 16, fontFamily: regularFont),
        alignment: TextAlignment.Center),
  );

  listOfTextLine.add(
    PrinterText.emptyLine(16),
  );

  listOfTextLine.add(
    PrinterSplitText(
      "SubTotal".toUpperCase(),
      priceFormatForPaidAmount(invoice.subTotal, currentCoin),
      format: TextFormat(
        fontSize: 16,
        fontFamily: regularFont,
      ),
    ),
  );

  listOfTextLine.add(
    PrinterSplitText(
      "Descuento".toUpperCase(),
      priceFormatForPaidAmount(invoice.discount, currentCoin),
      format: TextFormat(
        fontSize: 16,
        fontFamily: regularFont,
      ),
    ),
  );

  listOfTextLine.add(
    PrinterSplitText(
      "IVA (16%)".toUpperCase(),
      priceFormatForPaidAmount(invoice.tax, currentCoin),
      format: TextFormat(
        fontSize: 16,
        fontFamily: regularFont,
      ),
    ),
  );

  listOfTextLine.add(
    PrinterSplitText(
      "Total".toUpperCase(),
      priceFormatForPaidAmount(
        (invoice.subTotal - invoice.discount + invoice.tax).toStringAsFixed(4),
        currentCoin,
      ),
      format: TextFormat(
        fontSize: 16,
        fontFamily: regularFont,
      ),
    ),
  );

  listOfTextLine.add(PrinterText.emptyLine(16));

  listOfTextLine.add(
    PrinterText("Metodo(s) de pago".toUpperCase(),
        format: TextFormat(fontSize: 16, fontFamily: regularFont),
        alignment: TextAlignment.Center),
  );

  listOfTextLine.add(PrinterText.emptyLine(16));

  for (final pay in invoice.payments) {
    listOfTextLine.add(
      PrinterSplitText(
        pay.name.toUpperCase(),
        priceFormatForPaidAmount(
          exchangeAmount(
            amount: pay.amount,
            exchange: invoice.currencyExchange,
          ),
          currentCoin,
        ),
        format: TextFormat(
          fontSize: 16,
          fontFamily: regularFont,
        ),
      ),
    );
  }

  listOfTextLine.add(PrinterText.emptyLine(16));

  print(invoice.subTotal);
  print(invoice.discount);
  print(invoice.tax);
  print(currentCoin);
  print(invoice.payments.length);

  final printerScript = PrinterScript(listOfTextLine, gray: GrayIntensity.Dark);
  await printScript(printerScript, bottomFeed: true);
  await cutPaper();
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

  coin ??= 'Pesos Mexicanos - MXN';

  double correctAmount = double.parse(productPrice.toStringAsFixed(4));
  if (coin!.contains('MXN')) {
    return NumberFormat.currency(
      locale: 'es_MX',
      decimalDigits: 2,
      symbol: '\$',
    ).format(productPrice).toString();
  } else if (coin.contains('VED')) {
    return NumberFormat.currency(
      locale: 'es_VE',
      decimalDigits: 2,
      symbol: "Bs.",
    ).format(correctAmount / 4.58).toString();
  } else if (coin.contains('EUR')) {
    return NumberFormat.currency(
      locale: 'es_ES',
      decimalDigits: 2,
      symbol: '€',
    ).format(correctAmount / 0.89).toString();
  } else if (coin.contains('USD')) {
    return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
        .format(correctAmount / 19.43);
  } else if (coin.contains('BTC')) {
    return '฿ ${(correctAmount / 0.00011).toString()}';
  } else {
    return NumberFormat.currency(
      locale: 'es_VE',
      decimalDigits: 2,
      symbol: "PPR.",
    ).format(correctAmount / 4.58).toString();
  }
}
