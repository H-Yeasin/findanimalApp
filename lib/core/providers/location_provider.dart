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

    // Try last known position first (fastest, helps with approximate location)
    Position? position = await Geolocator.getLastKnownPosition();

    // If null, get current position with timeout and medium accuracy using modern LocationSettings
    position ??= await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter:
            10, // Optional: minimum distance (in meters) before an update is triggered
      ),
    ).timeout(const Duration(seconds: 15));

    return LatLng(position.latitude, position.longitude);
  } catch (e) {
    return null;
  }
});
