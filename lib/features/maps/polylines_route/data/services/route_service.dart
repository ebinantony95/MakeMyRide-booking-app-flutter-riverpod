import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:make_my_ride/features/maps/polylines_route/domain/entities/route_entity.dart';

/// Calls the OpenRouteService Directions API and parses the GeoJSON response
/// into a [RouteEntity] containing road-following [LatLng] points.
///
/// ORS coordinate order: [longitude, latitude] → flipped for Flutter's LatLng.
class RouteService {
  static const String _baseUrl =
      'https://api.openrouteservice.org/v2/directions/driving-car';

  // 🔑 Replace with your own key from https://openrouteservice.org/
  static const String _apiKey =
      '5b3ce3597851110001cf62489d03e1a3b4444c64b4f99bdeb1c39ba7';

  final Dio _dio;

  RouteService({Dio? dio}) : _dio = dio ?? Dio();

  Future<RouteEntity> fetchRoute({
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'api_key': _apiKey,
          'start': '$pickupLng,$pickupLat', // ORS expects lng,lat
          'end': '$dropLng,$dropLat',
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      // ORS sometimes returns 200 OK with a JSON error body instead of HTTP 4xx
      final raw = response.data;
      final Map<String, dynamic> data =
          raw is Map<String, dynamic> ? raw : {};

      if (data.containsKey('error')) {
        throw Exception('ORS: ${data['error']}');
      }

      final featuresList = data['features'] as List?;
      if (featuresList == null || featuresList.isEmpty) {
        throw Exception('ORS returned no route features.');
      }

      final feature = featuresList.first as Map<String, dynamic>;
      final geometry = feature['geometry'] as Map<String, dynamic>;
      final coords = geometry['coordinates'] as List;

      // ORS returns [lng, lat] pairs — convert to Flutter's LatLng(lat, lng)
      final points = coords
          .map((c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
          .toList();

      // Extract summary metrics
      final props = feature['properties'] as Map<String, dynamic>? ?? {};
      final summary = props['summary'] as Map<String, dynamic>? ?? {};

      final distanceKm =
          ((summary['distance'] as num?)?.toDouble() ?? 0) / 1000;
      final durationMin =
          ((summary['duration'] as num?)?.toDouble() ?? 0) / 60;

      return RouteEntity(
        points: points,
        distanceKm: double.parse(distanceKm.toStringAsFixed(2)),
        durationMin: double.parse(durationMin.toStringAsFixed(1)),
      );
    } on DioException catch (e) {
      throw Exception(_mapDioError(e));
    }
  }

  String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Route request timed out. Check your connection.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 403) return 'Invalid ORS API key.';
        if (statusCode == 429) return 'Route API rate limit reached.';
        return 'Route API error ($statusCode).';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Failed to fetch route.';
    }
  }
}
