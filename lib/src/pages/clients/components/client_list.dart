import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClientList extends StatefulWidget {
  ClientList({
    Key? key,
    this.listOfClients,
    this.controller,
  }) : super(key: key);

  List<Clients>? listOfClients;
  late List<Clients>? mutatedList = listOfClients;
  ScrollController? controller;

  @override
  State<ClientList> createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  final searchClientController = TextEditingController();
  bool isDescending = true;
  bool isSearchingByname = false;

  // Esta funcion se llama cada vez que el text field cambia
  // void _searchClient(String query) {
  //   List<Clients>? suggestions;
  //   // si la barra de busqueda esta vacia o solo contiene espacios vacios,
  //   // se hara display de todos los items
  //   if (query.isEmpty) {
  //     suggestions = widget.listOfClients;
  //   } else {
  //     suggestions = widget.listOfClients
  //         ?.where((clients) =>
  //             clients.name.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   }
  //   // Refrescar la UI
  //   setState(() => widget.mutatedList = suggestions);
  // }

  final List<String> items = ['10', '50', 'Todos'];
  String? selectedValue;

  List<Clients> filteredClients = [];

  @override
  Widget build(BuildContext context) {
    final zonesSummary = Provider.of<ZoneSummary?>(context)?.summary ?? {};
    final idTypeSummary = Provider.of<IdTypeSummary?>(context)?.summary ?? {};
    final clientsLimit =
        Provider.of<CounterLimitFirestore>(context).getClientsLimit;
    final clientsScrollLimit =
        Provider.of<CounterLimitFirestore>(context).getScrollClientLimit;
    final userZoneDocument = Provider.of<CurrentUserInfo>(context).zoneDocument;

    print('widget.controller: ${widget.controller}');
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins-regular',
            ),
            keyboardType: isSearchingByname == true
                ? TextInputType.text
                : TextInputType.phone,
            maxLines: 1,
            maxLength: 200,
            // textCapitalization: TextCapitalization.characters,
            controller: searchClientController,
            decoration: InputDecoration(
              prefixIcon: Icon(
                isSearchingByname ? Icons.person : Icons.numbers,
                color: isSearchingByname
                    ? myTheme.colorScheme.primary
                    : myTheme.colorScheme.onPrimaryContainer,
              ),
              suffixIcon: Container(
                child: IconButton(
                  splashRadius: 1,
                  icon: Icon(
                    Icons.compare_arrows_rounded,
                    color: myTheme.colorScheme.onPrimaryContainer,
                  ),
                  onPressed: () {
                    setState(() {
                      isSearchingByname = !isSearchingByname;
                    });
                  },
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
              hintText: isSearchingByname == true
                  ? AppLocalizations.of(context)!.searchProductName
                  // : AppLocalizations.of(context)!.searchProductCode,
                  : 'Buscar por, Cedula, RIF, etc...',
              hintStyle: const TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 14,
              ),
              counterText: '',
              border: OutlineInputBorder(
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
              filteredClients.clear();
              var selectedClientsCollection = isSearchingByname == true
                  ? clientsCollection
                      .where('zona', isEqualTo: userZoneDocument)
                      .where('nombreIndice', arrayContains: value)
                      .snapshots()
                  : clientsCollection
                      .where('zona', isEqualTo: userZoneDocument)
                      .where('numeroId', isEqualTo: int.parse(value))
                      .snapshots();
              await selectedClientsCollection.forEach((element) {
                for (var snapshot in element.docs) {
                  Clients product = Clients(
                    active: snapshot.data().toString().contains('activo')
                        ? snapshot.get('activo')
                        : 'NaN',
                    specialContributor: snapshot
                            .data()
                            .toString()
                            .contains('contribuyenteEspecial')
                        ? snapshot.get('contribuyenteEspecial')
                        : false,
                    madeBy: snapshot.data().toString().contains('creadoPor')
                        ? snapshot.get('creadoPor').id
                        : 'NaN',
                    masterDiscount:
                        snapshot.data().toString().contains('descuentoMaestro')
                            ? snapshot.get('descuentoMaestro')
                            : 'NaN',
                    fiscalAdress:
                        snapshot.data().toString().contains('direccionFiscal')
                            ? snapshot.get('direccionFiscal')
                            : 'NaN',
                    dispatchAdress:
                        snapshot.data().toString().contains('direccionDespacho')
                            ? snapshot.get('direccionDespacho')
                            : 'No hay direccion de despacho',
                    email: snapshot.data().toString().contains('email')
                        ? snapshot.get('email')
                        : 'NaN',
                    prices:
                        snapshot.data().toString().contains('listaDePrecios')
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
                  setState(() {
                    filteredClients.add(product);
                  });
                }
              });
              // filteredProducts.clear();
              // setState(() {
              //   filteredProducts = newList;
              // });
              // print(filteredProducts);
            }),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Row(
            children: [
              TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      MaterialCommunityIcons.order_alphabetical_ascending,
                      color: Colors.grey.shade500,
                      size: 25,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isDescending
                          ? AppLocalizations.of(context)!.ascendingFilter
                          : AppLocalizations.of(context)!.descendingFilter,
                      style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          color: Colors.grey.shade500,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onPressed: () {
                  // Re ordenar el list view alfabeticamente
                  setState(() => isDescending = !isDescending);
                },
              ),
              const SizedBox(width: 20),
              DropdownButtonHideUnderline(
                child: DropdownButton2(
                  hint: Text(
                    selectedValue == null
                        ? clientsLimit == 0
                            ? 'Todos'
                            : '$clientsScrollLimit'
                        : selectedValue.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
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
                      int newValor = int.parse(selectedValue.toString());
                      if (newValor == 10) {
                        clientsLimitProvider.setClientsLimit(newValor, 10);
                      } else if (newValor == 50) {
                        clientsLimitProvider.setClientsLimit(newValor, 50);
                      }
                    }
                  },
                  buttonHeight: 40,
                  buttonWidth: 140,
                  itemHeight: 40,
                  // dropdownElevation: 20,
                ),
              )
            ],
          ),
        ),
        filteredClients.isEmpty
            ? Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                // color: Colors.grey,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.69,
                child: ListView.builder(
                  controller: widget.controller,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.mutatedList!.length,
                  itemBuilder: (BuildContext context, index) {
                    final sortedClients = isDescending
                        ? widget.mutatedList?.reversed.toList()
                        : widget.mutatedList;
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
                    final clientIdType = idTypeSummary[client?.idType] ?? 'NaN';
                    final clientId = client?.id ?? 'NaN';
                    final clientZone = zonesSummary[client?.zone] ?? 'NaN';
                    final clientDocumentReferenceID =
                        client?.clientDocumentId ?? 'NaN';
                    final clientDispatchAddress =
                        client?.dispatchAdress ?? 'NaN';

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
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              width: 200,
                              child: Text(
                                clientName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              MaterialIcons.keyboard_arrow_right,
                              color: myTheme.colorScheme.secondary,
                              size: 18,
                            ),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                clientFiscalAddress.toString().toLowerCase(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                                width: 120,
                                height: 30,
                                child: Text(
                                  clientEmail,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    fontSize: 9,
                                    color: Colors.purple.shade500,
                                  ),
                                ),
                              ),
                            ),
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
                height: MediaQuery.of(context).size.height * 0.69,
                child: ListView.builder(
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
                    final clientMasterDiscount = client.masterDiscount ?? 'NaN';
                    final clientFiscalAddress = client.fiscalAdress ?? 'NaN';
                    final clientEmail = client.email ?? 'NaN';
                    final clientPrices = client.prices ?? 'NaN';
                    final clientName = client.name ?? 'NaN';
                    final clientPhone1 = client.phone1 ?? 'NaN';
                    final clientPhone2 = client.phone2 ?? 'NaN';
                    final clientIdType = idTypeSummary[client.idType] ?? 'NaN';
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
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              width: 200,
                              child: Text(
                                clientName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              MaterialIcons.keyboard_arrow_right,
                              color: myTheme.colorScheme.secondary,
                              size: 18,
                            ),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                clientFiscalAddress.toString().toLowerCase(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                                width: 120,
                                height: 30,
                                child: Text(
                                  clientEmail,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    fontSize: 9,
                                    color: Colors.purple.shade500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
