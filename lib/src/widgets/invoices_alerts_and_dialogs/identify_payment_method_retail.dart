// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unnecessary_cast, prefer_const_literals_to_create_immutables

import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/methods/payment_cash_retail.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/methods/payment_check_retail.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/methods/payment_deposit_retail.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/methods/payment_transfer_retail.dart';

import '../../pages/place_order/add_payment.dart';
import 'methods/payment_card.dart';

List<String> itemsBank = [
  'BANCO CENTRAL',
  'BANCO BICENTENARIO',
  'BANCO DE VENEZUELA',
  'BANESCO',
  'BOD',
  'BNC',
];

List<String> itemsBankInter = [
  'BANK OF AMERICA',
  'CITIBANK',
  'HSBC',
  'WELLSFARGO',
];

identifyPaymentMethodRetail({
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
  required Function updatePayed,
  required AddPaymentBodyAtt paymentBody,
  noRetail = false,
  required List<String> itemsBank,
  required List<String> itemsBankInter,
  required List<String> banks,
}) {
  print('amountToPay IDENTIFY $paidAmount');
  print('selectedCoin IDENTIFY $selectedCoin');
  // String? selectedCoin;
  final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;

  final amountExchanged = priceDividedbyItsExchangeRatio(
    amount: paidAmount,
    exchange: coinExchangeRatio,
  );

  print('Metodo: $selectedValueA');
  print('currentCoin: $currentCoin');
  print('totalOfTheOrder: $totalOfTheOrder');
  print('paidAmount: $paidAmount');
  print('remaining: $remaining');
  print('amountExCHANGED $amountExchanged');

  if (selectedValueA == 'Tarjeta de Debito' ||
      selectedValueA == 'Tarjeta de Credito') {
    if (paidAmount is String) {
      paidAmount = double.parse(paidAmount.toString().replaceAll('\$', ''));
    }
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
    return paymentCheckRetail(
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
        paymentBody,
        coinSymbol);
  } else if (selectedValueA == 'Deposito') {
    return paymentDepositRetail(
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
        paymentBody,
        coinSymbol);
  } else if (selectedValueA == 'Efectivo' ||
      selectedValueA == 'Nota de credito') {
    return paymentCashRetail(
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
        paymentBody,
        coinSymbol,
        moneyRecievedForRegisterMoney);
  } else if (selectedValueA == 'Transferencia' ||
      selectedValueA == 'Transf-internacional') {
    return paymentTransferRetail(
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
        paymentBody,
        coinSymbol);
  }
}
