import 'package:cloud_firestore/cloud_firestore.dart';

class Prices {
  final base;
  final name;
  final prices;

  Prices({this.base, this.name, this.prices});
}

List<Prices> priceListfromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return Prices(
      base: doc.data().toString().contains('base') ? doc.get('base') : false,
      name: doc.data().toString().contains('nombre') ? doc.get('nombre') : '',
      prices:
          doc.data().toString().contains('precios') ? doc.get('precios') : {},
    );
  }).toList();
}

Prices pricesfromSnapshot(doc) {
  return Prices(
    base: doc.data().toString().contains('base') ? doc.get('base') : false,
    name: doc.data().toString().contains('nombre') ? doc.get('nombre') : '',
    prices: doc.data().toString().contains('precios') ? doc.get('precios') : {},
  );
}
