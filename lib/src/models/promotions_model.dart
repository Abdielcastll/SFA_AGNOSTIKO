import 'package:cloud_firestore/cloud_firestore.dart';

class PromotionModel {
  final String? description;
  final bool? active;
  final dynamic expireDate;

  PromotionModel({
    this.description,
    this.active,
    this.expireDate,
  });
}

class PromotionfromSnapshot {
  // Promotion list from snapshot
  List<PromotionModel> promotionListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PromotionModel(
        description: doc.get('descripcion'),
        active: doc.get('activo'),
        expireDate: doc.get('fecha_vencimiento'),
      );
    }).toList();
  }
}
