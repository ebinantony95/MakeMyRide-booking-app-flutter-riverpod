import 'package:make_my_ride/features/maps/polylines_route/data/services/route_service.dart';
import 'package:make_my_ride/features/maps/polylines_route/domain/entities/route_entity.dart';
import 'package:make_my_ride/features/maps/polylines_route/domain/repositories/route_repository.dart';

class RouteRepositoryImpl implements RouteRepository {
  final RouteService _service;

  RouteRepositoryImpl(this._service);

  @override
  Future<RouteEntity> getRoute({
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
  }) {
    return _service.fetchRoute(
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropLat: dropLat,
      dropLng: dropLng,
    );
  }
}
