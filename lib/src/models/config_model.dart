import 'package:cloud_firestore/cloud_firestore.dart';

class ConfigModel {
  final int? config;

  ConfigModel({
    this.config,
  });
}

class ConfigfromSnapshot {
  // id type list from snapshot
  List<ConfigModel> configListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ConfigModel(
        config: doc.get('numero'),
      );
    }).toList();
  }
}
