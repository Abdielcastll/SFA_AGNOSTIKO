import 'package:cloud_firestore/cloud_firestore.dart';

class StockModel {
  final dynamic stock;

  StockModel({
    this.stock,
  });
}

class StockfromSnapshot {
  // stock list from snapshot
  List<StockModel> stockListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return StockModel(
        stock: doc.get('valores'),
      );
    }).toList();
  }
}
