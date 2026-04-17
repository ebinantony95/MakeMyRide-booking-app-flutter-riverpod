import '../entities/route_entity.dart';

abstract class RouteRepository {
  Future<RouteEntity> getRoute({
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
  });
}
