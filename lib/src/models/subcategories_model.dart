import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategoriesModel {
  final String? subCategorie;

  SubCategoriesModel({
    this.subCategorie,
  });
}

class SubCategoriefromSnapshot {
  // id type list from snapshot
  List<SubCategoriesModel> subCategorieListfromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SubCategoriesModel(
        subCategorie: doc.get('nombre'),
      );
    }).toList();
  }
}
