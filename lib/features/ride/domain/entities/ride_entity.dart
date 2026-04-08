import 'package:make_my_ride/shared/models/location_model.dart';

enum RideStatus {
  searching,
  accepted,
  arriving,
  in_progress,
  completed,
  cancelled
}

class RideEntity {
  final String id;
  final String riderId;
  final String? driverId;
  final LocationPoint pickup;
  final LocationPoint destination;
  final String vehicleType;
  final double fare;
  final RideStatus status;
  final DateTime createdAt;
  final String otp; // To start the ride
  
  // Simulated driver details
  final String? driverName;
  final String? vehicleNumber;

  const RideEntity({
    required this.id,
    required this.riderId,
    this.driverId,
    required this.pickup,
    required this.destination,
    required this.vehicleType,
    required this.fare,
    this.status = RideStatus.searching,
    required this.createdAt,
    required this.otp,
    this.driverName,
    this.vehicleNumber,
  });

  RideEntity copyWith({
    String? id,
    String? riderId,
    String? driverId,
    LocationPoint? pickup,
    LocationPoint? destination,
    String? vehicleType,
    double? fare,
    RideStatus? status,
    DateTime? createdAt,
    String? otp,
    String? driverName,
    String? vehicleNumber,
  }) {
    return RideEntity(
      id: id ?? this.id,
      riderId: riderId ?? this.riderId,
      driverId: driverId ?? this.driverId,
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      vehicleType: vehicleType ?? this.vehicleType,
      fare: fare ?? this.fare,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      otp: otp ?? this.otp,
      driverName: driverName ?? this.driverName,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
    );
  }
}
