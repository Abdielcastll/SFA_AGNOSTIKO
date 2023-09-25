// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unnecessary_cast, prefer_const_literals_to_create_immutables

import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/methods/payment_cash.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/methods/payment_check.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/methods/payment_deposit.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/methods/payment_transfer.dart';

import '../../pages/place_order/add_payment.dart';
import 'methods/payment_card.dart';

identifyPaymentMethod({
  String? coinName,
  int? coinDecimals,
  double? coinExchangeRatio,
  String? coinSymbol,
  String? coinCode,
  required String selectedValueA,
  required String invoiceDocumentID,
  required String selectedCoin,
  required Client client,
  required double moneyRecievedForRegisterMoney,
  required double paidAmount,
  required double totalOfTheOrder,
  required double remaining,
  required double remainingConverted,
  required DateTime date,
  context,
  Function? updatePayed,
  AddPaymentBodyAtt? paymentBody,
  noRetail = true,
  int? paymentsValidPayQuantity,
  required List<String> itemsBank,
  required List<String> itemsBankInter,
  required List<String> banks,
}) {
  final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;

  if (selectedValueA == 'Tarjeta de Debito' ||
      selectedValueA == 'Tarjeta de Credito') {
    return paymentCard(
      paidAmount,
      client,
      invoiceDocumentID,
      totalOfTheOrder,
      selectedCoin,
      date,
      remaining,
      // remainingConverted,
      coinExchangeRatio,
      updatePayed: updatePayed,
      paymentBody: paymentBody,
      noRetail: noRetail,
    );
  }

  if (selectedValueA == 'Cheque') {
    return paymentCheck(
        paidAmount,
        client,
        invoiceDocumentID,
        totalOfTheOrder,
        selectedCoin,
        date,
        remaining,
        coinExchangeRatio,
        selectedValueA,
        remainingConverted,
        currentCoin,
        coinSymbol,
        paymentsValidPayQuantity);
  } else if (selectedValueA == 'Deposito') {
    return paymentDeposit(
        paidAmount,
        client,
        invoiceDocumentID,
        totalOfTheOrder,
        selectedCoin,
        date,
        remaining,
        coinExchangeRatio,
        selectedValueA,
        remainingConverted,
        currentCoin,
        coinSymbol,
        paymentsValidPayQuantity);
  } else if (selectedValueA == 'Efectivo') {
    return paymentCash(
        paidAmount,
        client,
        invoiceDocumentID,
        totalOfTheOrder,
        selectedCoin,
        date,
        remaining,
        coinExchangeRatio,
        selectedValueA,
        remainingConverted,
        currentCoin,
        coinSymbol,
        moneyRecievedForRegisterMoney,
        paymentsValidPayQuantity);
  } else if (selectedValueA == 'Transferencia' ||
      selectedValueA == 'Transf-internacional') {
    return paymentTransfer(
        paidAmount,
        client,
        invoiceDocumentID,
        totalOfTheOrder,
        selectedCoin,
        date,
        remaining,
        coinExchangeRatio,
        selectedValueA,
        remainingConverted,
        currentCoin,
        coinSymbol,
        paymentsValidPayQuantity);
  }
}
