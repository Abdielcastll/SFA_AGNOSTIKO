import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  final bool? active;
  final bool? specialContributor;
  final dynamic madeBy;
  final int? masterDiscount;
  final String? fiscalAdress;
  final String? email;
  final dynamic prices;
  final String? name;
  final dynamic nameIndex;
  final dynamic id;
  final bool? prospect;
  final String? phone1;
  final String? phone2;
  final dynamic idType;
  final dynamic zone;

  ClientModel({
    this.active,
    this.specialContributor,
    this.madeBy,
    this.masterDiscount,
    this.fiscalAdress,
    this.email,
    this.prices,
    this.name,
    this.nameIndex,
    this.id,
    this.prospect,
    this.phone1,
    this.phone2,
    this.idType,
    this.zone,
  });
}

class ClientfromSnapshot {
  // id type list from snapshot
  List<ClientModel> clientListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ClientModel(
        active: doc.get('activo'),
        specialContributor: doc.get('contribuyenteEspecial'),
        madeBy: doc.get('creadoPor'),
        masterDiscount: doc.get('descuentoMaestro'),
        email: doc.get('email'),
        prices: doc.get('listaDePrecios'),
        name: doc.get('nombre'),
        nameIndex: doc.get('nombreIndice'),
        id: doc.get('numeroId'),
        prospect: doc.get('prospecto'),
        phone1: doc.get('telefono'),
        phone2: doc.get('telefono2'),
        idType: doc.get('tipoId'),
        zone: doc.get('zona'),
      );
    }).toList();
  }
}
