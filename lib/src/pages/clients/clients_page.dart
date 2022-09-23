// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/components/client_list.dart';
import 'package:pwa_sales2go_flutter/src/services/database.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({Key? key}) : super(key: key);

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Clients>?>.value(
          value: DatabaseService().clients,
          initialData: const [],
          catchError: (context, error) {
            print(error);
            return;
          },
        ),
        StreamProvider<IdTypeSummary?>.value(
          value: DatabaseService().idTypeSummary,
          initialData: null,
          catchError: (context, error) {
            print(error);
            return;
          },
        ),
        StreamProvider<ZoneSummary?>.value(
          value: DatabaseService().zoneSummary,
          initialData: null,
          catchError: (context, error) {
            print(error);
            return;
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBarNavigation(message: 'Clientes'),
        body: ClientsBody(),
      ),
    );
  }
}

class ClientsBody extends StatelessWidget {
  const ClientsBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clients = Provider.of<List<Clients>?>(context) ?? [];
    List<Clients>? clientsList = clients;
    // print(clientsList);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          ClientList(listOfClients: clientsList),
        ],
      ),
    );
  }
}
