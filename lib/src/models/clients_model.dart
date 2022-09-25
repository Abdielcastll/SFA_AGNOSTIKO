import 'package:cloud_firestore/cloud_firestore.dart';

class Clients {
  final active;
  final specialContributor;
  final madeBy;
  final masterDiscount;
  final fiscalAdress;
  final dispatchAdress;
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
  final clientDocumentId;

  Clients({
    this.active,
    this.specialContributor,
    this.madeBy,
    this.masterDiscount,
    this.fiscalAdress,
    this.dispatchAdress,
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
    this.clientDocumentId,
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
      dispatchAdress: doc.data().toString().contains('direccionDespacho')
          ? doc.get('direccionDespacho')
          : 'No hay direccion de despacho',
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
      clientDocumentId: doc.reference.id,
    );
  }).toList();
}

class Client {
  final active;
  final specialContributor;
  final madeBy;
  final masterDiscount;
  final fiscalAdress;
  final dispatchAdress;

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

  Client({
    this.active,
    this.specialContributor,
    this.madeBy,
    this.masterDiscount,
    this.fiscalAdress,
    this.dispatchAdress,
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

Client clientFromDocumentID(snapshot) {
  return Client(
    active: snapshot.get('activo'),
    specialContributor: snapshot.get('contribuyenteEspecial'),
    madeBy: snapshot.get('creadoPor').id,
    masterDiscount: snapshot.get('descuentoMaestro'),
    fiscalAdress: snapshot.get('direccionFiscal'),
    dispatchAdress: snapshot.data().toString().contains('direccionDespacho')
        ? snapshot.get('direccionDespacho')
        : 'No hay direccion de despacho',
    email: snapshot.get('email'),
    prices: snapshot.get('listaDePrecios').id,
    modified: snapshot.data().toString().contains('modificado')
        ? snapshot.get('modificado')
        : 'NaN',
    name: snapshot.get('nombre'),
    id: snapshot.get('numeroId'),
    prospect: snapshot.get('prospecto'),
    phone1: snapshot.get('telefono'),
    phone2: snapshot.data().toString().contains('telefono2')
        ? snapshot.get('telefono2')
        : 'NaN',
    idType: snapshot.data().toString().contains('tipoId')
        ? snapshot.get('tipoId').id
        : 'NaN',
    zone: snapshot.get('zona').id,
  );
}
