import 'package:cloud_firestore/cloud_firestore.dart';

class SizesModel {
  final String? size;

  SizesModel({
    this.size,
  });
}

class SizefromSnapshot {
  // id type list from snapshot
  List<SizesModel> sizesListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SizesModel(
        size: doc.get('nombre'),
      );
    }).toList();
  }
}
