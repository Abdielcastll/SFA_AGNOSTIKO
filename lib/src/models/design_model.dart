import 'package:cloud_firestore/cloud_firestore.dart';

class DesignModel {
  final String? design;

  DesignModel({
    this.design,
  });
}

class DesignfromSnapshot {
  // id type list from snapshot
  List<DesignModel> designListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DesignModel(
        design: doc.get('nombre'),
      );
    }).toList();
  }
}
