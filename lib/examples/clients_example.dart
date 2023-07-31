class CLientsExample {
  final bool active;
  final bool specialContribuyer;
  final int masterDiscount;
  final String fiscalAddress;
  final String email;
  final String listOfPrices;
  final String name;
  final bool prospect;
  final String tlf1;
  final String tlf2;
  final String zone;
  final int nameId;
  final String typeId;

  CLientsExample(
      {required this.nameId,
      required this.active,
      required this.specialContribuyer,
      required this.masterDiscount,
      required this.fiscalAddress,
      required this.email,
      required this.listOfPrices,
      required this.name,
      required this.prospect,
      required this.tlf1,
      required this.tlf2,
      required this.zone,
      required this.typeId});
}

final allClients = [
  CLientsExample(
      active: true,
      specialContribuyer: true,
      masterDiscount: 10,
      fiscalAddress: "GENERICA GENERICA, , GENERICO, GENERICO, VENEZUELA",
      email: 'email1@gmail.com',
      listOfPrices: 'TGBPASE',
      name: 'ANDES GENERICO',
      prospect: false,
      tlf1: '(000) 000-0000 Ext: 0000',
      tlf2: '(000) 000-0000 Ext: 0000"',
      zone: 'TERRITORIO1',
      nameId: 70502274,
      typeId: 'J'),
  CLientsExample(
      active: true,
      specialContribuyer: false,
      masterDiscount: 15,
      fiscalAddress:
          "CALLE 23 ENTRE CARRERAS 18 Y 19 EDIF HOTEL PRINCIPE PISO PB LOCAL S/N ZONA CENTRO, BARQUISIMETO, LARA, Venezuela",
      email: 'email4@gmail.com',
      listOfPrices: 'GENER-12',
      name: 'HOTEL PRINCIPE C A',
      prospect: false,
      tlf1: '(000) 000-0004 Ext: 0000',
      tlf2: '(000) 000-0004 Ext: 0000"',
      zone: 'TERRITORIO4',
      nameId: 70502277,
      typeId: 'J'),
  CLientsExample(
      active: true,
      specialContribuyer: true,
      masterDiscount: 20,
      fiscalAddress:
          "AV 13 CALLE 72 EDF. , MARACAIBO, MARACAIBO, EDO. ZULIA, VENEZUELA",
      email: 'email3@gmail.com',
      listOfPrices: 'GENER-11',
      name: "SUPER ENNE 2000 72, C.A",
      prospect: false,
      tlf1: '(000) 000-0003 Ext: 0000',
      tlf2: '(000) 000-0003 Ext: 0000"',
      zone: 'TERRITORIO3',
      nameId: 70502276,
      typeId: 'J'),
  CLientsExample(
      active: true,
      specialContribuyer: false,
      masterDiscount: 0,
      fiscalAddress:
          "AV 14 LOCAL NRO 14-09 BARRIO SIERRA MAESTRA SAN FRANCISCO , , SAN FRANCISCO, EDO. ZULIA, VENEZUELA",
      email: 'email2@gmail.com',
      listOfPrices: 'GENER-11',
      name: 'REFRIGERACION MARACAIBO COMPAÑIA ANONIMA',
      prospect: false,
      tlf1: '(000) 000-0001 Ext: 0000',
      tlf2: '(000) 000-0001 Ext: 0000"',
      zone: 'TERRITORIO2',
      nameId: 70502275,
      typeId: 'J'),
  CLientsExample(
      active: true,
      specialContribuyer: true,
      masterDiscount: 10,
      fiscalAddress: "GENERICA BIND STUDIO, , GENERICO, GENERICO, VENEZUELA",
      email: 'email1@gmail.com',
      listOfPrices: 'TGBPASE',
      name: 'ANDES GENERICO',
      prospect: false,
      tlf1: '(000) 000-0000 Ext: 0000',
      tlf2: '(000) 000-0000 Ext: 0000"',
      zone: 'TERRITORIO1',
      nameId: 70502274,
      typeId: 'J'),
  CLientsExample(
      active: true,
      specialContribuyer: true,
      masterDiscount: 10,
      fiscalAddress:
          "GENERICA TRIGGER AND UFO, , GENERICO, GENERICO, VENEZUELA",
      email: 'email1@gmail.com',
      listOfPrices: 'TGBPASE',
      name: 'ANDES GENERICO',
      prospect: false,
      tlf1: '(000) 000-0000 Ext: 0000',
      tlf2: '(000) 000-0000 Ext: 0000"',
      zone: 'TERRITORIO1',
      nameId: 70502274,
      typeId: 'J'),
];
