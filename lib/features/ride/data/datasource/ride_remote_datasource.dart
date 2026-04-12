import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:make_my_ride/features/ride/domain/entities/ride_entitiy.dart';
import 'package:make_my_ride/features/ride/domain/entities/vehcle_entity.dart';

class RideRemoteDatasource {
  final FirebaseFirestore firestore;

  RideRemoteDatasource(this.firestore);

  RideEntity _mapRide(Map<String, dynamic> d) {
    return RideEntity(
      id: d['id'],
      userId: d['userId'],
      pickupLat: d['pickupLat'],
      pickupLng: d['pickupLng'],
      dropLat: d['dropLat'],
      dropLng: d['dropLng'],
      distanceKm: d['distanceKm'],
      vehicleType:
          VehicleType.values.firstWhere((e) => e.name == d['vehicleType']),
      price: d['price'],
      status: d['status'],
      createdAt: DateTime.parse(d['createdAt']),
    );
  }

  Future<void> createRide(RideEntity ride) async {
    await firestore.collection('rides').doc(ride.id).set({
      "id": ride.id,
      "userId": ride.userId,
      "pickupLat": ride.pickupLat,
      "pickupLng": ride.pickupLng,
      "dropLat": ride.dropLat,
      "dropLng": ride.dropLng,
      "distanceKm": ride.distanceKm,
      "vehicleType": ride.vehicleType.name,
      "price": ride.price,
      "status": ride.status,
      "createdAt": ride.createdAt.toIso8601String(),
    });
  }

  Future<List<RideEntity>> getUserRides(String userId) async {
    final snapshot = await firestore
        .collection('rides')
        .where('userId', isEqualTo: userId)
        .get();

    final rides = snapshot.docs.map((doc) => _mapRide(doc.data())).toList();
    rides.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return rides;
  }

  Future<void> updateRideStatus(String rideId, String status) async {
    await firestore.collection('rides').doc(rideId).update({
      'status': status,
    });
  }

  Future<void> deleteRide(String rideId) async {
    await firestore.collection('rides').doc(rideId).delete();
  }

  Future<RideEntity?> getActiveRide(String userId) async {
    final snapshot = await firestore
        .collection('rides')
        .where('userId', isEqualTo: userId)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final rides = snapshot.docs.map((doc) => _mapRide(doc.data())).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    for (final ride in rides) {
      if (ride.status == 'pending' || ride.status == 'accepted') {
        return ride;
      }
    }

    return null;
  }
}
