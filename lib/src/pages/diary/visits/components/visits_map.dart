import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/visit_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';

class VisitsMap extends StatelessWidget {
  const VisitsMap({super.key});

  @override
  Widget build(BuildContext context) {
    final visits = context.watch<List<Visits>?>() ?? [];
    print('visits $visits');

    return Scaffold(
        appBar: AppBar(
          title: const Text('Mapa de visitas'),
        ),
        body: VisitMapBody(
          visits: visits,
        ));
  }
}

class VisitMapBody extends StatefulWidget {
  const VisitMapBody({super.key, required this.visits});
  final List<Visits> visits;

  @override
  State<VisitMapBody> createState() => _VisitMapBodyState();
}

class _VisitMapBodyState extends State<VisitMapBody> {
  final MapController _mapController = MapController();

  List<Marker> markers = [
    Marker(
      width: 80,
      height: 80,
      point: LatLng(19.465796, -99.486712),
      builder: (context) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: const Column(
            children: [
              Icon(
                Icons.storefront,
                size: 36,
              ),
              Text(
                'Marker de prueba',
                textAlign: TextAlign.center,
              ),
            ],
          )),
    )
  ];

  double centerLat = 19.47;
  double centerLng = -99.49;

  Future<List<Marker>> getMarkers(List<Visits> visits) async {
    List<Marker> markersAux = [];
    var minLng = 180.0;
    var maxLng = -180.0;
    var minLat = 90.0;
    var maxLat = -90.0;

    for (final visit in visits) {
      print(visit.clientReferenceId);
      final snapshot = await clientesRef.doc(visit.clientReferenceId).get();
      final client = Client.fromSnapshot(snapshot);
      print('client.localization');
      print(client.localization);
      if (client.localization == null) continue;
      print(client.localization!.latitude);
      print(client.localization!.longitude);

      if (client.localization!.latitude > maxLat) {
        maxLat = client.localization!.latitude;
      }
      if (client.localization!.latitude < minLat) {
        minLat = client.localization!.latitude;
      }

      if (client.localization!.longitude > maxLng) {
        maxLng = client.localization!.longitude;
      }
      if (client.localization!.longitude < minLng) {
        minLng = client.localization!.longitude;
      }

      final newMarker = Marker(
        width: 56,
        height: 56,
        point: LatLng(
            client.localization!.latitude, client.localization!.longitude),
        builder: (context) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: const Column(
              children: [
                Icon(
                  Icons.storefront,
                  size: 40,
                ),
              ],
            )),
      );
      markersAux.add(newMarker);
    }
    print(minLat);
    print(maxLat);
    print(maxLng);
    print(minLng);

    setState(() {
      centerLat = minLat + ((maxLat.abs() - minLat.abs()) / 2);
      centerLng = minLng + ((maxLng.abs() - minLng.abs()) / 2);
      markers = markersAux;
    });

    _mapController.move(LatLng(centerLat, centerLng), 15);

    return markersAux;
  }

  @override
  initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant VisitMapBody oldWidget) {
    getMarkers(widget.visits);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print('widget.visits');
    print(widget.visits);
    print('centerLat');
    print(centerLat);
    print('centerLng');
    print(centerLng);
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        maxZoom: 20,
        minZoom: 1,
        center: LatLng(centerLat, centerLng),
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        zoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
        MarkerLayer(
          markers: markers,
        )
      ],
    );
  }
}
