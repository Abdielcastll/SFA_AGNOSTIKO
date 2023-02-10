import 'package:cloud_firestore/cloud_firestore.dart';

class CatalogueModel {
  final String? catalogue;

  CatalogueModel({
    this.catalogue,
  });
}

class CataloguefromSnapshot {
  // id type list from snapshot
  List<CatalogueModel> catalogueListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CatalogueModel(
        catalogue: doc.get('nombre'),
      );
    }).toList();
  }
}
