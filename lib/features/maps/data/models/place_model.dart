import 'package:make_my_ride/features/maps/domain/enitites/place_entity.dart';

class PlaceModel extends PlaceEntity {
  PlaceModel({
    required super.name,
    required super.lat,
    required super.lon,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      name: json['display_name'],
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
    );
  }
}
