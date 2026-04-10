import 'package:geolocator/geolocator.dart';
import 'package:make_my_ride/features/maps/domain/enitites/location_enitiy.dart';

class LocationDatasource {
  Future<LocationEntity> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location service disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition();

    return LocationEntity(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
