import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:agnostiko/agnostiko.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/dialogs/confirm_dialog.dart';
import 'package:pwa_sales2go_flutter/dialogs/info_dialog.dart';
import 'package:pwa_sales2go_flutter/dialogs/try_chip_dialog.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/completed_pay.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/utils/keypad.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/utils/multitenant-config.dart';
import 'package:pwa_sales2go_flutter/src/utils/notifications.dart';

import '../../models/transaction_args.dart';
import '../../services/utils/emv.dart';
import '../../services/utils/parameters.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../place_order/add_payment.dart';

class EmvTransactionInfoView extends StatefulWidget {
  static String route = "/emvTransactionInfo";

  const EmvTransactionInfoView({super.key});

  @override
  _EmvTransactionInfoViewState createState() => _EmvTransactionInfoViewState();
}

class _EmvTransactionInfoViewState extends State<EmvTransactionInfoView> {
  bool ticketPrinted = false;
  TransactionArgs? transactionArgs;
  InfoTags? infoTags;
  Map<int, Uint8List?>? firstGenerateTags;
  Map<int, Uint8List?>? secondGenerateTags;
  String razonsocial = '';
  EmvTransactionResult? transactionResult;
  String urlLogoTicket = '';
  bool dialogOn = false;

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

  Future<bool> showModalNoTicketPrinted() async {
    setState(() {
      dialogOn = true;
    });
    return await showConfirmDialog(
      context,
      title: '¿Estas seguro de regresar?',
      message: '¿Desea imprimir el ticket otra ves?',
      textAccept: 'Si',
      textCancel: 'No',
      onAccept: () {
        Navigator.pop(context);
      },
      onCancel: () {
        Navigator.pop(context);
        onAccept();
      },
    );
  }

  Future<bool> showModalTicketPrinted() async {
    setState(() {
      dialogOn = true;
    });
    return await showConfirmDialog(
      context,
      title: '¿Estas seguro?',
      message: '¿Desea imprimir el ticket otra ves?',
      textAccept: 'Si',
      textCancel: 'No',
      onAccept: () {
        handlerPress();
        Navigator.pop(context);
      },
      onCancel: () {
        Navigator.pop(context);
      },
    );
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

  void fetchDownloadLink() async {
    String? filePath = globalRemoteConfig.refLogoTicket!;
    String? downloadUrl = await getDownloadUrl(filePath);

    if (downloadUrl != null) {
      setState(() {
        urlLogoTicket = downloadUrl;
      });
      print('Download URL: $downloadUrl');
    } else {
      print('Failed to retrieve download URL');
    }
  }

  Future getEmpresaNombre() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instanceFor(app: multitenantConfig.tenantApp!)
              .collection('tenant')
              .doc('empresa')
              .get();

      // Check if the document exists and contains the field
      if (docSnapshot.exists && docSnapshot.data() != null) {
        // Extract the 'nombre' field value
        setState(() {
          razonsocial = docSnapshot.data()!['nombre'] ?? '';
        });
      } else {
        print('Document does not exist or has no data');
      }
    } catch (e) {
      print('Error fetching nombre: $e');
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getEmpresaNombre();
      fetchDownloadLink();
      if (globalRemoteConfig.conversionKiosko == true) {
        if (transactionResult == EmvTransactionResult.Approved) {
          onAccept();
        } else {
          kioskoDialog();
        }
      }
      if (globalRemoteConfig.onlyFullPaymentWithCard!) {
        startTimerFullPaymentWithCard();
      }
    });
    super.initState();
  }

  bool timerExpired = false;
  void startTimerFullPaymentWithCard() {
    printTicket();
    Future.delayed(Duration(seconds: 18), () {
      if (transactionResult == EmvTransactionResult.Approved) {
        setState(() {
          timerExpired = true;
        });
        onAccept();
      } else {
        setState(() {
          timerExpired = true;
        });
        kioskoDialog();
      }
    });
  }

  void kioskoDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return RawKeyboardListener(
          autofocus: true,
          focusNode: FocusNode(),
          onKey: rawKeypadHandler(
            context,
            onEnter: onAccept,
            onEscape: onCancel,
          ),
          child: AlertDialog(
            actionsOverflowButtonSpacing: 1,
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            contentPadding: const EdgeInsets.only(left: 25, right: 25),
            title: Center(
              child: Text(
                "Por favor intente de nuevo.",
                style: TextStyle(
                  color: themeProvider.myTheme.colorScheme.primary,
                ),
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "O\nSolicite ayuda antes de continuar",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: onCancel,
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                    themeProvider.myTheme.colorScheme.primary,
                  ),
                ),
                child: const Text(
                  "Cancelar venta",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    themeProvider.myTheme.colorScheme.primary,
                  ),
                  foregroundColor:
                      MaterialStateProperty.all(Colors.grey.shade400),
                ),
                onPressed: () {
                  if (globalRemoteConfig.onlyFullPaymentWithCard!) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    if (transactionResult == EmvTransactionResult.Fail ||
                        transactionResult == EmvTransactionResult.Denied ||
                        transactionResult == null) {
                      tryChipDialog(context);
                    }
                  }
                  onAccept();
                },
                child: const Text(
                  "Reintentar pago",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String transactionResultStr = '';
  String transactionOnlineStr = '';

  Future<String> getAid() async {
    final emv = EmvModule.instance;

    String? aid;
    final auxAid1 = await emv.getTagValue(0x9f06);
    final auxAid2 = await emv.getTagValue(0x84);
    if (auxAid1 != null) {
      aid = auxAid1.toHexStr();
    } else if (auxAid2 != null) {
      aid = auxAid2.toHexStr();
    }
    return aid ?? 'No encontrado';
  }

  Future<String> getARQC() async {
    final emv = EmvModule.instance;

    String? maskedHexString;
    Uint8List? arqc = await emv.getTagValue(0x9f26);
    if (arqc != null) {
      final hexString = arqc
          .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
          .join()
          .toUpperCase();
      maskedHexString = '*' * (hexString.length - 4) +
          hexString.substring(hexString.length - 4);
    }
    return maskedHexString ?? 'no encontrado';
  }

  final Handler handler = Handler();

  void handlerPress() async {
    handler.run(() async {
      printTicket();
    });
  }

  @override
  Widget build(BuildContext context) {
    getEmvTags();
    String approvedStr = AppLocalizations.of(context)!.approved.toUpperCase();
    String declinedStr = AppLocalizations.of(context)!.declined.toUpperCase();
    String failedStr = AppLocalizations.of(context)!.failed.toUpperCase();
    String offlineStr = AppLocalizations.of(context)!.offline.toUpperCase();
    String onlineStr = AppLocalizations.of(context)!.online.toUpperCase();
    String errorResultStr = '';

    @override
    void initState() {
      super.initState();
      transactionResultStr = failedStr;
      transactionOnlineStr = offlineStr;
    }

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

      final notificationService = context.read<NotificationService>();
      final paymentBody = (ModalRoute.of(context)?.settings.arguments!
          as List)[2] as AddPaymentBodyAtt;

      print("result: $transactionResult");
      print("result: ${this.transactionResult}");

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
                  context: context,
                );
              });
            });

            notificationService.sendNotificationToId(
                'DC8jpgQh4IRIKTI8PJ06c2uGwud2',
                'Pago registrado',
                'Pago registrado en factura ${paymentBody.invoiceNumber}');

            break;
          case EmvTransactionResult.Denied:
            transactionResultStr = declinedStr;
            break;
          case EmvTransactionResult.CmdError:
            transactionResultStr = declinedStr;
            errorResultStr = 'Tarjeta Retirada';
            break;
          case EmvTransactionResult.Fallback:
            transactionResultStr = declinedStr;
            errorResultStr = 'Error de lectura de chip';
            break;
          case EmvTransactionResult.Fail:
            transactionResultStr = declinedStr;
            errorResultStr = 'Fallo en la transacción';
            break;
          default:
            break;
        }
        if (transactionArgs!.timeout) {
          errorResultStr = 'Timeout';
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
          case EmvTransactionResult.CmdError:
            print('Tarjeta Retirada');
            transactionResultStr = declinedStr;
            errorResultStr = 'Tarjeta Retirada';
            break;
          case EmvTransactionResult.Fallback:
            print('Falback conexion');
            transactionResultStr = declinedStr;
            errorResultStr = 'Error de conexión';
            break;
          default:
            print('Devolucion Fallida');
            break;
        }
        if (transactionArgs!.timeout) {
          errorResultStr = 'Timeout';
        }
      }
      transactionOnlineStr =
          transactionInfo?.onlineRequested == true ? onlineStr : offlineStr;
    }
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    String getCardAsset(String? cardNo, ContactlessKernelType? kernelType) {
      if (cardNo?.startsWith('5') == true ||
          kernelType == ContactlessKernelType.PayPass) {
        return 'assets/images/mastercard.svg';
      } else if (cardNo?.startsWith('34') == true ||
          cardNo?.startsWith('37') == true ||
          kernelType == ContactlessKernelType.Expresspay) {
        return 'assets/images/american_expres.png';
      } else {
        return 'assets/images/visa.svg';
      }
    }

    return WillPopScope(
      onWillPop: globalRemoteConfig.conversionKiosko!
          ? () async {
              return false;
            }
          : showModalNoTicketPrinted,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themeProvider.myTheme.colorScheme.primary,
          foregroundColor: Colors.white,
          title: Text(AppLocalizations.of(context)!.emvTransactionInfo),
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          children: [
            const Text(''),
            Text(
              transactionArgs!.responseCode == '88'
                  ? "Tiempo de espera exedido"
                  : "${AppLocalizations.of(context)!.transaction} $transactionResultStr - $transactionOnlineStr",
              style: TextStyle(
                color: this.transactionResult == EmvTransactionResult.Approved
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            if (errorResultStr != '')
              Text(
                errorResultStr,
                style: TextStyle(
                  color: this.transactionResult == EmvTransactionResult.Approved
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            const Divider(
              color: Colors.grey,
            ),
            if (!transactionArgs!.isFallback && transactionArgs!.pan != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (globalRemoteConfig.onlyFullPaymentWithCard! == false)
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      height: 50,
                      width: 120,
                      child: SvgPicture.asset(
                        getCardAsset(infoTags?.cardNo?.toHexStr(),
                            transactionArgs?.transactionInfo?.kernelType),
                        fit: BoxFit.contain,
                      ),
                    ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          if (transactionArgs?.transactionInfo?.isContactless ==
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ],
              ),
            if (!transactionArgs!.isFallback)
              const Divider(
                color: Colors.grey,
              ),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Monto",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        _amountString,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              enableFeedback: true,
              title: const Text('STAN'),
              subtitle: Text(
                transactionArgs!.stan.toString(),
              ),
              onTap: () {},
            ),
            ListTile(
              enableFeedback: true,
              title: const Text('Referencia'),
              subtitle: Text(
                transactionArgs!.referenceNumber ?? 'N/A'.toString(),
              ),
              onTap: () {},
            ),
            ListTile(
              enableFeedback: true,
              title: const Text('Autorizacion'),
              subtitle: Text(
                transactionArgs!.authCode ?? 'N/A'.toString(),
              ),
              onTap: () {},
            ),
            ListTile(
              enableFeedback: true,
              title: const Text('ARQC'),
              subtitle: FutureBuilder<String>(
                future: getARQC(), // The async function
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                        'Loading...'); // Placeholder while waiting for data
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // Error message
                  } else {
                    return Text(
                        snapshot.data ?? 'No ARQC found'); // Display the result
                  }
                },
              ),
              onTap: () {},
            ),
            ListTile(
              enableFeedback: true,
              title: const Text('AID'),
              subtitle: FutureBuilder<String>(
                future: getAid(), // The async function
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                        'Loading...'); // Placeholder while waiting for data
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // Error message
                  } else {
                    return Text(
                        snapshot.data ?? 'No AID found'); // Display the result
                  }
                },
              ),
              onTap: () {},
            ),
            ListTile(
              enableFeedback: true,
              title: const Text('Response code: '),
              subtitle: Text(transactionArgs!.responseCode ?? '09'),
              onTap: () {},
            ),
            if (!transactionArgs!.isFallback)
              if (globalRemoteConfig.conversionKiosko == false)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 16.0,
                  ),
                  child: OutlinedButton(
                    onPressed: () async {
                      if (ticketPrinted) {
                        showModalTicketPrinted();
                      } else {
                        handlerPress();
                        setState(() {
                          ticketPrinted = true;
                        });
                      }
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      side: const BorderSide(
                        color: Colors.black12,
                      ),
                      foregroundColor:
                          themeProvider.myTheme.colorScheme.primary,
                      backgroundColor: Colors.blue.shade800,
                    ),
                    child: Text(
                      'imprimir comprobante'.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Poppins-Regular',
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            if (globalRemoteConfig.conversionKiosko == false)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                child: OutlinedButton(
                  onPressed: () {
                    onAccept();
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    side: const BorderSide(
                      color: Colors.black12,
                    ),
                    foregroundColor: themeProvider.myTheme.colorScheme.primary,
                    backgroundColor: Colors.blue.shade800,
                  ),
                  child: Text(
                    'aceptar'.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Poppins-Regular',
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  onCancel() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    Navigator.pop(context);
    printTicket();
    final orderActive = Provider.of<OrderProvider>(context, listen: false);
    objectBox.delelteAllShoppingCart();
    orderActive.setOrder(false);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.popUntil(context, (route) => route.isFirst);
        });
        return AlertDialog(
          title: Padding(
            padding: const EdgeInsets.all(25),
            child: Text(
              'Se ha cancelado su compra',
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                color: themeProvider.myTheme.colorScheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }

  onAccept() {
    if (dialogOn) {
      Navigator.pop(context);
    }
    if (globalRemoteConfig.conversionKiosko == true || timerExpired) {
      printTicket();
    }
    if (transactionArgs!.emvTransactionType == EmvTransactionType.Refund) {
      Navigator.popUntil(context, (route) => route.isFirst == true);
      return;
    }

    final noRetail = (ModalRoute.of(context)?.settings.arguments! as List)[3];

    if (noRetail) {
      print("noRetail");
      Navigator.pop(context);
      Navigator.pop(context);
      return;
    }

    final paymentBody = (ModalRoute.of(context)?.settings.arguments! as List)[2]
        as AddPaymentBodyAtt;
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

    if (globalRemoteConfig.conversionKiosko == false) {
      paymentBody.payments.add(PayMethod('Tarjeta', _amountDouble));
    }

    final remainingConverted = priceMultipliedByItsExchangeRatio(
        coinDecimals: 2,
        coinExchangeRatio: transactionArgs!.invoice!.coinExchangeRatio,
        productPrice: transactionArgs!.invoice!.remaining);

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
            addPaymentBody: paymentBody,
          ),
        ),
      );
    } else {
      print(paymentBody.remaining);
      print(paymentBody.amountPaied);
      print(payed);
      String? setMethod;
      if (globalRemoteConfig.conversionKiosko!) {
        setMethod = 'Tarjeta de Debito';
      }
      if (globalRemoteConfig.onlyFullPaymentWithCard!) {
        Navigator.pop(context);
        Navigator.pop(context);
        if (transactionResult == EmvTransactionResult.Fail ||
            transactionResult == EmvTransactionResult.Denied ||
            transactionResult == null) {
          if (transactionArgs!.responseCode != '88') {
            tryChipDialog(context);
          }
        }
      } else {
        print("me fui aca por alguna razon");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: 'PAGO-DIRECTO'),
            builder: (BuildContext context) => AddPaymentPage(
              remaining: double.parse(
                  (Decimal.parse(paymentBody.remaining.toString()) -
                          Decimal.parse(payed.toString()))
                      .toString()),
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
              isKiosko: globalRemoteConfig.conversionKiosko!,
              paymentType: setMethod,
              // updatePayed: updatePayed,
            ),
          ),
        );
      }
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

  String getCardName(String? cardNo) {
    if (cardNo?.startsWith('5') == true) {
      return 'Mastercard';
    } else if (cardNo?.startsWith('34') == true ||
        cardNo?.startsWith('37') == true) {
      return 'American Express';
    } else {
      return 'Visa';
    }
  }

  Future<void> printTicket() async {
    print('ticket emv');
    final emv = EmvModule.instance;

    List<PrinterObject> listOfTextLine = [];
    final terminalParameters = await loadTerminalParameters();

    //NetworkImage assetsLogo = NetworkImage(urlLogoTicket);
    //AssetImage("assets/images/agn_blue.png");

    ui.Image? logo = await networkImageToUiImage(urlLogoTicket);

    final byteDataLogo =
        await logo!.toByteData(format: ui.ImageByteFormat.rawRgba);
    final rgbaLogo =
        byteDataLogo?.buffer.asUint8List() ?? Uint8List.fromList([]);

    final maxWidth = await getPaperWidth();

    final imgLogo = PrinterImage(rgbaLogo, logo.width, logo.height,
        offsetX: (maxWidth / 2) - (logo.width / 2));

    // final logo = await assetsLogo.toPrinterImage(offsetX: maxWidth / 4);

    const specialFont = "Poppins-Bold";
    const regularFont = "Poppins-Bold";

    listOfTextLine.add(imgLogo);

    listOfTextLine.add(PrinterText(razonsocial.toUpperCase(),
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
    Uint8List? arqc = await emv.getTagValue(0x9f26);
    String? maskedHexString;
    if (arqc != null) {
      final hexString = arqc
          .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
          .join()
          .toUpperCase();
      maskedHexString = '*' * (hexString.length - 4) +
          hexString.substring(hexString.length - 4);
    }
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
      final cardBrand = getCardName(infoTags?.cardNo?.toHexStr());
      listOfTextLine.add(PrinterText.emptyLine(32));
      listOfTextLine.add(
        PrinterText(cardBrand.toUpperCase(),
            format: TextFormat(fontSize: 16, fontFamily: regularFont),
            alignment: TextAlignment.Center),
      );
      listOfTextLine.add(PrinterText.emptyLine(16));
    }

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

    final ticketMessage = transactionResult == EmvTransactionResult.Approved
        ? 'PAGO APROBADO'
        : transactionResult == EmvTransactionResult.CmdError
            ? 'TARJETA RETIRADA'
            : transactionArgs!.timeout || transactionArgs!.stan == null
                ? 'TIEMPO DE ESPERA AGOTADO'
                : 'PAGO FALLIDO';

    listOfTextLine.add(
      PrinterText(
        ticketMessage,
        format: TextFormat(
          fontSize: 16,
          fontFamily: regularFont,
        ),
      ),
    );
    listOfTextLine.add(
      PrinterSplitText(
        "Total:".toUpperCase(),
        _amountString,
        format: TextFormat(
          fontSize: 16,
          fontFamily: regularFont,
        ),
      ),
    );

    final contactlessBool = transactionArgs?.transactionInfo?.isContactless;

    listOfTextLine.add(PrinterText.emptyLine(16));
    listOfTextLine.add(
      PrinterText(
        "Stan: ${transactionArgs!.stan}".toUpperCase(),
        format: TextFormat(
          fontSize: 16,
          fontFamily: regularFont,
        ),
      ),
    );
    listOfTextLine.add(
      PrinterText(
        "Numero de Referencia: ${int.parse(transactionArgs!.referenceNumber ?? '0')}"
            .toUpperCase(),
        format: TextFormat(fontSize: 16, fontFamily: regularFont),
      ),
    );
    listOfTextLine.add(
      PrinterText(
        'ARQC:${maskedHexString ?? 'N/A'.toUpperCase()}',
        format: TextFormat(
          fontSize: 16,
          fontFamily: regularFont,
        ),
      ),
    );

    String? aid;
    final auxAid1 = await emv.getTagValue(0x9f06);
    final auxAid2 = await emv.getTagValue(0x84);
    if (auxAid1 != null) {
      aid = auxAid1.toHexStr();
    } else if (auxAid2 != null) {
      aid = auxAid2.toHexStr();
    }
    if (aid != null) {
      listOfTextLine.add(
        PrinterText(
          "AID:".toUpperCase() + aid.toUpperCase(),
          format: TextFormat(
            fontSize: 16,
            fontFamily: regularFont,
          ),
        ),
      );
    }

    listOfTextLine.add(PrinterText.emptyLine(16));

    if (!transactionArgs!.timeout &&
        transactionArgs!.stan != null &&
        transactionResult == EmvTransactionResult.Approved) {
      listOfTextLine.add(
        PrinterText(
          'FIRMA:______________________________',
          format: TextFormat(
            fontSize: 16,
            fontFamily: regularFont,
          ),
        ),
      );
    }

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
          listOfTextLine.add(
            PrinterText(
              const AsciiCodec().decode(nombreTarjetahabiente).toUpperCase(),
              format: TextFormat(fontSize: 12, fontFamily: regularFont),
              alignment: TextAlignment.Center,
            ),
          );
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

    listOfTextLine.add(PrinterText.emptyLine(16));

    final printerScript =
        PrinterScript(listOfTextLine, gray: GrayIntensity.Dark);
    await printScript(printerScript, bottomFeed: true);
    await cutPaper();
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

class Handler {
  bool _isRunning = false;
  Handler();
  Future<void> run(Future<void> Function() action) async {
    if (_isRunning) return;

    _isRunning = true;
    try {
      await action();
    } finally {
      _isRunning = false;
    }
  }
}
