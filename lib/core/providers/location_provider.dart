import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final locationPermissionProvider = FutureProvider<bool>((ref) async {
  return hasUsableLocationPermission();
});

Future<bool> hasUsableLocationPermission({bool requestIfDenied = false}) async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return false;

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied && requestIfDenied) {
    permission = await Geolocator.requestPermission();
  }

  return permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always;
}

final userLocationProvider = FutureProvider<LatLng?>((ref) async {
  try {
    final hasPermission = await hasUsableLocationPermission(
      requestIfDenied: true,
    );
    if (!hasPermission) return null;

    final position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  } catch (e) {
    return null;
  }
});
