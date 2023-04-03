import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';

double exchangeAmount(String coin, double amount, double exchange) {
  var newAmount = amount;
  newAmount = amount / exchange;
  // if (coin.contains('VED')) {
  //   newAmount = amount / 4.58;
  // }
  // if (coin.contains('EUR')) {
  //   newAmount = amount / 0.89;
  // }
  // if (coin.contains('MXN')) {
  //   newAmount = amount / 19.43;
  // }
  return double.parse(newAmount.toStringAsFixed(4));
}

double priceToCurrencySelected(double productPrice, String coin) {
  double correctAmount = double.parse(productPrice.toStringAsFixed(4));

  if (coin.contains('USD')) {
    return correctAmount;
  } else if (coin.contains('VED')) {
    return double.parse((correctAmount * 4.58).toStringAsFixed(4));
  } else if (coin.contains('EUR')) {
    return double.parse((correctAmount * 0.89).toStringAsFixed(4));
  } else if (coin.contains('MXN')) {
    return double.parse((correctAmount * 19.43).toStringAsFixed(4));
  } else if (coin.contains('BTC')) {
    return double.parse((correctAmount * 0.00011).toStringAsFixed(4));
  } else {
    return double.parse((correctAmount * 4.58).toStringAsFixed(4));
  }
}

double roundAmount(double amount) {
  double correctAmount = double.parse(amount.toStringAsFixed(4));
  return double.parse(correctAmount.toStringAsFixed(2));
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
  // print(coinExchangeList);
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
