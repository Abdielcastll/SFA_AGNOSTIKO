import 'package:cloud_firestore/cloud_firestore.dart';

class BankModel {
  final String? coinId;
  final bool? international;
  final String? name;
  final dynamic namdeIndex;

  BankModel({
    this.coinId,
    this.international,
    this.namdeIndex,
    this.name,
  });
}

class BankfromSnapshot {
  // id type list from snapshot
  List<BankModel> bankListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return BankModel(
        coinId: doc.get('codigoMoneda'),
        international: doc.get('internacional'),
        namdeIndex: doc.get('nombreIndice'),
        name: doc.get('nombre'),
      );
    }).toList();
  }
}
