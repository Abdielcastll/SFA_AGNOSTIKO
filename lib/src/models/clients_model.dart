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
  return snapshot.docs.map((snapshot) {
    return Clients(
      active: snapshot.data().toString().contains('activo')
          ? snapshot.get('activo')
          : 'NaN',
      specialContributor:
          snapshot.data().toString().contains('contribuyenteEspecial')
              ? snapshot.get('contribuyenteEspecial')
              : false,
      madeBy: snapshot.data().toString().contains('creadoPor')
          ? snapshot.get('creadoPor').id
          : 'NaN',
      masterDiscount: snapshot.data().toString().contains('descuentoMaestro')
          ? snapshot.get('descuentoMaestro')
          : 'NaN',
      fiscalAdress: snapshot.data().toString().contains('direccionFiscal')
          ? snapshot.get('direccionFiscal')
          : 'NaN',
      dispatchAdress: snapshot.data().toString().contains('direccionDespacho')
          ? snapshot.get('direccionDespacho')
          : 'No hay direccion de despacho',
      email: snapshot.data().toString().contains('email')
          ? snapshot.get('email')
          : 'NaN',
      prices: snapshot.data().toString().contains('listaDePrecios')
          ? snapshot.get('listaDePrecios').id
          : 'NaN',
      modified: snapshot.data().toString().contains('modificado')
          ? snapshot.get('modificado')
          : 'NaN',
      name: snapshot.data().toString().contains('nombre')
          ? snapshot.get('nombre')
          : 'NaN',
      id: snapshot.data().toString().contains('numeroId')
          ? snapshot.get('numeroId')
          : 'NaN',
      prospect: snapshot.data().toString().contains('prospecto')
          ? snapshot.get('prospecto')
          : false,
      phone1: snapshot.data().toString().contains('telefono')
          ? snapshot.get('telefono')
          : 'NaN',
      phone2: snapshot.data().toString().contains('telefono2')
          ? snapshot.get('telefono2')
          : 'NaN',
      idType: snapshot.data().toString().contains('tipoId')
          ? snapshot.get('tipoId').id
          : 'NaN',
      zone: snapshot.data().toString().contains('zona')
          ? snapshot.get('zona').id
          : 'NaN',
      clientDocumentId: snapshot.reference.id,
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
  final clientDocumentId;

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
    this.clientDocumentId,
  });
}

Client clientFromDocumentID(snapshot) {
  return Client(
    active: snapshot.data().toString().contains('activo')
        ? snapshot.get('activo')
        : 'NaN',
    specialContributor:
        snapshot.data().toString().contains('contribuyenteEspecial')
            ? snapshot.get('contribuyenteEspecial')
            : false,
    madeBy: snapshot.data().toString().contains('creadoPor')
        ? snapshot.get('creadoPor').id
        : 'NaN',
    masterDiscount: snapshot.data().toString().contains('descuentoMaestro')
        ? snapshot.get('descuentoMaestro')
        : 'NaN',
    fiscalAdress: snapshot.data().toString().contains('direccionFiscal')
        ? snapshot.get('direccionFiscal')
        : 'NaN',
    dispatchAdress: snapshot.data().toString().contains('direccionDespacho')
        ? snapshot.get('direccionDespacho')
        : 'No hay direccion de despacho',
    email: snapshot.data().toString().contains('email')
        ? snapshot.get('email')
        : 'NaN',
    prices: snapshot.data().toString().contains('listaDePrecios')
        ? snapshot.get('listaDePrecios').id
        : 'NaN',
    modified: snapshot.data().toString().contains('modificado')
        ? snapshot.get('modificado')
        : 'NaN',
    name: snapshot.data().toString().contains('nombre')
        ? snapshot.get('nombre')
        : 'NaN',
    id: snapshot.data().toString().contains('numeroId')
        ? snapshot.get('numeroId')
        : 'NaN',
    prospect: snapshot.data().toString().contains('prospecto')
        ? snapshot.get('prospecto')
        : false,
    phone1: snapshot.data().toString().contains('telefono')
        ? snapshot.get('telefono')
        : 'NaN',
    phone2: snapshot.data().toString().contains('telefono2')
        ? snapshot.get('telefono2')
        : 'NaN',
    idType: snapshot.data().toString().contains('tipoId')
        ? snapshot.get('tipoId').id
        : 'NaN',
    zone: snapshot.data().toString().contains('zona')
        ? snapshot.get('zona').id
        : 'NaN',
    clientDocumentId: snapshot.reference.id,
  );
}

class ClientName {
  final name;
  final clientDocumentId;
  final zone;

  ClientName({
    this.name,
    this.clientDocumentId,
    this.zone,
  });
}

List<ClientName> clientNameFromDocumentID(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return ClientName(
      name: doc.get('nombre'),
      clientDocumentId: doc.reference.id,
      zone: doc.get('zona').id,
    );
  }).toList();
}
