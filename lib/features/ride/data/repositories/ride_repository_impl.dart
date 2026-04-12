import 'package:make_my_ride/features/ride/data/datasource/ride_remote_datasource.dart';
import 'package:make_my_ride/features/ride/domain/entities/ride_entitiy.dart';
import 'package:make_my_ride/features/ride/domain/repositories/ride_repository.dart';

class RideRepositoryImpl implements RideRepository {
  final RideRemoteDatasource remote;

  RideRepositoryImpl(this.remote);

  @override
  Future<void> createRide(RideEntity ride) {
    return remote.createRide(ride);
  }

  @override
  Future<List<RideEntity>> getUserRides(String userId) {
    return remote.getUserRides(userId);
  }

  @override
  Future<void> updateRideStatus(String rideId, String status) {
    return remote.updateRideStatus(rideId, status);
  }

  @override
  Future<void> deleteRide(String rideId) {
    return remote.deleteRide(rideId);
  }

  @override
  Future<RideEntity?> getActiveRide(String userId) {
    return remote.getActiveRide(userId);
  }

  @override
  Stream<RideEntity?> watchActiveRide(String userId) {
    return remote.watchActiveRide(userId);
  }
}
