import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/add_new_client/add_new_client_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/components/client_list.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({Key? key}) : super(key: key);

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  @override
  Widget build(BuildContext context) {
    final userZoneDocument = Provider.of<CurrentUserInfo>(context).zoneDocument;
    final clientsLimit =
        Provider.of<CounterLimitFirestore>(context).getClientsLimit;

    // print(currentUserActive.zone);
    return MultiProvider(
      providers: [
        StreamProvider<List<Clients>?>.value(
          value: clientsLimit == 0
              ? userZoneDocument == 'NaN'
                  ? clientsCollection.snapshots().map(clientListfromSnapshot)
                  : clientsCollection
                      .where('zona', isEqualTo: userZoneDocument)
                      .snapshots()
                      .map(clientListfromSnapshot)
              : userZoneDocument == 'NaN'
                  ? clientsCollection
                      .limit(clientsLimit)
                      .snapshots()
                      .map(clientListfromSnapshot)
                  : clientsCollection
                      .where('zona', isEqualTo: userZoneDocument)
                      .limit(clientsLimit)
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
        floatingActionButton: Wrap(
          // direction: Axis.horizontal,
          children: [
            // Container(
            // margin: const EdgeInsets.all(10.0),
            // child:
            FloatingActionButton(
              elevation: 10,
              backgroundColor: myTheme.colorScheme.primary,
              onPressed: () {
                // Redireccionar a crear cliente
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AddClientPage(),
                  ),
                );
              },
              child: const Icon(
                Icons.person_add_alt_sharp,
                color: Colors.white,
              ),
            ),
            // ),
          ],
        ),
        body: const ClientsBody(),
      ),
    );
  }
}

class ClientsBody extends StatefulWidget {
  const ClientsBody({
    Key? key,
  }) : super(key: key);

  @override
  State<ClientsBody> createState() => _ClientsBodyState();
}

class _ClientsBodyState extends State<ClientsBody> {
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      final clientsLimitProvider =
          Provider.of<CounterLimitFirestore>(context, listen: false);
      if (controller.position.atEdge) {
        bool isTop = controller.position.pixels == 0;
        if (isTop) {
          // Fluttertoast.showToast(msg: 'Tope de pagina');
          print('Top Clients page');
        } else {
          if (clientsLimitProvider.getScrollClientLimit == 0) {
            clientsLimitProvider.setClientsLimit(0, 0);
          } else {
            int newValor =
                int.parse(clientsLimitProvider.getScrollClientLimit.toString());
            if (newValor == 10) {
              clientsLimitProvider.setClientsLimit(
                  clientsLimitProvider.getClientsLimit + newValor, 10);
            } else if (newValor == 50) {
              clientsLimitProvider.setClientsLimit(
                  clientsLimitProvider.getClientsLimit + newValor, 50);
            }
          }
          print('Bottom Clients page');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Clients>? clients = Provider.of<List<Clients>?>(context) ?? [];
    List<Clients>? clientsList = clients;
    // final currentUserActive =
    //     Provider.of<CurrentUserProvider>(context).currentUserInfo;
    // print(
    //     clientsList.where((element) => element.zone == cur rentUserActive.zone));
    // print(clients);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Center(
          //   child: CircularProgressIndicator(),
          // ),
          ClientList(listOfClients: clientsList, controller: controller),
        ],
      ),
    );
  }
}
