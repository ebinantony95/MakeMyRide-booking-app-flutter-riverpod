import 'package:make_my_ride/features/maps/domain/enitites/location_enitiy.dart';
import 'package:make_my_ride/features/maps/domain/enitites/place_entity.dart';

abstract class MapRepository {
  Future<LocationEntity> getCurrentLocation();
  Future<List<PlaceEntity>> searchPlace(String query);
}
