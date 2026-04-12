import 'package:make_my_ride/features/ride/domain/entities/ride_entitiy.dart';

abstract class RideRepository {
  Future<void> createRide(RideEntity ride);
  Future<List<RideEntity>> getUserRides(String userId);
  Future<void> updateRideStatus(String rideId, String status);
  Future<void> deleteRide(String rideId);
  Future<RideEntity?> getActiveRide(String userId);
  Stream<RideEntity?> watchActiveRide(String userId);
}
