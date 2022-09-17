import 'package:cloud_firestore/cloud_firestore.dart';

class StockModel {
  final stock;

  StockModel(
    this.stock,
  );
}

StockModel stockListfromSnapshot(doc) {
  return StockModel((doc.get('valores')) ?? 'NaN');
}
