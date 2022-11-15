// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/examples/clients_example.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/place_order/select_client.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlaceOrderPage extends StatelessWidget {
  const PlaceOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.newOrder,
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            fontSize: 21,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        backgroundColor: myTheme.colorScheme.primary,
        elevation: 0,
      ),
      body: MultiProvider(
        providers: [
          StreamProvider<List<Clients>?>.value(
            value: DatabaseServiceStreams().clients,
            initialData: const [],
            catchError: (context, error) {
              // print(error);
              return;
            },
          ),
          StreamProvider<IdTypeSummary?>.value(
            value: DatabaseServiceStreams().idTypeSummary,
            initialData: null,
            catchError: (context, error) {
              // print(error);
              return;
            },
          ),
          StreamProvider<ZoneSummary?>.value(
            value: DatabaseServiceStreams().zoneSummary,
            initialData: null,
            catchError: (context, error) {
              // print(error);
              return;
            },
          ),
        ],
        child: PlacerOrderBody(),
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
