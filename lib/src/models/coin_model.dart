import 'package:cloud_firestore/cloud_firestore.dart';

class Coin {
  final String? code;
  final int? decimals;
  final String? name;
  final String? symbol;
  final double? exchangeRatio;

  Coin({
    this.code,
    this.decimals,
    this.name,
    this.symbol,
    this.exchangeRatio,
  });
}

class CoinExchangeRates {
  final double exchangeRatio;

  CoinExchangeRates({
    required this.exchangeRatio,
  });
}

List<Coin> coinListfromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return Coin(
      code: doc.get('codigo'),
      decimals: doc.get('decimales'),
      name: doc.get('nombre'),
      symbol: doc.get('simbolo'),
      exchangeRatio: doc.get('tasaDeCambio'),
    );
  }).toList();
}

List<CoinExchangeRates> coinRatesListfromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return CoinExchangeRates(
      exchangeRatio: doc.get('tasaDeCambio'),
    );
  }).toList();
}
