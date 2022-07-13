import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceModel {
  final dynamic device;

  DeviceModel({
    this.device,
  });
}

class DevicefromSnapshot {
  // id type list from snapshot
  List<DeviceModel> deviceListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DeviceModel(
        device: doc.get('nombre'),
      );
    }).toList();
  }
}
