import 'package:cloud_firestore/cloud_firestore.dart';

class CoinModel {
  final String? id;
  final int? decimals;
  final String? name;
  final String? symbol;
  final int? exchangeRatio;

  CoinModel({
    this.decimals,
    this.name,
    this.symbol,
    this.exchangeRatio,
    this.id,
  });
}

class CoinfromSnapshot {
  // id type list from snapshot
  List<CoinModel> coinListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CoinModel(
        id: doc.get('codigo'),
        decimals: doc.get('decimales'),
        name: doc.get('nombre'),
        symbol: doc.get('simbolo'),
        exchangeRatio: doc.get('tasaDeCambio'),
      );
    }).toList();
  }
}
