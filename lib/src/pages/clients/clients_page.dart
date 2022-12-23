import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/components/client_list.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/widgets/loading/loading_widget.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({Key? key}) : super(key: key);

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  @override
  Widget build(BuildContext context) {
    final userZoneDocument = Provider.of<CurrentUserInfo>(context).zoneDocument;

    // print(currentUserActive.zone);
    return MultiProvider(
      providers: [
        StreamProvider<List<Clients>?>.value(
          value: clientsCollection
              .where('zona', isEqualTo: userZoneDocument)
              .snapshots()
              .map(clientListfromSnapshot),
          initialData: const [],
          catchError: (context, error) {
            print(error);
            return;
          },
        ),
        StreamProvider<IdTypeSummary?>.value(
          value: DatabaseServiceStreams().idTypeSummary,
          initialData: null,
          catchError: (context, error) {
            return;
          },
        ),
        StreamProvider<ZoneSummary?>.value(
          value: DatabaseServiceStreams().zoneSummary,
          initialData: null,
          catchError: (context, error) {
            return;
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBarNavigation(
          message: AppLocalizations.of(context)!.clients,
          userZoneDocument: userZoneDocument,
        ),
        body: const ClientsBody(),
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
    // final currentUserActive =
    //     Provider.of<CurrentUserProvider>(context).currentUserInfo;
    // print(
    //     clientsList.where((element) => element.zone == currentUserActive.zone));
    // print(clients);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Center(
          //   child: CircularProgressIndicator(),
          // ),
          ClientList(listOfClients: clientsList),
        ],
      ),
    );
  }
}
