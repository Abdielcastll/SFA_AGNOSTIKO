import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  final String? brand;

  BrandModel({
    this.brand,
  });
}

class BrandfromSnapshot {
  // id type list from snapshot
  List<BrandModel> brandListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return BrandModel(
        brand: doc.get('nombre'),
      );
    }).toList();
  }
}
