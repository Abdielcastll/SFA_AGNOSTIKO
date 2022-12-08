// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClientList extends StatefulWidget {
  ClientList({
    Key? key,
    this.listOfClients,
  }) : super(key: key);

  List<Clients>? listOfClients;
  late List<Clients>? mutatedList = listOfClients;

  @override
  State<ClientList> createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  final searchClientController = TextEditingController();
  bool isDescending = false;

  // Esta funcion se llama cada vez que el text field cambia
  void _searchClient(String query) {
    List<Clients>? suggestions;
    // si la barra de busqueda esta vacia o solo contiene espacios vacios,
    // se hara display de todos los items
    if (query.isEmpty) {
      suggestions = widget.listOfClients;
    } else {
      suggestions = widget.listOfClients
          ?.where((clients) =>
              clients.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    // Refrescar la UI
    setState(() => widget.mutatedList = suggestions);
  }

  @override
  Widget build(BuildContext context) {
    final zonesSummary = Provider.of<ZoneSummary?>(context)?.summary ?? {};
    final idTypeSummary = Provider.of<IdTypeSummary?>(context)?.summary ?? {};
    // print(widget.mutatedList);
    // print(clientsList);
    // print(zonesSummary);
    // print(idTypeSummary);

    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins-regular',
            ),
            keyboardType: TextInputType.text,
            maxLines: 1,
            maxLength: 200,
            textCapitalization: TextCapitalization.characters,
            controller: searchClientController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
              hintText: AppLocalizations.of(context)!.searchProductName,
              hintStyle: TextStyle(
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
            onChanged: _searchClient,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                    SizedBox(width: 5),
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
              // IconButton(
              //   icon: Icon(
              //     MaterialCommunityIcons.filter_variant,
              //     color: Colors.grey.shade500,
              //     size: 25,
              //   ),
              //   splashRadius: 15,
              //   onPressed: () {
              //     // Abrir si se quiere ver por prospecto o no
              //   },
              // ),
            ],
          ),
        ),
        widget.listOfClients!.isNotEmpty
            ? Container(
                // margin: EdgeInsets.only(top: 10.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
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
                      margin: EdgeInsets.only(top: 10.0),
                      // height: 120,
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
                          print('Redireccion a detalles del cliente');
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              width: 200,
                              child: Text(
                                clientName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
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
                            Container(
                              width: 200,
                              child: Text(
                                clientFiscalAddress.toString().toLowerCase(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
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
            : Center(
                child: Text('Cargando'),
              )
      ],
    );
  }
}
