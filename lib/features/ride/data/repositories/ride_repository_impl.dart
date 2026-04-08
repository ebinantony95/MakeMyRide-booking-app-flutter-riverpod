import 'package:geocoding/geocoding.dart';
import 'package:make_my_ride/features/ride/data/datasource/ride_firebase_datasource.dart';
import 'package:make_my_ride/features/ride/domain/entities/ride_entity.dart';
import 'package:make_my_ride/features/ride/domain/repositories/ride_repository.dart';
import 'package:make_my_ride/shared/models/location_model.dart';

class RideRepositoryImpl implements RideRepository {
  final RideFirebaseDataSource _dataSource;

  const RideRepositoryImpl(this._dataSource);
  @override
  Future<LocationPoint> getAddressFromCoords(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final pc = placemarks.first;
        final address = '${pc.name}, ${pc.subLocality}, ${pc.locality}';
        return LocationPoint(
          latitude: lat,
          longitude: lng,
          address: address,
          name: pc.name,
        );
      }
      return LocationPoint(latitude: lat, longitude: lng);
    } catch (e) {
      return LocationPoint(latitude: lat, longitude: lng);
    }
  }

  @override
  Future<List<LocationPoint>> getNearbyDrivers(LocationPoint location) async {
    // Mock drivers for now
    return [
      LocationPoint(
        latitude: location.latitude + 0.002,
        longitude: location.longitude + 0.002,
      ),
      LocationPoint(
        latitude: location.latitude - 0.002,
        longitude: location.longitude - 0.001,
      ),
    ];
  }

  @override
  Future<List<LocationPoint>> searchAddresses(String query) async {
    if (query.isEmpty) return [];

    try {
      // Use native OS geocoding instead of Google Places API for now
      List<Location> locations = await locationFromAddress(query);
      if (locations.isEmpty) return [];

      List<LocationPoint> results = [];
      // To prevent rate limits/delay, only process top 4 results
      final topLocations = locations.take(4).toList();

      for (var loc in topLocations) {
        List<Placemark> placemarks = await placemarkFromCoordinates(loc.latitude, loc.longitude);
        if (placemarks.isNotEmpty) {
          final pc = placemarks.first;
          final List<String?> parts = [pc.name, pc.subLocality, pc.locality, pc.administrativeArea];
          final address = parts.where((p) => p != null && p.isNotEmpty).join(', ');
          
          results.add(LocationPoint(
            latitude: loc.latitude,
            longitude: loc.longitude,
            address: address,
            name: pc.name ?? query,
          ));
        } else {
          results.add(LocationPoint(
            latitude: loc.latitude,
            longitude: loc.longitude,
            name: query,
            address: 'Unknown Area',
          ));
        }
      }
      return results;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<String> requestRide({
    required String riderId,
    required LocationPoint pickup,
    required LocationPoint destination,
    required String vehicleType,
    required double fare,
  }) {
    return _dataSource.requestRide(
      riderId: riderId,
      pickup: pickup,
      destination: destination,
      vehicleType: vehicleType,
      fare: fare,
    );
  }

  @override
  Stream<RideEntity> watchRide(String rideId) {
    return _dataSource.watchRide(rideId);
  }
}
