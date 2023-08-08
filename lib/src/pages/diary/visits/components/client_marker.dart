import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';

class ClientMarker extends Marker {
  final Client client;
  ClientMarker({required this.client})
      : super(
          anchorPos: AnchorPos.align(AnchorAlign.top),
          height: 44,
          width: 44,
          point: LatLng(
              client.localization!.latitude, client.localization!.longitude),
          builder: (BuildContext ctx) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: const Column(
              children: [
                Icon(
                  Icons.storefront,
                  size: 36,
                ),
              ],
            ),
          ),
        );
}
