import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:agnostiko/agnostiko.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/dialogs/circular_progress_dialog.dart';
import 'package:pwa_sales2go_flutter/dialogs/info_dialog.dart';
import 'package:pwa_sales2go_flutter/pharos/pharos.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_rol_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/diary_tabs.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/completed_pay.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/utils/comm.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';

/* import '../../config/app_config.dart'; */
import '../../../dialogs/param_bitmap_dialog.dart';
import '../../models/transaction_args.dart';
import '../../services/utils/emv.dart';
import '../../services/utils/keypad.dart';
import '../../services/utils/parameters.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../place_order/add_payment.dart';

class EmvTransactionInfoView extends StatefulWidget {
  static String route = "/emvTransactionInfo";

  @override
  _EmvTransactionInfoViewState createState() => _EmvTransactionInfoViewState();
}

class _EmvTransactionInfoViewState extends State<EmvTransactionInfoView> {
  bool flagPrint = true;
  TransactionArgs? transactionArgs;
  InfoTags? infoTags;
  Map<int, Uint8List?>? firstGenerateTags;
  Map<int, Uint8List?>? secondGenerateTags;

  EmvTransactionResult? transactionResult;

  getEmvTags() async {
    final emvModule = EmvModule.instance;
    print('EMV TAGS');

    final tag5A = await emvModule.getTagValue(0x5A);
    final tag57 = await emvModule.getTagValue(0x57);
    final tag5F34 = await emvModule.getTagValue(0x5F34);
    print(tag5F34?.toHexStr());
    print(tag5A?.toHexStr());
    print(tag57?.toHexStr().split('d')[0]);
  }

  @override
  Widget build(BuildContext context) {
    getEmvTags();

    String approvedStr = AppLocalizations.of(context)!.approved.toUpperCase();
    String declinedStr = AppLocalizations.of(context)!.declined.toUpperCase();
    String failedStr = AppLocalizations.of(context)!.failed.toUpperCase();
    String offlineStr = AppLocalizations.of(context)!.offline.toUpperCase();
    String onlineStr = AppLocalizations.of(context)!.online.toUpperCase();

    String transactionResultStr = failedStr;
    String transactionOnlineStr = offlineStr;

    if (transactionArgs == null) {
      transactionArgs = (ModalRoute.of(context)?.settings.arguments! as List)[0]
          as TransactionArgs;

      // se supone que al llegar a esta pantalla es porque la transacción finalizó
      // por lo tanto podemos extraer toda la data que haga falta del listener
      firstGenerateTags = transactionArgs?.firstGenerateTags;
      secondGenerateTags = transactionArgs?.secondGenerateTags;
      infoTags = transactionArgs?.infoTags;

      final transactionInfo = transactionArgs?.transactionInfo;
      final transactionResult = transactionInfo?.result;
      this.transactionResult = transactionResult;

      if (transactionArgs!.emvTransactionType != EmvTransactionType.Refund) {
        switch (transactionResult) {
          case EmvTransactionResult.Approved:
            final referenceNumber =
                int.parse(transactionArgs!.referenceNumber!);
            print('referenceNumber');
            print(referenceNumber);
            transactionResultStr = approvedStr;
            Future.delayed(Duration.zero, () {
              // TODO: REGISTRAR PAGO EN DB
              print('Pago Aprobado - Registrando pago de Tarjeta en DB');
              registerDebitCreditCardPayment(
                      transactionArgs!.invoice!,
                      transactionArgs!.stan,
                      referenceNumber,
                      transactionArgs!.currencyCode!)
                  .whenComplete(() {
                checkIfInvoiceIsCompleted(
                  paidAmount: transactionArgs!.invoice!.amount,
                  remaining: transactionArgs!.invoice!.remaining,
                  client: transactionArgs!.invoice!.client,
                  invoiceDocumentID:
                      transactionArgs!.invoice!.invoiceDocumentID,
                );
              });
            });
            break;
          case EmvTransactionResult.Denied:
            print('Pago denegado');
            transactionResultStr = declinedStr;
            break;
          default:
            print('Pago Fallido');
            break;
        }
      } else {
        switch (transactionResult) {
          case EmvTransactionResult.Approved:
            final referenceNumber =
                int.parse(transactionArgs!.referenceNumber!);
            print('referenceNumber');
            print(referenceNumber);

            transactionResultStr = approvedStr;

            registerDebitCreditCardPayment(
                transactionArgs!.invoice!,
                transactionArgs!.stan,
                referenceNumber,
                transactionArgs!.currencyCode!,
                refund: true);
            // cancelPayment(client, invoiceId, paymentIndex);
            break;
          case EmvTransactionResult.Denied:
            print('Devolucion denegada');
            transactionResultStr = declinedStr;
            break;
          default:
            print('Devolucion Fallida');
            break;
        }
      }

      transactionOnlineStr =
          transactionInfo?.onlineRequested == true ? onlineStr : offlineStr;

      if (flagPrint) {
        // printTicket();
        flagPrint = false;
      }
    }

    final firstGenerateTiles = _generateCommandTiles(
      '1st GENERATE AC',
      firstGenerateTags,
    );
    final secondGenerateTiles = _generateCommandTiles(
      '2nd GENERATE AC',
      secondGenerateTags,
    );

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: rawKeypadHandler(context, onEscape: () {
          Navigator.pop(context);
        }),
        child: Scaffold(
          appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.emvTransactionInfo),
              automaticallyImplyLeading: false),
          body: ListView(
            children: [
              const Text(''),
              Text(
                "${AppLocalizations.of(context)!.transaction} $transactionResultStr - $transactionOnlineStr",
                style: TextStyle(
                  color: this.transactionResult == EmvTransactionResult.Approved
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                transactionArgs!.isFallback ? 'Error de Chip' : '',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const Divider(),
              if (!transactionArgs!.isFallback)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      height: 50,
                      width: 120,
                      child: SvgPicture.asset(
                        infoTags?.cardNo?.toHexStr().substring(0, 1) == '5' ||
                                transactionArgs?.transactionInfo?.kernelType ==
                                    ContactlessKernelType.PayPass
                            ? 'assets/images/mastercard.svg'
                            : 'assets/images/visa.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            if (transactionArgs
                                    ?.transactionInfo?.isContactless ==
                                true)
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                height: 50,
                                width: 120,
                                child: Image.asset(
                                  'assets/images/contactless.jpeg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            Text(
                              '''**** ${(infoTags?.cardNo?.toHexStr() ?? transactionArgs?.pan)?.substring(12) ?? '-'}''',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ],
                ),
              if (!transactionArgs!.isFallback) const Divider(),
              ListTile(
                enableFeedback: true,
                title: Text(
                    '${AppLocalizations.of(context)!.transactionType} (9C)'),
                subtitle: Text(
                  infoTags?.transactionType?.toHexStr().toUpperCase() ?? '-',
                ),
                onTap: () {},
              ),
              ListTile(
                enableFeedback: true,
                title: Text('${AppLocalizations.of(context)!.amount} (9F02)'),
                subtitle: Text(_amountString),
                onTap: () {},
              ),
              ListTile(
                enableFeedback: true,
                title: Text(
                    '${AppLocalizations.of(context)!.cashbackAmount} (9F03)'),
                subtitle: Text(_amountOtherString),
                onTap: () {},
              ),
              /* if (_kernelTypeStr != null)
                ListTile(
                  enableFeedback: true,
                  title: const Text('Kernel Type'),
                  subtitle: Text(_kernelTypeStr ?? ''),
                  onTap: () {},
                ),
              ListTile(
                enableFeedback: true,
                title: const Text('PAN (5A)'),
                subtitle:
                    Text(infoTags?.cardNo?.toHexStr().toUpperCase() ?? '-'),
                onTap: () {},
              ),
              ListTile(
                enableFeedback: true,
                title: const Text('AID (9F06)'),
                subtitle: Text(infoTags?.aid?.toHexStr().toUpperCase() ?? '-'),
                onTap: () {},
              ),
              ListTile(
                enableFeedback: true,
                title: const Text('AIP (82)'),
                subtitle: Text(infoTags?.aip?.toHexStr().toUpperCase() ?? '-'),
                onTap: _onTapAip,
              ),
              const Divider(),
              ...firstGenerateTiles,
              ...secondGenerateTiles,
              ListTile(
                enableFeedback: true,
                title: Text(AppLocalizations.of(context)!.appliedCVM),
                subtitle: Text(_getCvmTypeStr(infoTags?.cvmResults)),
                onTap: () {},
              ),
              ListTile(
                enableFeedback: true,
                title: const Text('Terminal Capabilities (9F33)'),
                subtitle: Text(
                  infoTags?.terminalCapabilities?.toHexStr().toUpperCase() ??
                      '-',
                ),
                onTap: _onTapTerminalCapabilities,
              ),
              ListTile(
                enableFeedback: true,
                title: const Text('CVM List (8E)'),
                subtitle: Text(
                  infoTags?.cvmList?.toHexStr().toUpperCase() ?? '-',
                ),
                onTap: () {},
              ),
              ListTile(
                enableFeedback: true,
                title: const Text('ATC (9F36)'),
                subtitle: Text(infoTags?.atc?.toHexStr().toUpperCase() ?? '-'),
                onTap: () {},
              ), */

              if (!transactionArgs!.isFallback)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 16.0),
                  child: OutlinedButton(
                      onPressed: () {
                        printTicket();
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: myTheme.colorScheme.primary,
                          backgroundColor: Colors.blue.shade800),
                      child: Text(
                        'imprimir comprobante'.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Poppins-regular',
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              /* if (transactionArgs!.isFallback && transactionArgs!.stan != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 16.0),
                  child: OutlinedButton(
                      onPressed: () {
                        onVoidExecute(
                            context,
                            transactionArgs!.stan ?? 0,
                            AppLocalizations.of(context)!.pleaseWait,
                            'Reverso');
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: myTheme.colorScheme.primary,
                          backgroundColor: Colors.blue.shade800),
                      child: Text(
                        'Realizar reverso'.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Poppins-regular',
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ), */
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                child: OutlinedButton(
                    onPressed: onAccept,
                    style: TextButton.styleFrom(
                        foregroundColor: myTheme.colorScheme.primary,
                        backgroundColor: Colors.blue.shade800),
                    child: Text(
                      'aceptar'.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  onAccept() {
    if (transactionArgs!.emvTransactionType == EmvTransactionType.Refund) {
      Navigator.popUntil(context, (route) => route.isFirst == true);
      return;
    }

    final noRetail = (ModalRoute.of(context)?.settings.arguments! as List)[3];

    if (noRetail) {
      Navigator.pop(context);
      Navigator.pop(context);
      return;
    }
    final paymentBody = (ModalRoute.of(context)?.settings.arguments! as List)[2]
        as AddPaymentBodyAtt;

    // final payed = transactionResult == EmvTransactionResult.Approved
    //     ? exchangeAmount(
    //         coin: paymentBody.currency,
    //         amount: _amountDouble,
    //         exchange: transactionArgs!.invoice!.coinExchangeRatio)
    //     : 0.0;
    final payed = transactionResult == EmvTransactionResult.Approved
        ? exchangeAmount(
            coin: paymentBody.currency,
            amount: _amountDouble,
            exchange: transactionArgs!.invoice!.coinExchangeRatio)
        : 0.0;

    print('EMV INFO PAYMENTS');
    print(paymentBody.payments.length);
    print(paymentBody.remaining);
    print(paymentBody.currency);
    print(paymentBody.amountPaied);
    print(payed);

    paymentBody.payments.add(PayMethod('Tarjeta', _amountDouble));

    final totalPayed =
        paymentBody.payments.fold<double>(0.0, (previousValue, element) {
      print(element.amount);
      return previousValue + element.amount;
    });

    // final totalInvoice =
    //     paymentBody.subTotal + paymentBody.tax - paymentBody.discount;
    final totalInvoice = transactionArgs!.invoice!.totalOfTheOrder;
    final remainingConverted = priceMultipliedByItsExchangeRatio(
        coinDecimals: 2,
        coinExchangeRatio: transactionArgs!.invoice!.coinExchangeRatio,
        productPrice: transactionArgs!.invoice!.remaining);
    // paidAmount < remainingConverted
    // if (transactionResult == EmvTransactionResult.Approved &&
    //     totalPayed >= totalInvoice) {
    if (transactionResult == EmvTransactionResult.Approved &&
        transactionArgs!.invoice!.amount >= remainingConverted) {
      final date = transactionArgs!.invoice!.date;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => CompletedPayPage(
              client: transactionArgs!.invoice!.client,
              total: transactionArgs!.invoice!.totalOfTheOrder,
              method: "Tarjeta",
              date:
                  '${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}',
              address: '',
              coinsExchangeRates: [],
              addPaymentBody: paymentBody),
        ),
      );
    } else {
      print(paymentBody.remaining);
      print(paymentBody.amountPaied);
      print(payed);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: 'PAGO-DIRECTO'),
          builder: (BuildContext context) => AddPaymentPage(
            remaining: paymentBody.remaining - payed,
            subTotal: paymentBody.subTotal,
            discountPercentage: paymentBody.discountPercentage,
            discount: paymentBody.discount,
            tax: paymentBody.tax,
            percentageTax: paymentBody.percentageTax,
            client: paymentBody.client,
            invoiceDocumentID: paymentBody.invoiceDocumentID,
            invoiceNumber: paymentBody.invoiceNumber,
            payments: paymentBody.payments,
            amountPayed: (paymentBody.amountPaied ?? 0) + payed,
            invoiceTotal: transactionArgs!.invoice!.totalOfTheOrder,
            // updatePayed: updatePayed,
          ),
        ),
      );
      /* (ModalRoute.of(context)?.settings.arguments!
                            as List)[1](payed); */
      // Navigator.pop(context, payed);
    }
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

  void printTicket() async {
    final emv = EmvModule.instance;

    List<PrinterObject> listOfTextLine = [];
    final terminalParameters = await loadTerminalParameters();

    const assetsLogo = AssetImage("assets/images/agn_blue.png");

    ui.Image logo = await assetsLogo.toUiImage();

    final byteDataLogo =
        await logo.toByteData(format: ui.ImageByteFormat.rawRgba);
    final rgbaLogo =
        byteDataLogo?.buffer.asUint8List() ?? Uint8List.fromList([]);

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

    final fechaTag = await emv.getTagValue(0x9a);
    final horaTag = await emv.getTagValue(0x9f21);
    String fecha = "";
    String hora = "";
    if (fechaTag != null) {
      final dd = fechaTag[2].toRadixString(16).padLeft(2, "0");
      final mmNum = fechaTag[1].toRadixString(16).padLeft(2, "0");
      final mm = getMonth(mmNum);
      final yy = fechaTag[0].toRadixString(16).padLeft(2, "0");
      fecha = "Fecha $dd$mm$yy";
    }
    if (horaTag != null) {
      final hh = horaTag[0].toRadixString(16).padLeft(2, "0");
      final mm = horaTag[1].toRadixString(16).padLeft(2, "0");
      hora = "Hora $hh:$mm";
    }
    listOfTextLine.add(PrinterSplitText(
      fecha.toUpperCase(),
      hora.toUpperCase(),
      format: TextFormat(fontSize: 16, fontFamily: regularFont),
    ));

    listOfTextLine.add(PrinterText.emptyLine(32));

    final cardTag = transactionArgs?.pan;
    if (cardTag != null) {
      final cardlength = cardTag.length;
      String cardResult =
          cardTag.replaceRange(0, cardlength - 4, '*' * (cardlength - 4));
      listOfTextLine.add(PrinterText('Tarjeta: ${cardResult.toUpperCase()}',
          format:
              TextFormat(fontSize: 16, bold: true, fontFamily: regularFont)));
    }

    final cardBrand = infoTags?.cardNo?.toHexStr().substring(0, 1) == '5'
        ? 'Mastercard'
        : 'Visa';
    listOfTextLine.add(PrinterText.emptyLine(32));
    listOfTextLine.add(
      PrinterText(cardBrand.toUpperCase(),
          format: TextFormat(fontSize: 16, fontFamily: regularFont),
          alignment: TextAlignment.Center),
    );

    listOfTextLine.add(PrinterText.emptyLine(16));

    if (transactionArgs!.emvTransactionType == EmvTransactionType.Refund) {
      listOfTextLine.add(
        PrinterText("Devolución".toUpperCase(),
            format: TextFormat(fontSize: 16, fontFamily: regularFont),
            alignment: TextAlignment.Center),
      );
    } else {
      final paymentBody = (ModalRoute.of(context)?.settings.arguments!
          as List)[2] as AddPaymentBodyAtt;

      listOfTextLine.add(
        PrinterText("Venta #${paymentBody.invoiceNumber}".toUpperCase(),
            format: TextFormat(fontSize: 16, fontFamily: regularFont),
            alignment: TextAlignment.Center),
      );
    }

    listOfTextLine.add(PrinterText(
        transactionResult == EmvTransactionResult.Approved
            ? 'PAGO APROBADO'
            : 'PAGO RECHAZADO',
        format: TextFormat(fontSize: 16, fontFamily: regularFont)));
    listOfTextLine.add(PrinterSplitText("Total:".toUpperCase(), _amountString,
        format: TextFormat(fontSize: 16, fontFamily: regularFont)));

    final contactlessBool = transactionArgs?.transactionInfo?.isContactless;
    /* switch (contactlessBool) {
      case false:
        listOfTextLine.add(
          PrinterText("I@1".toUpperCase(),
              format: TextFormat(fontSize: 16, fontFamily: regularFont)),
        );
        break;
      case true:
        listOfTextLine.add(
          PrinterText("C@1".toUpperCase(),
              format: TextFormat(fontSize: 16, fontFamily: regularFont)),
        );
        break;
    } */

    listOfTextLine.add(PrinterText.emptyLine(16));
    listOfTextLine.add(PrinterText(
        "Stan: ${transactionArgs!.stan}".toUpperCase(),
        format: TextFormat(fontSize: 16, fontFamily: regularFont)));
    listOfTextLine.add(PrinterText(
        "Numero de Referencia: ${int.parse(transactionArgs!.referenceNumber!)}"
            .toUpperCase(),
        format: TextFormat(fontSize: 16, fontFamily: regularFont)));
    listOfTextLine.add(PrinterText("ARQC: E47BF856EDEB5B31".toUpperCase(),
        format: TextFormat(fontSize: 16, fontFamily: regularFont)));

    String? aid;
    final auxAid1 = await emv.getTagValue(0x9f06);
    final auxAid2 = await emv.getTagValue(0x84);
    if (auxAid1 != null) {
      aid = auxAid1.toHexStr();
    } else if (auxAid2 != null) {
      aid = auxAid2.toHexStr();
    }
    if (aid != null) {
      listOfTextLine.add(PrinterText("AID:".toUpperCase() + aid.toUpperCase(),
          format: TextFormat(fontSize: 16, fontFamily: regularFont)));
    }

    listOfTextLine.add(PrinterText.emptyLine(16));

    listOfTextLine.add(PrinterText('FIRMA:______________________________',
        format: TextFormat(fontSize: 16, fontFamily: regularFont)));

    listOfTextLine.add(PrinterText.emptyLine(16));

    final nombreTarjetahabiente = await emv.getTagValue(0x5f20);

    switch (contactlessBool) {
      case false:
        if (_getCvmTypeStr(infoTags?.cvmResults) == "FIRMA") {
          if (nombreTarjetahabiente != null) {
            listOfTextLine.add(PrinterText(
                const AsciiCodec().decode(nombreTarjetahabiente).toUpperCase(),
                format: TextFormat(fontSize: 16, fontFamily: regularFont),
                alignment: TextAlignment.Center));
          }
        } else if (_getCvmTypeStr(infoTags?.cvmResults) ==
            'PIN OFFLINE EN CLARO') {
          listOfTextLine.add(PrinterText(
              "AUTORIZADO MEDIANTE FIRMA ELECTRÓNICA".toUpperCase(),
              format: TextFormat(fontSize: 12, fontFamily: regularFont),
              alignment: TextAlignment.Center));
          if (nombreTarjetahabiente != null) {
            listOfTextLine.add(PrinterText(
                const AsciiCodec().decode(nombreTarjetahabiente).toUpperCase(),
                format: TextFormat(fontSize: 12, fontFamily: regularFont),
                alignment: TextAlignment.Center));
          }
        } else {
          if (nombreTarjetahabiente != null) {
            listOfTextLine.add(PrinterText(
                const AsciiCodec().decode(nombreTarjetahabiente).toUpperCase(),
                format: TextFormat(fontSize: 12, fontFamily: regularFont),
                alignment: TextAlignment.Center));
          }
        }
        break;
      case true:
        listOfTextLine.add(PrinterText(
            "AUTORIZADO SIN AUTENTICACIÓN DEL TARJETAHABIENTE".toUpperCase(),
            format: TextFormat(fontSize: 12, fontFamily: regularFont),
            alignment: TextAlignment.Center));
        if (nombreTarjetahabiente != null) {
          listOfTextLine.add(PrinterText(
              const AsciiCodec().decode(nombreTarjetahabiente).toUpperCase(),
              format: TextFormat(fontSize: 12, fontFamily: regularFont),
              alignment: TextAlignment.Center));
        }
        break;
    }

    listOfTextLine.add(PrinterText.emptyLine(16));

    listOfTextLine.add(PrinterText(
        'he leido y acepto los terminos y condiciones.'.toUpperCase(),
        format: TextFormat(fontSize: 14, fontFamily: regularFont),
        alignment: TextAlignment.Center));

    listOfTextLine.add(PrinterText('powered by pharos payments'.toUpperCase(),
        format: TextFormat(fontSize: 14, fontFamily: regularFont),
        alignment: TextAlignment.Center));

    /* listOfTextLine.add(PrinterText.emptyLine(24));

    listOfTextLine.add(PrinterText(
        "PAGADERE NEGOCIABLE UNICAMENTE CON INSTITUCIONES DE CRÉDITO",
        format: TextFormat(fontSize: 12, fontFamily: regularFont),
        alignment: TextAlignment.Center));

    listOfTextLine.add(PrinterText.emptyLine(12));

    listOfTextLine.add(PrinterText(
        "POR ESTE PAGARE ME OBLIGO INCONDICIONALMENTE A PAGAR A LA ORDEN DE " +
            "BANCO ACREDITANTE EL IMPORTE DE ESTE TÍTULO.",
        format: TextFormat(fontSize: 12, fontFamily: regularFont),
        alignment: TextAlignment.Center));
    listOfTextLine.add(PrinterText(
        "ESTE PAGARE PROCEDE DEL CONTRATO DE APERTURA DE CREDITO QUE EL BANCO" +
            "ACREDITANTE Y EL TARJETAHABIENTE TIENEN CELEBRADO",
        format: TextFormat(fontSize: 12, fontFamily: regularFont),
        alignment: TextAlignment.Center)); */

    listOfTextLine.add(PrinterText.emptyLine(16));

    final printerScript =
        PrinterScript(listOfTextLine, gray: GrayIntensity.Medium);
    printScript(printerScript);
  }

  String get _amountString {
    return _amountBytesToString(infoTags?.amount);
  }

  double get _amountDouble {
    return _amountBytesToDouble(infoTags?.amount);
  }

  String get _amountOtherString {
    return _amountBytesToString(infoTags?.amountOther);
  }

  double _amountBytesToDouble(Uint8List? amountBytes) {
    if (amountBytes != null) {
      final amountInt = int.parse(amountBytes.toHexStr());
      return double.parse((amountInt / 100).toStringAsFixed(4));
    }
    return 0.0;
  }

  String _amountBytesToString(Uint8List? amountBytes) {
    if (amountBytes != null) {
      final amountInt = int.parse(amountBytes.toHexStr());
      final currencyFormat = NumberFormat.currency(locale: "en", symbol: "\$");
      return currencyFormat.format(amountInt / 100);
    }
    return '-';
  }

  String? get _kernelTypeStr {
    final kernelType = transactionArgs?.transactionInfo?.kernelType;
    switch (kernelType) {
      case ContactlessKernelType.PayPass:
        return "MasterCard PayPass";
      case ContactlessKernelType.PayWave:
        return "VISA PayWave";
      default:
        return null;
    }
  }

  List<Widget> _generateCommandTiles(
    String title,
    Map<int, Uint8List?>? tags,
  ) {
    return tags != null
        ? [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            ListTile(
              enableFeedback: true,
              title: const Text('CID (9F27)'),
              subtitle: Text(_getCidStr(tags[0x9f27])),
              onTap: () {},
            ),
            ListTile(
              enableFeedback: true,
              title: const Text('TSI (9B)'),
              subtitle: Text(
                tags[0x9b]?.toHexStr().toUpperCase() ?? '-',
              ),
              onTap: () {
                _showTsiBitmap(tags[0x9b]);
              },
            ),
            ListTile(
              enableFeedback: true,
              title: const Text('TVR (95)'),
              subtitle: Text(
                tags[0x95]?.toHexStr().toUpperCase() ?? '-',
              ),
              onTap: () {
                _showTvrBitmap(tags[0x95]);
              },
            ),
            const Divider(),
          ]
        : List<Widget>.empty();
  }

  void _onTapAip() {
    final aip = infoTags?.aip;
    if (aip == null) return;

    final aipBitmap = getAipBitmap();
    aipBitmap.loadFromBytes(aip);
    showParamBitmapDialog(context, bitmap: aipBitmap, readOnly: true);
  }

  void _onTapTerminalCapabilities() {
    final capabilities = infoTags?.terminalCapabilities;
    if (capabilities == null) return;

    final capabilitiesBitmap = getTerminalCapabilitiesBitmap();
    capabilitiesBitmap.loadFromBytes(capabilities);
    showParamBitmapDialog(context, bitmap: capabilitiesBitmap, readOnly: true);
  }

  String _getCidStr(Uint8List? cid) {
    if (cid == null) return '-';

    final cidStr = cid.toHexStr();
    if (cidStr == "80") {
      return '80 - ARQC';
    } else if (cidStr == "40") {
      return '40 - TC';
    } else if (cidStr == "00") {
      return '00 - AAC';
    }

    return cidStr;
  }

  void _showTvrBitmap(Uint8List? tvr) {
    if (tvr == null) return;

    final tvrBitmap = getTvrBitmap();
    tvrBitmap.loadFromBytes(tvr);
    showParamBitmapDialog(context, bitmap: tvrBitmap, readOnly: true);
  }

  void _showTsiBitmap(Uint8List? tsi) {
    if (tsi == null) return;

    final tsiBitmap = getTsiBitmap();
    tsiBitmap.loadFromBytes(tsi);
    showParamBitmapDialog(context, bitmap: tsiBitmap, readOnly: true);
  }

  String _getCvmTypeStr(Uint8List? cvmResults) {
    if (cvmResults == null || cvmResults.length < 1) return '-';

    final cvmTypeByte = cvmResults[0] & 0x1f;
    switch (cvmTypeByte) {
      case 0x01:
        return "plaintextPINOffline";
      case 0x04:
        return "encipheredPINOffline";
      case 0x02:
        return "encipheredPINOnline";
      case 0x03:
        return "plaintextPINOfflineAndSignature";
      case 0x05:
        return "encipheredPINOfflineAndSignature";
      case 0x1E:
        return "signature";
      case 0x1F:
        return "noCVM";
    }

    return "unknown";
  }
}
