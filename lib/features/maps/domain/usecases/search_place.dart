import 'package:make_my_ride/features/maps/domain/enitites/place_entity.dart';
import 'package:make_my_ride/features/maps/domain/repositories/map_repository.dart';

class SearchPlace {
  final MapRepository repository;

  SearchPlace(this.repository);

  Future<List<PlaceEntity>> call(String query) {
    return repository.searchPlace(query);
  }
}
