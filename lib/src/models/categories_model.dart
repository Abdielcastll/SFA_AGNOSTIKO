import 'package:cloud_firestore/cloud_firestore.dart';

class CategorieModel {
  final String? categorie;

  CategorieModel({
    this.categorie,
  });
}

class CategoriefromSnapshot {
  // id type list from snapshot
  List<CategorieModel> categorieListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CategorieModel(
        categorie: doc.get('nombre'),
      );
    }).toList();
  }
}
