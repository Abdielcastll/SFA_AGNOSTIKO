import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/visit_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/client_marker.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/client_marker_popup.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/utils/determinePosition.dart';
import 'package:open_route_service/open_route_service.dart';

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
  final PopupController _popupController = PopupController();
  OpenRouteService openRouteService = OpenRouteService(
      apiKey: '5b3ce3597851110001cf6248dc5bbb1e901c4342bcd66f2ba2067204');

  List<LatLng> routePoints = [];

  LatLng? visitFocused;

  Marker? userMarker;

  List<Marker> markers = [];

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

      final newMarker = ClientMarker(client: client);
      markersAux.add(newMarker);
    }

    setState(() {
      markers = markersAux;
    });

    _mapController.move(LatLng(centerLat, centerLng), 15);

    return markersAux;
  }

  getRoute(LatLng endCoordinate) async {
    if (userMarker == null) {
      return;
    }

    final List<ORSCoordinate> routeCoordinates =
        await openRouteService.directionsRouteCoordsGet(
      profileOverride: ORSProfile.drivingCar,
      startCoordinate: ORSCoordinate(
          latitude: userMarker!.point.latitude,
          longitude: userMarker!.point.longitude),
      endCoordinate: ORSCoordinate(
          latitude: endCoordinate.latitude, longitude: endCoordinate.longitude),
    );

    final List<LatLng> route = routeCoordinates
        .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
        .toList();
    print(route);
    setState(() {
      routePoints = route;
    });
  }

  buildUserMarker() async {
    final position = await determinePosition();

    if (position == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ubicacion del dispositivo no disponible.')));
      return;
    }

    setState(() {
      userMarker = Marker(
        point:
            LatLng(position.latitude, position.longitude), // 10.4746, -66.9473
        builder: (context) => Icon(
          Icons.location_on_rounded,
          size: 42,
          color: Colors.blue.shade600,
        ),
      );
    });

    centerLat = position.latitude;
    centerLng = position.longitude;

    _mapController.move(LatLng(position.latitude, position.longitude), 15);
  }

  onSelectToRoute(LatLng latLng) {
    setState(() {
      visitFocused = latLng;
    });
    getRoute(latLng);

    _mapController.move(latLng, 15);
  }

  focusNextVisit() {
    final newFocus = visitFocused != null
        ? markers.firstWhere((element) =>
            element.point.latitude != visitFocused!.latitude &&
            element.point.longitude != visitFocused!.longitude)
        : markers.first;
    onSelectToRoute(newFocus.point);
  }

  focusLocation() {
    _mapController.move(userMarker!.point, 15);
  }

  @override
  initState() {
    buildUserMarker();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant VisitMapBody oldWidget) {
    getMarkers(widget.visits);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<ZoneSummary?>.value(
          value: DatabaseServiceStreams().zoneSummary,
          initialData: null,
          catchError: (context, error) {
            return;
          },
        ),
      ],
      child: Stack(alignment: Alignment.bottomRight, children: [
        FlutterMap(
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
              markers: userMarker == null ? [] : [userMarker!],
            ),
            if (routePoints.isNotEmpty)
              PolylineLayer(
                polylineCulling: false,
                polylines: [
                  Polyline(
                      points: routePoints, color: Colors.blue, strokeWidth: 5),
                ],
              ),
            PopupMarkerLayer(
              options: PopupMarkerLayerOptions(
                  popupDisplayOptions: PopupDisplayOptions(
                    builder: (_, Marker marker) {
                      if (marker is ClientMarker) {
                        return ClientMarkerPopup(
                          client: marker.client,
                          onSelectToRoute: onSelectToRoute,
                        );
                      }
                      return const Card(
                        child: Text('Error'),
                      );
                    },
                  ),
                  popupController: _popupController,
                  markers: markers),
            ),
          ],
        ),
        if (markers.length > 1 || visitFocused == null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                margin: const EdgeInsets.only(bottom: 4, left: 8),
                width: 162,
                child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: focusLocation,
                        child: const Row(
                          children: [
                            Text('Centrar'),
                            Icon(
                              Icons.location_on_rounded,
                              color: Colors.white,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                margin: const EdgeInsets.only(bottom: 4, right: 8),
                width: 162,
                child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: focusNextVisit,
                        child: const Row(
                          children: [
                            Text('Siguiente Visita'),
                            Icon(
                              Icons.navigate_next_rounded,
                              color: Colors.white,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
      ]),
    );
  }
}
