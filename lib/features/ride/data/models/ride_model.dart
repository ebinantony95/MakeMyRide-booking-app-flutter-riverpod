import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:make_my_ride/features/ride/domain/entities/ride_entity.dart';
import 'package:make_my_ride/shared/models/location_model.dart';

class RideModel extends RideEntity {
  const RideModel({
    required super.id,
    required super.riderId,
    super.driverId,
    required super.pickup,
    required super.destination,
    required super.vehicleType,
    required super.fare,
    super.status,
    required super.createdAt,
    required super.otp,
    super.driverName,
    super.vehicleNumber,
  });

  factory RideModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return RideModel(
      id: doc.id,
      riderId: data['riderId'] as String? ?? '',
      driverId: data['driverId'] as String?,
      pickup: LocationPoint.fromJson(data['pickup'] as Map<String, dynamic>),
      destination: LocationPoint.fromJson(data['destination'] as Map<String, dynamic>),
      vehicleType: data['vehicleType'] as String? ?? 'Go',
      fare: (data['fare'] as num?)?.toDouble() ?? 0.0,
      status: RideStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => RideStatus.searching,
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      otp: data['otp'] as String? ?? '0000',
      driverName: data['driverName'] as String?,
      vehicleNumber: data['vehicleNumber'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'riderId': riderId,
      'driverId': driverId,
      'pickup': pickup.toJson(),
      'destination': destination.toJson(),
      'vehicleType': vehicleType,
      'fare': fare,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'otp': otp,
      'driverName': driverName,
      'vehicleNumber': vehicleNumber,
    };
  }

  factory RideModel.fromEntity(RideEntity entity) {
    return RideModel(
      id: entity.id,
      riderId: entity.riderId,
      driverId: entity.driverId,
      pickup: entity.pickup,
      destination: entity.destination,
      vehicleType: entity.vehicleType,
      fare: entity.fare,
      status: entity.status,
      createdAt: entity.createdAt,
      otp: entity.otp,
      driverName: entity.driverName,
      vehicleNumber: entity.vehicleNumber,
    );
  }
}
