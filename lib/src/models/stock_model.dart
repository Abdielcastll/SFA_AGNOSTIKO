import 'package:cloud_firestore/cloud_firestore.dart';

class StockModel {
  final stock;

  StockModel(
    this.stock,
  );
}

StockModel stockListfromSnapshot(doc) {
  return StockModel(
    doc.data().toString().contains('valores') ? doc.get('valores') : 000,
    // (doc.get('valores')) ?? 'NaN',
  );
}
