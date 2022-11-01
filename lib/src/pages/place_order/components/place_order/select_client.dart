// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectClient extends StatefulWidget {
  SelectClient({
    Key? key,
    this.clientsList,
  }) : super(key: key);

  List<Clients>? clientsList;
  late List<Clients>? mutatedList = clientsList;

  @override
  State<SelectClient> createState() => _SelectClientState();
}

class _SelectClientState extends State<SelectClient> {
  final clientController = TextEditingController();

  // Esta funcion se llama cada vez que el text field cambia
  void _searchClient(String query) {
    List<Clients>? suggestions;
    // si la barra de busqueda esta vacia o solo contiene espacios vacios,
    // se hara display de todos los items
    if (query.isEmpty) {
      suggestions = widget.clientsList;
    } else {
      suggestions = widget.clientsList
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
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: myTheme.colorScheme.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.selectClient,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: clientController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Feather.search),
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(
                      color: myTheme.colorScheme.primary,
                      fontFamily: 'Poppins-regular',
                    ),
                    hintText: AppLocalizations.of(context)!.searchClient,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: myTheme.colorScheme.primary),
                    ),
                  ),
                  onChanged: _searchClient,
                ),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 16, left: 16, right: 16),
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: widget.mutatedList!.length,
              itemBuilder: (context, index) {
                final client = widget.mutatedList?[index];
                final clientName = client?.name;
                final clientFiscalAddress = client?.fiscalAdress;
                return Container(
                  padding: EdgeInsets.only(bottom: 5),
                  height: 80,
                  child: ListTile(
                    tileColor: Colors.white,
                    selectedTileColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: myTheme.colorScheme.primary,
                      ),
                    ),
                    title: Text(
                      clientName,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                      ),
                    ),
                    subtitle: Text(
                      clientFiscalAddress,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderPage(
                            client: client,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
