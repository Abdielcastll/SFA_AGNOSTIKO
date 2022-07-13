import 'package:cloud_firestore/cloud_firestore.dart';

class PricesModel {
  final String? name;
  final dynamic prices;

  PricesModel({this.name, this.prices});
}

class PricesfromSnapshot {
  // prices list from snapshot
  List<PricesModel> priceListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PricesModel(
        name: doc.get('nombre'),
        prices: doc.get('precios'),
      );
    }).toList();
  }
}
