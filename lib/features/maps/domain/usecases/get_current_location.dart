import 'package:make_my_ride/features/maps/domain/enitites/location_enitiy.dart';
import 'package:make_my_ride/features/maps/domain/repositories/map_repository.dart';

class GetCurrentLocation {
  final MapRepository repository;

  GetCurrentLocation(this.repository);

  Future<LocationEntity> call() {
    return repository.getCurrentLocation();
  }
}
