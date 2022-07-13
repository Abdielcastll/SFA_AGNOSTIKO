import 'package:cloud_firestore/cloud_firestore.dart';

class TeamsModel {
  final bool? active;
  final dynamic manager;
  final dynamic sellers;
  final dynamic zone;

  TeamsModel({
    this.active,
    this.manager,
    this.sellers,
    this.zone,
  });
}

class TeamfromSnapshot {
  // id type list from snapshot
  List<TeamsModel> teamListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TeamsModel(
        active: doc.get('nombre'),
        manager: doc.get('gerente'),
        sellers: doc.get('vendedores'),
        zone: doc.get('zone'),
      );
    }).toList();
  }
}
