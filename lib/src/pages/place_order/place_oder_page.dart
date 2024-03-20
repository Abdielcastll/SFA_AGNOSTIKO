import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/place_order/select_client.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlaceOrderPage extends StatelessWidget {
  const PlaceOrderPage({Key? key, this.userZoneDocument}) : super(key: key);

  final userZoneDocument;

  @override
  Widget build(BuildContext context) {
    print('userZoneDocument: $userZoneDocument');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.newOrder,
          style: const TextStyle(
            fontFamily: 'Poppins-regular',
            fontSize: 21,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        backgroundColor: myTheme.colorScheme.primary,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: MultiProvider(
        providers: [
          StreamProvider<List<Clients>?>.value(
            value: userZoneDocument == 'NaN'
                ? clientsCollection.snapshots().map(clientListfromSnapshot)
                : clientsCollection
                    .where('zona', isEqualTo: userZoneDocument)
                    .snapshots()
                    .map(clientListfromSnapshot),
            // clientsCollection
            //     .where('zona', isEqualTo: userZoneDocument)
            //     .snapshots()
            //     .map(clientListfromSnapshot),
            initialData: const [],
            catchError: (context, error) {
              return;
            },
          ),
        ],
        child: const PlacerOrderBody(),
      ),
    );
  }
}

class PlacerOrderBody extends StatefulWidget {
  const PlacerOrderBody({
    Key? key,
  }) : super(key: key);

  @override
  State<PlacerOrderBody> createState() => _PlacerOrderBodyState();
}

class _PlacerOrderBodyState extends State<PlacerOrderBody> {
  @override
  Widget build(BuildContext context) {
    final clients = Provider.of<List<Clients>?>(context) ?? [];
    List<Clients>? clientsList = clients;

    return SingleChildScrollView(
      child: SelectClient(clientsList: clientsList),
    );
  }
}
