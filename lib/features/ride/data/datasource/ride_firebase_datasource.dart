import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:make_my_ride/features/ride/data/models/ride_model.dart';
import 'package:make_my_ride/features/ride/domain/entities/ride_entity.dart';
import 'package:make_my_ride/shared/models/location_model.dart';

class RideFirebaseDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> requestRide({
    required String riderId,
    required LocationPoint pickup,
    required LocationPoint destination,
    required String vehicleType,
    required double fare,
  }) async {
    final docRef = _firestore.collection('rides').doc();
    
    // Generate a random 4 digit OTP 
    final otp = (1000 + Random().nextInt(9000)).toString();

    final newRide = RideModel(
      id: docRef.id,
      riderId: riderId,
      pickup: pickup,
      destination: destination,
      vehicleType: vehicleType,
      fare: fare,
      createdAt: DateTime.now(),
      otp: otp,
    );

    await docRef.set(newRide.toFirestore());

    // ─── LOCAL SIMULATION HOOK ───
    // Since we don't have a Driver App running right now, we simulate a driver
    // accepting the ride after 4 seconds. 
    Future.delayed(const Duration(seconds: 4), () async {
      final snap = await docRef.get();
      if (snap.exists && snap.data()?['status'] == RideStatus.searching.name) {
        await docRef.update({
          'status': RideStatus.accepted.name,
          'driverId': 'mock_driver_123',
          'driverName': 'Arun Kumar',
          'vehicleNumber': 'KL-07-CM-4321',
        });
      }
    });

    return docRef.id;
  }

  Stream<RideModel> watchRide(String rideId) {
    return _firestore.collection('rides').doc(rideId).snapshots().map((snap) {
      if (!snap.exists) throw Exception('Ride not found');
      return RideModel.fromFirestore(snap);
    });
  }
}
