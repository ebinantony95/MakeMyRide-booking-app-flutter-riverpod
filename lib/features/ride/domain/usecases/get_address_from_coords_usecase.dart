import 'package:make_my_ride/shared/models/location_model.dart';
import '../repositories/ride_repository.dart';

class GetAddressFromCoordsUseCase {
  final RideRepository _repository;

  GetAddressFromCoordsUseCase(this._repository);

  Future<LocationPoint> call(double lat, double lng) {
    return _repository.getAddressFromCoords(lat, lng);
  }
}
