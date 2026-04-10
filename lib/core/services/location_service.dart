import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;

class LocationService {
  /// Check if location services are enabled and permissions are granted.
  Future<bool> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      try {
        // Attempt to show the native Android "Turn on Location" dialog without leaving the app
        final loc.Location location = loc.Location();
        bool isTurnedOn = await location.requestService();
        if (!isTurnedOn) {
          return false;
        }
      } catch (e) {
        // Fallback: Drop user into device settings if native prompt is unavailable (e.g. iOS)
        await Geolocator.openLocationSettings();
        return false;
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Prompt user to allow permissions in device app settings
      await Geolocator.openAppSettings();
      return false;
    }

    return true;
  }

  /// Get the current position of the user.
  Future<Position?> getCurrentPosition() async {
    final hasPermission = await checkPermission();
    if (!hasPermission) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
  }

  /// Get a stream of the user's current position.
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10, // Update every 10 meters
      ),
    );
  }

  /// Calculate distance between two points in meters.
  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}
