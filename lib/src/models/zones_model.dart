import 'package:cloud_firestore/cloud_firestore.dart';

class ZonesModel {
  final String? zone;

  ZonesModel({
    this.zone,
  });
}

class ZonesfromSnapshot {
  // zone list from snapshot
  List<ZonesModel> zoneListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ZonesModel(
        zone: doc.get('nombre'),
      );
    }).toList();
  }
}
