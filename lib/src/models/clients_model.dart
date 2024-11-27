import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';

class Clients {
  final bool active;
  final specialContributor;
  final madeBy;
  final masterDiscount;
  final String? fiscalAdress;
  final String dispatchAdress;
  final String email;
  final prices;
  final modified;
  final String name;
  final int id;
  final prospect;
  final phone1;
  final phone2;
  final idType;
  final zone;
  final clientDocumentId;

  Clients({
    required this.active,
    required this.email,
    required this.name,
    required this.id,
    required this.dispatchAdress,
    this.specialContributor,
    this.madeBy,
    this.masterDiscount,
    this.fiscalAdress,
    this.prices,
    this.modified,
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

Clients genericClients = Clients(
  active: true,
  specialContributor: false,
  madeBy: '',
  masterDiscount: 0,
  fiscalAdress: 'Sin direccion',
  dispatchAdress: 'Sin Direccion',
  email: '',
  prices: 'TPGBASE',
  modified: Timestamp.now(),
  name: 'Usuario Default',
  id: 0,
  prospect: false,
  phone1: '',
  phone2: '',
  idType: '',
  zone: 'NaN',
  clientDocumentId: 'hEIOO4qTPYTqYChVeqxo',
);

Clients placeholderClient = Clients(
  active: true,
  specialContributor: false,
  madeBy: '',
  masterDiscount: 0,
  fiscalAdress: 'Sin direccion',
  dispatchAdress: 'Sin Direccion',
  email: '',
  prices: 'TPGBASE',
  modified: Timestamp.now(),
  name: 'Usuario Default',
  id: 0,
  prospect: false,
  phone1: '',
  phone2: '',
  idType: '',
  zone: 'NaN',
  clientDocumentId: 'hEIOO4qTPYTqYChVeqxo',
);

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
  final GeoPoint? localization;

  Client(
      {this.active,
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
      this.localization});

  factory Client.fromSnapshot(DocumentSnapshot snapshot) {
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
      localization: snapshot.data().toString().contains('localizacion')
          ? snapshot.get('localizacion')
          : null,
    );
  }
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

Future<void> initializeGenericClient() async {
  print("get default client");
  try {
    DocumentSnapshot doc = await clientesRef.doc('hEIOO4qTPYTqYChVeqxo').get();
    if (doc.exists) {
      print("cliente default: ${doc.data()}");
      genericClients = Clients(
        active: doc.get('activo') ?? true,
        specialContributor: doc.get('contribuyenteEspecial') ?? false,
        masterDiscount: doc.get('descuentoMaestro') ?? 0,
        fiscalAdress: doc.get('direccionFiscal') ?? 'Sin direccion',
        dispatchAdress: doc.get('direccionDespacho') ?? 'Sin Direccion',
        email: doc.get('email') ?? '',
        prices: doc.get('listaDePrecios')?.id ?? 'TPGBASE',
        modified: doc.get('modificado') ?? Timestamp.now(),
        name: doc.get('nombre') ?? 'Usuario firebase',
        id: doc.get('numeroId') ?? 0,
        prospect: doc.get('prospecto') ?? false,
        phone1: doc.get('telefono') ?? '',
        phone2: doc.get('telefono2') ?? '',
        idType: doc.get('tipoId')?.id ?? '',
        zone: doc.get('zona')?.id ?? 'NaN',
        clientDocumentId: doc.id,
      );
    } else {
      print('Generic client document does not exist. Using placeholder.');
      genericClients = placeholderClient;
    }
  } catch (e) {
    print('Error fetching generic client: $e. Using placeholder.');
    genericClients = placeholderClient;
  }
}
