import 'package:cloud_firestore/cloud_firestore.dart';

class Clients {
  final active;
  final specialContributor;
  final madeBy;
  final masterDiscount;
  final fiscalAdress;
  final email;
  final prices;
  final modified;
  final name;
  final id;
  final prospect;
  final phone1;
  final phone2;
  final idType;
  final zone;

  Clients({
    this.active,
    this.specialContributor,
    this.madeBy,
    this.masterDiscount,
    this.fiscalAdress,
    this.email,
    this.prices,
    this.modified,
    this.name,
    this.id,
    this.prospect,
    this.phone1,
    this.phone2,
    this.idType,
    this.zone,
  });
}

List<Clients> clientListfromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return Clients(
      active: doc.get('activo'),
      specialContributor: doc.get('contribuyenteEspecial'),
      madeBy: doc.get('creadoPor').id,
      masterDiscount: doc.get('descuentoMaestro'),
      fiscalAdress: doc.get('direccionFiscal'),
      email: doc.get('email'),
      prices: doc.get('listaDePrecios').id,
      modified: doc.data().toString().contains('modificado')
          ? doc.get('modificado')
          : 'NaN',
      name: doc.get('nombre'),
      id: doc.get('numeroId'),
      prospect: doc.get('prospecto'),
      phone1: doc.get('telefono'),
      phone2: doc.data().toString().contains('telefono2')
          ? doc.get('telefono2')
          : 'NaN',
      idType: doc.data().toString().contains('tipoId')
          ? doc.get('tipoId').id
          : 'NaN',
      zone: doc.get('zona').id,
    );
  }).toList();
}
