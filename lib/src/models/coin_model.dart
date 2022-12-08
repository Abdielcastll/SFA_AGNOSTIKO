import 'package:cloud_firestore/cloud_firestore.dart';

class Coin {
  final code;
  final decimals;
  final name;
  final symbol;
  final exchangeRatio;

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
      code:
          doc.data().toString().contains('codigo') ? doc.get('codigo') : 'N/A',
      decimals: doc.data().toString().contains('decimales')
          ? doc.get('decimales')
          : 0,
      name:
          doc.data().toString().contains('nombre') ? doc.get('nombre') : 'N/A',
      symbol: doc.data().toString().contains('simbolo')
          ? doc.get('simbolo')
          : 'N/A',
      exchangeRatio: doc.data().toString().contains('tasaDeCambio')
          ? doc.get('tasaDeCambio')
          : 0,
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

Coin coinFromSnapshot(doc) {
  return Coin(
    code: doc.data().toString().contains('codigo') ? doc.get('codigo') : 'N/A',
    decimals:
        doc.data().toString().contains('decimales') ? doc.get('decimales') : 0,
    name: doc.data().toString().contains('nombre') ? doc.get('nombre') : 'N/A',
    symbol:
        doc.data().toString().contains('simbolo') ? doc.get('simbolo') : 'N/A',
    exchangeRatio: doc.data().toString().contains('tasaDeCambio')
        ? doc.get('tasaDeCambio')
        : 0,
  );
}
