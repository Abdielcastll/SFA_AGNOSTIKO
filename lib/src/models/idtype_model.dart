import 'package:cloud_firestore/cloud_firestore.dart';

class IdTypeModel {
  final String? idType;

  IdTypeModel({
    this.idType,
  });
}

class IdTypefromSnapshot {
  // id type list from snapshot
  List<IdTypeModel> idTypeListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return IdTypeModel(
        idType: doc.get('nombre'),
      );
    }).toList();
  }
}
