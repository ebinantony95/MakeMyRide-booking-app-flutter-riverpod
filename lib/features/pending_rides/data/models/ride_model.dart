import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:make_my_ride/features/ride/domain/entities/ride_entitiy.dart';
import 'package:make_my_ride/features/ride/domain/entities/vehcle_entity.dart';

class RideModel extends RideEntity {
  RideModel({
    required super.id,
    required super.userId,
    required super.pickupLat,
    required super.pickupLng,
    required super.dropLat,
    required super.dropLng,
    required super.distanceKm,
    required super.vehicleType,
    required super.price,
    required super.status,
    required super.createdAt,
  });

  factory RideModel.fromEntity(RideEntity entity) {
    return RideModel(
      id: entity.id,
      userId: entity.userId,
      pickupLat: entity.pickupLat,
      pickupLng: entity.pickupLng,
      dropLat: entity.dropLat,
      dropLng: entity.dropLng,
      distanceKm: entity.distanceKm,
      vehicleType: entity.vehicleType,
      price: entity.price,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }

  factory RideModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};

    return RideModel(
      id: (data['id'] as String?) ?? doc.id,
      userId: data['userId'] as String? ?? '',
      pickupLat: _asDouble(data['pickupLat']),
      pickupLng: _asDouble(data['pickupLng']),
      dropLat: _asDouble(data['dropLat']),
      dropLng: _asDouble(data['dropLng']),
      distanceKm: _asDouble(data['distanceKm']),
      vehicleType: _vehicleTypeFromName(data['vehicleType'] as String?),
      price: _asDouble(data['price']),
      status: data['status'] as String? ?? '',
      createdAt: _dateTimeFromFirestore(data['createdAt']),
    );
  }

  RideEntity toEntity() {
    return RideEntity(
      id: id,
      userId: userId,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropLat: dropLat,
      dropLng: dropLng,
      distanceKm: distanceKm,
      vehicleType: vehicleType,
      price: price,
      status: status,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'dropLat': dropLat,
      'dropLng': dropLng,
      'distanceKm': distanceKm,
      'vehicleType': vehicleType.name,
      'price': price,
      'status': status,
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }

  static double _asDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }

    return 0;
  }

  static VehicleType _vehicleTypeFromName(String? value) {
    return VehicleType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => VehicleType.auto,
    );
  }

  static DateTime _dateTimeFromFirestore(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value)?.toUtc() ?? DateTime.now().toUtc();
    }

    return DateTime.now().toUtc();
  }
}
