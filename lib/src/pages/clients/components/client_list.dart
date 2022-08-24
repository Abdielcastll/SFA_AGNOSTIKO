// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/examples/clients_example.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ClientList extends StatefulWidget {
  ClientList({Key? key}) : super(key: key);

  @override
  State<ClientList> createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  final searchController = TextEditingController();
  List<CLientsExample> clients = allClients;

  void searchClient(String query) {
    final suggestions = allClients.where((element) {
      final clientName = element.name.toLowerCase();
      final input = query.toLowerCase();

      return clientName.contains(input);
    }).toList();
    setState(() {
      clients = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            controller: searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
              hintText: 'Buscar nombre',
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
            onChanged: searchClient,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  MaterialCommunityIcons.order_alphabetical_ascending,
                  color: Colors.grey.shade500,
                  size: 25,
                ),
                splashRadius: 15,
                onPressed: () {
                  // Re ordenar el list view alfabeticamente
                },
              ),
              IconButton(
                icon: Icon(
                  MaterialCommunityIcons.filter_variant,
                  color: Colors.grey.shade500,
                  size: 25,
                ),
                splashRadius: 15,
                onPressed: () {
                  // Abrir si se quiere ver por prospecto o no
                },
              ),
            ],
          ),
        ),
        Container(
          // margin: EdgeInsets.only(top: 10.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: clients.length,
            itemBuilder: (BuildContext context, index) {
              final client = clients[index];
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
                          specialContribuyer: client.specialContribuyer,
                          masterDiscount: client.masterDiscount,
                          fiscalAddress: client.fiscalAddress,
                          email: client.email,
                          listOfPrices: client.listOfPrices,
                          name: client.name,
                          tlf1: client.tlf1,
                          tlf2: client.tlf2,
                          typeId: client.typeId,
                          nameId: client.nameId,
                          zone: client.zone,
                        ),
                      ),
                    );
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        width: 200,
                        child: Text(
                          client.name,
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
                          client.fiscalAddress.toLowerCase(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                        width: 120,
                        height: 30,
                        child: Text(
                          client.email,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 10,
                            color: Colors.purple.shade500,
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
