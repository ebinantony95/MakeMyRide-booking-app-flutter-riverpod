import 'package:latlong2/latlong.dart';

/// Pure domain entity — no Flutter/Dio imports.
class RouteEntity {
  final List<LatLng> points;
  final double distanceKm;
  final double durationMin;

  const RouteEntity({
    required this.points,
    required this.distanceKm,
    required this.durationMin,
  });
}
