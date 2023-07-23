import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

Future<Position?> determinePosition() async {
  bool serviceEnabled;

  LocationPermission permission;

  // Geolocator.openLocationSettings();

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }

  if (kDebugMode) {
    print('Location permission: $permission');
  }

  return await Geolocator.getLastKnownPosition(
      forceAndroidLocationManager: true);
}
