import '../entities/route_entity.dart';
import '../repositories/route_repository.dart';

class FetchRoute {
  final RouteRepository repository;

  FetchRoute(this.repository);

  Future<RouteEntity> call({
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
  }) {
    return repository.getRoute(
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropLat: dropLat,
      dropLng: dropLng,
    );
  }
}
