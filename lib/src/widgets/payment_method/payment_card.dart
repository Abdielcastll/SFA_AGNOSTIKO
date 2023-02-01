// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:agnostiko/agnostiko.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/card_input/card_input.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/widgets/dialogs/insertCardDialog.dart';

import '../../../dialogs/circular_progress_dialog.dart';
import '../../models/transaction_args.dart';
import '../../services/utils/emv.dart';

void _acceptAmount(BuildContext context, double amount) async {
  var platformInfo = await getPlatformInfo();
  var transactionArgs = TransactionArgs(
    platformInfo: platformInfo,
    entryMode: EntryMode.Magstripe,
    showNumericKeyboard: !platformInfo.hasKeypad,
    supportedCardTypes: platformInfo.supportedCardTypes,
    emvTransactionType: EmvTransactionType.Goods,
  );
  transactionArgs.amountInCents = (amount * 100).toInt();

  final hasCardReader = platformInfo.hasCardReader;
  final hasEmvModule = platformInfo.hasEmvModule;

  final deviceType = await getDeviceType();
  if (hasCardReader) {
    if (hasEmvModule && deviceType == DeviceType.POS) {
      // mostramos un popup mientras se realiza la carga de parámetros EMV
      showCircularProgressDialog(
        context,
        "pleaseWait",
      );
      await emvPreTransaction();
      Navigator.pop(context); // y cerramos el popup antes de seguir
    }

    Navigator.pushReplacementNamed(context, CardInputView.route,
        arguments: transactionArgs);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "deviceWithoutCardReader",
      ),
    ));
    Navigator.popUntil(context, (route) => route.isFirst == true);
  }
}

paymentCard(double amount) {
  return StatefulBuilder(
    builder: (context, setState) => Column(
      children: [
        Column(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.goBack,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: myTheme.colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: myTheme.colorScheme.primary),
                    child: TextButton(
                      onPressed: () {
                        _acceptAmount(context, amount);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: myTheme.colorScheme.primary,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.orderContinue,
                        style: const TextStyle(
                          fontFamily: 'Poppins-regular',
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
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
