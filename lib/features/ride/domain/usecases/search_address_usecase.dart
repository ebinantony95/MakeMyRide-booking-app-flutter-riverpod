import 'package:make_my_ride/shared/models/location_model.dart';
import '../repositories/ride_repository.dart';

class SearchAddressUseCase {
  final RideRepository _repository;

  SearchAddressUseCase(this._repository);

  Future<List<LocationPoint>> call(String query) {
    return _repository.searchAddresses(query);
  }
}
