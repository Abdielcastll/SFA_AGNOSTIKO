import 'package:cloud_firestore/cloud_firestore.dart';

class Promotions {
  final active;
  final description;
  final expireDate;
  final lastModification;
  final firebaseDocumentID;

  Promotions({
    this.description,
    this.active,
    this.expireDate,
    this.lastModification,
    this.firebaseDocumentID,
  });
}

List<Promotions> promotionListfromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    print(doc);
    print(doc.reference.id);
    print(doc.get("activo"));

    return Promotions(
      active:
          doc.data().toString().contains('activo') ? doc.get('activo') : false,
      description: doc.data().toString().contains('descripcion')
          ? doc.get('descripcion')
          : '',
      expireDate: doc.data().toString().contains('fecha_vencimiento')
          ? doc.get('fecha_vencimiento')
          : Timestamp.fromDate(DateTime.now()),
      lastModification: doc.data().toString().contains('ultimaModificacion')
          ? doc.get('ultimaModificacion')
          : Map<String, dynamic>.of({
              'timestamp': '',
              'usuario': '',
            }),
      firebaseDocumentID: doc.reference.id,
    );
  }).toList();
}
