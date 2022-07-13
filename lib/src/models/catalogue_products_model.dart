import 'package:cloud_firestore/cloud_firestore.dart';

class CatalogueProductsModel {
  final dynamic quality;
  final dynamic catalogue;
  final dynamic lines;
  final dynamic sizes;

  CatalogueProductsModel({
    this.quality,
    this.catalogue,
    this.lines,
    this.sizes,
  });
}

class CatalogueProductfromSnapshot {
  // id type list from snapshot
  List<CatalogueProductsModel> idTypeListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CatalogueProductsModel(
        quality: doc.get('calidades'),
        catalogue: doc.get('catalogo'),
        lines: doc.get('lineas'),
        sizes: doc.get('tamanos'),
      );
    }).toList();
  }
}
