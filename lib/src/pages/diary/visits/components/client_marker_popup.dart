import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';

class ClientMarkerPopup extends StatelessWidget {
  const ClientMarkerPopup(
      {Key? key, required this.client, required this.onSelectToRoute})
      : super(key: key);
  final Client client;
  final Function(LatLng) onSelectToRoute;

  @override
  Widget build(BuildContext context) {
    final ZoneSummary? zonesSummary = context.watch<ZoneSummary?>();

    return SizedBox(
      width: 220,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: zonesSummary == null
            ? const CupertinoActivityIndicator()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      client.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${client.localization!.latitude}, ${client.localization!.longitude}',
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: const Text('Trazar ruta'),
                          onPressed: () {
                            onSelectToRoute(LatLng(
                                client.localization!.latitude,
                                client.localization!.longitude));
                          },
                        ),
                        TextButton(
                          child: const Text('Ver cliente'),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ClientDetails(
                                        dispatchAddress: client.dispatchAdress,
                                        clientDocumentReferenceID:
                                            client.clientDocumentId,
                                        email: client.email,
                                        fiscalAddress: client.fiscalAdress,
                                        name: client.name,
                                        tlf1: client.phone1,
                                        tlf2: client.phone2,
                                        masterDiscount: client.masterDiscount,
                                        zone: zonesSummary.summary[client.zone],
                                        specialContribuyer:
                                            client.specialContributor,
                                        listOfPrices: client.prices,
                                        typeId: client.idType,
                                        nameId: client.id,
                                      )),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
