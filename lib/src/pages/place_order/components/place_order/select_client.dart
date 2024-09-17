import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectClient extends StatefulWidget {
  SelectClient({
    Key? key,
    this.clientsList,
  }) : super(key: key);

  final List<Clients>? clientsList;

  @override
  State<SelectClient> createState() => _SelectClientState();
}

class _SelectClientState extends State<SelectClient> {
  final clientController = TextEditingController();
  List<Clients> starterClient = [genericClients];
  List<Clients>? mutatedList = [];

  @override
  initState() {
    mutatedList = widget.clientsList;
    super.initState();
  }

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
    setState(() => mutatedList = suggestions);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final orderActive = Provider.of<OrderProvider>(context);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: themeProvider.myTheme.colorScheme.primary,
            borderRadius: const BorderRadius.only(
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
                  style: const TextStyle(
                    fontFamily: 'Poppins-regular',
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: clientController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Feather.search),
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(
                      color: themeProvider.myTheme.colorScheme.primary,
                      fontFamily: 'Poppins-regular',
                    ),
                    hintText: AppLocalizations.of(context)!.searchClient,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: themeProvider.myTheme.colorScheme.primary),
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
            margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: mutatedList?.length ?? starterClient.length,
              // itemCount: 1,
              itemBuilder: (context, index) {
                final client = mutatedList?[index] ?? starterClient[index];
                final clientName = client.name;
                final clientFiscalAddress = client.fiscalAdress;
                return Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: ListTile(
                    tileColor: Colors.white,
                    selectedTileColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: themeProvider.myTheme.colorScheme.primary,
                      ),
                    ),
                    title: Text(
                      clientName,
                      style: const TextStyle(
                        fontFamily: 'Poppins-regular',
                      ),
                    ),
                    subtitle: Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                      child: Text(
                        clientFiscalAddress ?? '-',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        orderActive.setOrder(true, client);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: const RouteSettings(name: "ORDER"),
                          builder: (context) => const OrderPage(),
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
