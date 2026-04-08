import 'package:make_my_ride/features/ride/domain/entities/ride_entity.dart';
import 'package:make_my_ride/features/ride/domain/repositories/ride_repository.dart';

class WatchRideUseCase {
  final RideRepository _repository;

  WatchRideUseCase(this._repository);

  Stream<RideEntity> call(String rideId) {
    return _repository.watchRide(rideId);
  }
}
