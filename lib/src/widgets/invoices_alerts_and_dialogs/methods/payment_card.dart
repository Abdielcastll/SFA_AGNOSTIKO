// ignore_for_file: use_build_context_synchronously

import 'package:agnostiko/agnostiko.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/card_input/card_input.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';

import '../../../../dialogs/circular_progress_dialog.dart';
import '../../../models/transaction_args.dart';
import '../../../pages/place_order/add_payment.dart';
import '../../../services/utils/emv.dart';

Future _acceptAmount(
  BuildContext context,
  double amount,
  InvoiceData invoiceData, {
  Function? updatePayed,
  AddPaymentBodyAtt? paymentBody,
  noRetail = false,
}) async {
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
      showCircularProgressDialog(
        context,
        AppLocalizations.of(context)!.pleaseWait,
      );
      await emvPreTransaction();
      Navigator.pop(context); // y cerramos el popup antes de seguir
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
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        myTheme.colorScheme.primary,
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
                        fontFamily: 'Poppins-regular',
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
                            _acceptAmount(context, amount, invoiceData,
                                updatePayed: updatePayed,
                                paymentBody: paymentBody,
                                noRetail: noRetail);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              myTheme.colorScheme.primary,
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
                              fontFamily: 'Poppins-regular',
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
