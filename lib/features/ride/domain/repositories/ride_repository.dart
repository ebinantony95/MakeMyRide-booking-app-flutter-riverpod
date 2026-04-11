import 'package:make_my_ride/features/ride/domain/entities/ride_entitiy.dart';

abstract class RideRepository {
  Future<void> createRide(RideEntity ride);
  Future<List<RideEntity>> getUserRides(String userId);
}
