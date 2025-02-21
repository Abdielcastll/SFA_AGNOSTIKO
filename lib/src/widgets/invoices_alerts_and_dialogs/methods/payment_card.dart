// ignore_for_file: use_build_context_synchronously

import 'package:agnostiko/agnostiko.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/dialogs/go_to_pinpad_dialog.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/card_input/card_input.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/utils/pinpad_conection.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';

import '../../../../dialogs/circular_progress_dialog.dart';
import '../../../models/transaction_args.dart';
import '../../../pages/place_order/add_payment.dart';
import '../../../services/utils/emv.dart';

Future acceptAmount(
  BuildContext context,
  double amount,
  InvoiceData invoiceData, {
  Function? updatePayed,
  AddPaymentBodyAtt? paymentBody,
  noRetail = false,
  isKiosko = false,
}) async {
  print('a pagar');
  print(invoiceData.totalOfTheOrder);
  print(paymentBody?.remaining);
  print(amount);
  var remaining = double.parse(
      (paymentBody?.remaining ?? invoiceData.totalOfTheOrder)
          .toStringAsFixed(2));

  if (amount > remaining) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
        "El monto a pagar excede el saldo de la factura.",
      ),
      backgroundColor: Colors.red.shade700,
    ));
    return null;
  }

  var platformInfo = await getPlatformInfo();
  var transactionArgs = TransactionArgs(
    platformInfo: platformInfo,
    entryMode: EntryMode.Magstripe,
    showNumericKeyboard: !platformInfo.hasKeypad,
    supportedCardTypes: platformInfo.supportedCardTypes,
    emvTransactionType: EmvTransactionType.Goods,
    invoice: invoiceData,
  );

  transactionArgs.amountInCents = (amount * 100).toInt();

  final hasCardReader = platformInfo.hasCardReader;
  final hasEmvModule = platformInfo.hasEmvModule;

  final deviceType = await getDeviceType();
  if (hasCardReader) {
    if (hasEmvModule &&
        (deviceType == DeviceType.POS || deviceType == DeviceType.PINPAD)) {
      // mostramos un popup mientras se realiza la carga de parámetros EMV
      if (isKiosko) {
        showGoToPinpadDialog(
          context,
          "Por favor diríjase al Pinpad",
        );
      } else {
        showCircularProgressDialog(
          context,
          AppLocalizations.of(context)!.pleaseWait,
        );
      }

      if (deviceType == DeviceType.PINPAD) {
        final pinpadManager = PinpadManager();
        bool isConnected = await pinpadManager.ensureConnected(context);
        if (!isConnected) {
          Navigator.pop(context);
          Navigator.pop(context);
          return;
        } else {
          try {
            await emvPreTransaction(false);
            Navigator.pop(context);
          } catch (e) {
            Navigator.pop(context);
            Navigator.pop(context);
          }
        }
      } else {
        await emvPreTransaction(false);
        Navigator.pop(context);
      } // y cerramos el popup antes de seguir
    }

    Navigator.pushNamed(
      context,
      CardInputView.route,
      arguments: [transactionArgs, updatePayed, paymentBody, noRetail],
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "El dispositivo no cuenta con lector de tarjeta.",
      ),
    ));
    Navigator.popUntil(context, (route) => route.isFirst == true);
    return null;
  }
}

paymentCard(
    BuildContext context,
    bool? isKiosko,
    double amount,
    Client client,
    String invoiceDocumentID,
    double totalOfTheOrder,
    String currentCoin,
    DateTime date,
    double remaining,
    coinExchangeRatio,
    {Function? updatePayed,
    AddPaymentBodyAtt? paymentBody,
    noRetail = false}) {
  remaining = priceFormatForDB(
    remaining,
    currentCoin,
    coinExchangeRatio,
  );
  final invoiceData = InvoiceData(
      client,
      invoiceDocumentID,
      currentCoin,
      amount,
      ((totalOfTheOrder * 100).round() / 100),
      currentCoin,
      date,
      remaining,
      coinExchangeRatio);
  print(invoiceData.currentCoin);
  print('GET COIN FROM PAYMENTCARD');
  if (isKiosko == true && amount != 0.0) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      acceptAmount(
        context,
        amount,
        invoiceData,
        updatePayed: updatePayed,
        paymentBody: paymentBody,
        noRetail: noRetail,
        isKiosko: true,
      );
    });

    return Container();
  }
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

  return StatefulBuilder(
    builder: (context, setState) => Column(
      children: [
        Column(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: amount == 0
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (globalRemoteConfig.conversionKiosko == true) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        themeProvider.myTheme.colorScheme.primary,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    icon: const Icon(
                      MaterialIcons.arrow_back_ios,
                      size: 14,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins-Regular',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  amount == 0
                      ? Container()
                      : ElevatedButton.icon(
                          icon: const Icon(
                            Icons.credit_card,
                            size: 14,
                          ),
                          onPressed: () {
                            acceptAmount(
                              context,
                              amount,
                              invoiceData,
                              updatePayed: updatePayed,
                              paymentBody: paymentBody,
                              noRetail: noRetail,
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              themeProvider.myTheme.colorScheme.primary,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          label: Text(
                            AppLocalizations.of(context)!.orderContinue,
                            style: const TextStyle(
                              fontFamily: 'Poppins-Regular',
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
