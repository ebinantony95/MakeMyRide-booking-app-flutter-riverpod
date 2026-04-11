import 'package:make_my_ride/features/ride/domain/entities/vehcle_entity.dart';

class RideEntity {
  final String id;
  final String userId;

  final double pickupLat;
  final double pickupLng;

  final double dropLat;
  final double dropLng;

  final double distanceKm;
  final VehicleType vehicleType;
  final double price;

  final String status;
  final DateTime createdAt;

  RideEntity({
    required this.id,
    required this.userId,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropLat,
    required this.dropLng,
    required this.distanceKm,
    required this.vehicleType,
    required this.price,
    required this.status,
    required this.createdAt,
  });
}
