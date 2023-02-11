import 'package:cloud_firestore/cloud_firestore.dart';

class TeamsModel {
  final active;
  final manager;
  final sellers;
  final zone;
  final teamDocumentReferenceID;

  TeamsModel({
    this.active,
    this.manager,
    this.sellers,
    this.zone,
    this.teamDocumentReferenceID,
  });
}

List<TeamsModel> teamListfromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return TeamsModel(
      active:
          doc.data().toString().contains('activo') ? doc.get('activo') : false,
      manager: doc.data().toString().contains('gerente')
          ? doc.get('gerente').id
          : 'nan',
      sellers: doc.data().toString().contains('vendedores')
          ? doc.get('vendedores')
          : [],
      zone: doc.data().toString().contains('zona') ? doc.get('zona').id : 'nan',
      teamDocumentReferenceID: doc.reference.id,
    );
  }).toList();
}

TeamsModel teamfromSnapshot(doc) {
  return TeamsModel(
    active:
        doc.data().toString().contains('activo') ? doc.get('activo') : false,
    manager: doc.data().toString().contains('gerente')
        ? doc.get('gerente').id
        : 'nan',
    sellers: doc.data().toString().contains('vendedores')
        ? doc.get('vendedores')
        : [],
    zone: doc.data().toString().contains('zona') ? doc.get('zona').id : 'nan',
    teamDocumentReferenceID: doc.reference.id,
  );
}
