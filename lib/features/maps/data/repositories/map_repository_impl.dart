import 'package:make_my_ride/features/maps/data/datasource/location_data_source.dart';
import 'package:make_my_ride/features/maps/data/datasource/search_data_source.dart';
import 'package:make_my_ride/features/maps/domain/enitites/location_enitiy.dart';
import 'package:make_my_ride/features/maps/domain/enitites/place_entity.dart';
import 'package:make_my_ride/features/maps/domain/repositories/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  final LocationDatasource locationDatasource;
  final SearchDatasource searchDatasource;

  MapRepositoryImpl(this.locationDatasource, this.searchDatasource);

  @override
  Future<LocationEntity> getCurrentLocation() {
    return locationDatasource.getCurrentLocation();
  }

  @override
  Future<List<PlaceEntity>> searchPlace(String query) {
    return searchDatasource.searchPlace(query);
  }
}
