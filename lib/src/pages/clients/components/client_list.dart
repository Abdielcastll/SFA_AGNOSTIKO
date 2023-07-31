// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ClientList extends StatefulWidget {
  ClientList({
    Key? key,
    this.listOfClients,
    this.controller,
  }) : super(key: key);

  final List<Clients>? listOfClients;
  final ScrollController? controller;

  @override
  State<ClientList> createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  FocusNode myfocus = FocusNode();
  final searchClientController = TextEditingController();
  bool isDescending = true;
  bool isSearchingByname = false;
  List<Clients>? mutatedList;

  final List<String> items = ['10', '50', 'Todos'];
  String? selectedValue;

  List<Clients> filteredClients = [];

  @override
  initState() {
    mutatedList = widget.listOfClients;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final zonesSummary = Provider.of<ZoneSummary?>(context)?.summary ?? {};
    final idTypeSummary = Provider.of<IdTypeSummary?>(context)?.summary ?? {};
    final clientsLimit =
        Provider.of<CounterLimitFirestore>(context).getClientsLimit;
    final clientsScrollLimit =
        Provider.of<CounterLimitFirestore>(context).getScrollClientLimit;
    final userZoneDocument = Provider.of<CurrentUserInfo>(context).zoneDocument;

    return GestureDetector(
      onTap: () {
        myfocus.unfocus();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: myTheme.colorScheme.surface,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(8, 16, 0, 0),
                  height: 40,
                  width: 200,
                  child: TextField(
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins-regular',
                    ),
                    focusNode: myfocus,
                    keyboardType: isSearchingByname
                        ? TextInputType.text
                        : TextInputType.phone,
                    maxLines: 1,
                    textCapitalization: TextCapitalization.characters,
                    controller: searchClientController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(
                        isSearchingByname ? Icons.person : Icons.numbers,
                        color: isSearchingByname
                            ? myTheme.colorScheme.primary
                            : myTheme.colorScheme.onPrimaryContainer,
                      ),
                      suffixIcon: IconButton(
                        splashRadius: 1,
                        icon: Icon(
                          Icons.compare_arrows_rounded,
                          color: myTheme.colorScheme.onPrimaryContainer,
                        ),
                        onPressed: () {
                          setState(() {
                            isSearchingByname = !isSearchingByname;
                            filteredClients.clear();
                          });
                          myfocus.unfocus();
                          searchClientController.clear();
                        },
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                      hintText: isSearchingByname == true
                          ? 'Buscar nombre'
                          // : AppLocalizations.of(context)!.searchProductCode,
                          : 'Buscar DNI',
                      hintStyle: const TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 11,
                      ),
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: myTheme.colorScheme.primary.withOpacity(0.5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: myTheme.colorScheme.primary.withOpacity(0.5),
                        ),
                      ),
                    ),
                    onChanged: ((value) {
                      if (value.length == 0) {
                        setState(() {
                          filteredClients.clear();
                        });
                      }
                    }),
                    textInputAction: TextInputAction.go,
                    onSubmitted: ((value) async {
                      // isSearchingByname == true
                      print(value);
                      String? loweredCaseValue = value.toLowerCase();
                      List<String> loweredCaseValueSplit =
                          loweredCaseValue.split(' ');
                      // List<String> loweredCaseValueSplit =
                      //     getSplittedWord(loweredCaseValue);
                      print('loweredCaseValueSplit: $loweredCaseValueSplit');
                      filteredClients.clear();
                      var selectedClientsCollection = isSearchingByname == true
                          ? userZoneDocument == 'NaN'
                              ? clientsCollection
                                  .where('nombreIndice',
                                      arrayContainsAny: loweredCaseValueSplit)
                                  .snapshots()
                              : clientsCollection
                                  .where('zona', isEqualTo: userZoneDocument)
                                  .where('nombreIndice',
                                      arrayContainsAny: loweredCaseValueSplit)
                                  .snapshots()
                          : userZoneDocument == 'NaN'
                              ? clientsCollection
                                  .where('zona', isEqualTo: userZoneDocument)
                                  .where('numeroId',
                                      isEqualTo: int.parse(value))
                                  .snapshots()
                              : clientsCollection
                                  .where('zona', isEqualTo: userZoneDocument)
                                  .where('numeroId',
                                      isEqualTo: int.parse(value))
                                  .snapshots();
                      await selectedClientsCollection.forEach((element) {
                        for (var snapshot in element.docs) {
                          Clients product = Clients(
                            active:
                                snapshot.data().toString().contains('activo')
                                    ? snapshot.get('activo')
                                    : false,
                            specialContributor: snapshot
                                    .data()
                                    .toString()
                                    .contains('contribuyenteEspecial')
                                ? snapshot.get('contribuyenteEspecial')
                                : false,
                            madeBy:
                                snapshot.data().toString().contains('creadoPor')
                                    ? snapshot.get('creadoPor').id
                                    : 'NaN',
                            masterDiscount: snapshot
                                    .data()
                                    .toString()
                                    .contains('descuentoMaestro')
                                ? snapshot.get('descuentoMaestro')
                                : 'NaN',
                            fiscalAdress: snapshot
                                    .data()
                                    .toString()
                                    .contains('direccionFiscal')
                                ? snapshot.get('direccionFiscal')
                                : 'NaN',
                            dispatchAdress: snapshot
                                    .data()
                                    .toString()
                                    .contains('direccionDespacho')
                                ? snapshot.get('direccionDespacho')
                                : 'No hay direccion de despacho',
                            email: snapshot.data().toString().contains('email')
                                ? snapshot.get('email')
                                : 'NaN',
                            prices: snapshot
                                    .data()
                                    .toString()
                                    .contains('listaDePrecios')
                                ? snapshot.get('listaDePrecios').id
                                : 'NaN',
                            modified: snapshot
                                    .data()
                                    .toString()
                                    .contains('modificado')
                                ? snapshot.get('modificado')
                                : 'NaN',
                            name: snapshot.data().toString().contains('nombre')
                                ? snapshot.get('nombre')
                                : 'NaN',
                            id: snapshot.data().toString().contains('numeroId')
                                ? snapshot.get('numeroId')
                                : 'NaN',
                            prospect:
                                snapshot.data().toString().contains('prospecto')
                                    ? snapshot.get('prospecto')
                                    : false,
                            phone1:
                                snapshot.data().toString().contains('telefono')
                                    ? snapshot.get('telefono')
                                    : 'NaN',
                            phone2:
                                snapshot.data().toString().contains('telefono2')
                                    ? snapshot.get('telefono2')
                                    : 'NaN',
                            idType:
                                snapshot.data().toString().contains('tipoId')
                                    ? snapshot.get('tipoId').id
                                    : 'NaN',
                            zone: snapshot.data().toString().contains('zona')
                                ? snapshot.get('zona').id
                                : 'NaN',
                            clientDocumentId: snapshot.reference.id,
                          );
                          setState(() {
                            filteredClients.add(product);
                          });
                        }
                      });
                      if (selectedClientsCollection.length == 0) {}
                    }),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(4, 16, 0, 0),
                  height: 40,
                  width: 68,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xFFDFE0FF)),
                  child: IconButton.filled(
                    onPressed: () =>
                        setState(() => isDescending = !isDescending),
                    icon: isDescending
                        ? Icon(
                            MaterialCommunityIcons.sort_alphabetical_descending,
                            color: myTheme.colorScheme.onPrimaryContainer,
                          )
                        : Icon(
                            MaterialCommunityIcons.sort_alphabetical_ascending,
                            color: myTheme.colorScheme.onPrimaryContainer,
                          ),
                  ),
                ),
                userZoneDocument == 'NaN'
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(top: 16, left: 4),
                        height: 40,
                        width: 68,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(0xFFDFE0FF)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            hint: Text(
                              selectedValue == null
                                  ? clientsLimit == 0
                                      ? 'Todos'
                                      : '$clientsScrollLimit'
                                  : selectedValue.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins-regular',
                                color: myTheme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            items: items
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme
                                              .colorScheme.onPrimaryContainer,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: selectedValue,
                            onChanged: (value) {
                              final clientsLimitProvider =
                                  Provider.of<CounterLimitFirestore>(context,
                                      listen: false);
                              setState(() {
                                selectedValue = value as String;
                              });
                              if (selectedValue == 'Todos') {
                                clientsLimitProvider.setClientsLimit(0, 0);
                              } else {
                                int newValor =
                                    int.parse(selectedValue.toString());
                                if (newValor == 10) {
                                  clientsLimitProvider.setClientsLimit(
                                      newValor, 10);
                                } else if (newValor == 50) {
                                  clientsLimitProvider.setClientsLimit(
                                      newValor, 50);
                                }
                              }
                            },
                            alignment: Alignment.center,
                            buttonStyleData: const ButtonStyleData(
                              height: 40,
                              width: 60,
                              elevation: 1,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              width: 100,
                              elevation: 1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Color(0xFFDFE0FF),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          // SizedBox(height: 10),
          filteredClients.isEmpty
              ? Container(
                  margin: const EdgeInsets.fromLTRB(0, 16, 0, 10),
                  // color: Colors.grey,
                  // height: MediaQuery.of(context).size.height * 0.68,

                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: widget.controller,
                    physics: const BouncingScrollPhysics(),
                    itemCount: mutatedList!.length,
                    itemBuilder: (BuildContext context, index) {
                      final sortedClients = isDescending
                          ? mutatedList?.reversed.toList()
                          : mutatedList;
                      final client = sortedClients?[index];
                      final clientSpecialContributor =
                          client?.specialContributor ?? 'NaN';
                      final clientMasterDiscount =
                          client?.masterDiscount ?? 'NaN';
                      final clientFiscalAddress = client?.fiscalAdress ?? 'NaN';
                      final clientEmail = client?.email ?? 'NaN';
                      final clientPrices = client?.prices ?? 'NaN';
                      final clientName = client?.name ?? 'NaN';
                      final clientPhone1 = client?.phone1 ?? 'NaN';
                      final clientPhone2 = client?.phone2 ?? 'NaN';
                      final clientIdType =
                          idTypeSummary[client?.idType] ?? 'NaN';
                      final clientId = client?.id ?? 'NaN';
                      final clientZone = zonesSummary[client?.zone] ?? 'NaN';
                      final clientDocumentReferenceID =
                          client?.clientDocumentId ?? 'NaN';
                      final clientDispatchAddress =
                          client?.dispatchAdress ?? 'NaN';

                      return Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width,
                        child: ListTile(
                          tileColor: Colors.white,
                          splashColor: myTheme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          onTap: () {
                            // Redireccion a detalles de cliente
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClientDetails(
                                  specialContribuyer: clientSpecialContributor,
                                  masterDiscount: clientMasterDiscount,
                                  fiscalAddress: clientFiscalAddress,
                                  email: clientEmail,
                                  listOfPrices: clientPrices,
                                  name: clientName,
                                  tlf1: clientPhone1,
                                  tlf2: clientPhone2,
                                  typeId: clientIdType,
                                  nameId: clientId,
                                  zone: clientZone,
                                  clientDocumentReferenceID:
                                      clientDocumentReferenceID,
                                  dispatchAddress: clientDispatchAddress,
                                ),
                              ),
                            );
                          },
                          title: Container(
                            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            width: 240,
                            child: Text(
                              clientName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 14,
                                wordSpacing: 0.5,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              SizedBox(height: 10),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      width: 170,
                                      child: Text(
                                        clientFiscalAddress
                                            .toString()
                                            .toLowerCase(),
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      width: 150,
                                      child: Text(
                                        clientPhone1,
                                        maxLines: 2,
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          fontSize: 11,
                                          color: Colors.purple.shade500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  // color: Colors.grey,
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height * 0.68,
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: widget.controller,
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredClients.length,
                    itemBuilder: (BuildContext context, index) {
                      final sortedClients = isDescending
                          ? filteredClients.reversed.toList()
                          : filteredClients;
                      final client = sortedClients[index];
                      final clientSpecialContributor =
                          client.specialContributor ?? 'NaN';
                      final clientMasterDiscount =
                          client.masterDiscount ?? 'NaN';
                      final clientFiscalAddress = client.fiscalAdress ?? 'NaN';
                      final clientEmail = client.email ?? 'NaN';
                      final clientPrices = client.prices ?? 'NaN';
                      final clientName = client.name ?? 'NaN';
                      final clientPhone1 = client.phone1 ?? 'NaN';
                      final clientPhone2 = client.phone2 ?? 'NaN';
                      final clientIdType =
                          idTypeSummary[client.idType] ?? 'NaN';
                      final clientId = client.id ?? 'NaN';
                      final clientZone = zonesSummary[client.zone] ?? 'NaN';
                      final clientDocumentReferenceID =
                          client.clientDocumentId ?? 'NaN';
                      final clientDispatchAddress =
                          client.dispatchAdress ?? 'NaN';

                      return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          onTap: () {
                            // Redireccion a detalles de cliente
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClientDetails(
                                  specialContribuyer: clientSpecialContributor,
                                  masterDiscount: clientMasterDiscount,
                                  fiscalAddress: clientFiscalAddress,
                                  email: clientEmail,
                                  listOfPrices: clientPrices,
                                  name: clientName,
                                  tlf1: clientPhone1,
                                  tlf2: clientPhone2,
                                  typeId: clientIdType,
                                  nameId: clientId,
                                  zone: clientZone,
                                  clientDocumentReferenceID:
                                      clientDocumentReferenceID,
                                  dispatchAddress: clientDispatchAddress,
                                ),
                              ),
                            );
                          },
                          title: Container(
                            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            width: 240,
                            child: Text(
                              clientName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 14,
                                wordSpacing: 0.5,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              SizedBox(height: 10),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      width: 170,
                                      child: Text(
                                        clientFiscalAddress
                                            .toString()
                                            .toLowerCase(),
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      width: 150,
                                      child: Text(
                                        clientPhone1,
                                        maxLines: 2,
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          fontSize: 11,
                                          color: Colors.purple.shade500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          SizedBox(height: 60),
        ],
      ),
    );
  }
}
