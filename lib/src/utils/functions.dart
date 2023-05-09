import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';

double exchangeAmount({String? coin, double? amount, double? exchange}) {
  var newAmount = amount;
  newAmount = amount! / exchange!;
  return double.parse(newAmount.toStringAsFixed(4));
}

double roundAmount(double amount) {
  double correctAmount = double.parse(amount.toStringAsFixed(4));
  return double.parse(correctAmount.toStringAsFixed(4));
}

Map<String, dynamic>? getExchangesRates(List<Coin?> coins) {
  List? coinList = [];
  Map<String, dynamic>? coinExchangeList = <String, dynamic>{'USD': 1};
  coinList.add('Dolares - USD');
  coins.map((coin) {
    coinList.add('${coin?.code}');
    final exchangeRate = <String, dynamic>{
      '${coin?.code}': '${coin?.exchangeRatio}'
    };
    coinExchangeList.addEntries(exchangeRate.entries);
  }).toList();

  List? coinListSymbols = [];
  coinListSymbols.add('USD');
  coins.map((coin) => coinListSymbols.add(coin?.symbol)).toList();
  return coinExchangeList;
}

Map<String, dynamic>? getExchangesRatesTest(List<Coin?> coins) {
  List? coinList = [];
  Map<String, dynamic>? coinExchangeList = <String, dynamic>{'USD': 1};
  coinList.add('Dolares - USD');
  coins.map((coin) {
    coinList.add('${coin?.code}');
    final exchangeRate = <String, dynamic>{
      '${coin?.code}': coin?.exchangeRatio,
    };
    coinExchangeList.addEntries(exchangeRate.entries);
  }).toList();

  List? coinListSymbols = [];
  coinListSymbols.add('USD');
  coins.map((coin) => coinListSymbols.add(coin?.symbol)).toList();
  return coinExchangeList;
}

Map<String, dynamic>? getMoneySymbols(coins) {
  List? coinList = [];
  Map<String, dynamic>? coinSymbols = <String, dynamic>{'USD': '\$'};
  //
  coinList.add('Dolares - USD');
  coins.map((coin) {
    coinList.add('${coin?.code}');
    final symbol = <String, dynamic>{
      '${coin?.code}': '${coin?.symbol}',
    };
    coinSymbols.addEntries(symbol.entries);
  }).toList();

  List? coinListSymbols = [];
  coinListSymbols.add('\$');
  coins.map((coin) => coinListSymbols.add(coin?.symbol)).toList();
  // print(coinSymbols);
  return coinSymbols;
}

String? getCoinCode({String? coin}) {
  List<String> currentCoinSplit = coin!.split(' ');
  String currentCoinLastPosition = currentCoinSplit.last;
  return currentCoinLastPosition;
}

priceFormatForDB(productPrice, coin, exchangRatio) {
  double correctAmount = double.parse(productPrice.toStringAsFixed(4));
  double convertedAmount =
      double.parse((correctAmount * exchangRatio!).toStringAsFixed(4));
  return convertedAmount;
}

///////////////// TESTING

// FUNCTION THAT RETURNS CONVERTED AMOUNT

double priceMultipliedByItsExchangeRatio(
    {productPrice, coinExchangeRatio, coinDecimals}) {
  double correctAmount = double.parse(productPrice.toStringAsFixed(4));
  double convertedAmount = correctAmount * coinExchangeRatio;
  String convertedAmountFixedDecimals =
      convertedAmount.toStringAsFixed(coinDecimals);
  double output = double.parse(convertedAmountFixedDecimals);
  return output;
}

double priceDividedbyItsExchangeRatio({double? amount, double? exchange}) {
  double correctAmount = double.parse(amount!.toStringAsFixed(4));
  double convertedAmount = correctAmount / exchange!;
  // String convertedAmountFixedDecimals =
  //     convertedAmount.toStringAsFixed(coinDecimals);
  // double output = double.parse(convertedAmountFixedDecimals);
  return convertedAmount;
}
