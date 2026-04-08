import 'package:make_my_ride/shared/models/location_model.dart';
import 'package:make_my_ride/features/ride/domain/entities/ride_entity.dart';

abstract class RideRepository {
  /// Fetch nearby available drivers based on a location.
  Future<List<LocationPoint>> getNearbyDrivers(LocationPoint location);

  /// Search for address suggestions based on a query.
  Future<List<LocationPoint>> searchAddresses(String query);

  /// Geocode a coordinate to get its address.
  Future<LocationPoint> getAddressFromCoords(double lat, double lng);

  /// Initiate a ride request.
  /// Returns the ride document ID.
  Future<String> requestRide({
    required String riderId,
    required LocationPoint pickup,
    required LocationPoint destination,
    required String vehicleType,
    required double fare,
  });

  /// Listen to real-time changes of a ride by its ID.
  Stream<RideEntity> watchRide(String rideId);
}
