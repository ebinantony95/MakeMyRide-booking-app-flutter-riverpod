import 'package:make_my_ride/features/ride/domain/repositories/ride_repository.dart';
import 'package:make_my_ride/shared/models/location_model.dart';

class RequestRideUseCase {
  final RideRepository _repository;

  RequestRideUseCase(this._repository);

  Future<String> call({
    required String riderId,
    required LocationPoint pickup,
    required LocationPoint destination,
    required String vehicleType,
    required double fare,
  }) {
    return _repository.requestRide(
      riderId: riderId,
      pickup: pickup,
      destination: destination,
      vehicleType: vehicleType,
      fare: fare,
    );
  }
}
