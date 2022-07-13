import 'package:cloud_firestore/cloud_firestore.dart';

class QualityModel {
  final String? quality;

  QualityModel({
    this.quality,
  });
}

class QualityfromSnapshot {
  // id type list from snapshot
  List<QualityModel> qualityListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return QualityModel(
        quality: doc.get('nombre'),
      );
    }).toList();
  }
}
