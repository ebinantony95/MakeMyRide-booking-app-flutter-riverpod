import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:make_my_ride/features/ride/domain/entities/ride_entitiy.dart';
import 'package:make_my_ride/features/ride/domain/entities/vehcle_entity.dart';

class RideRemoteDatasource {
  final FirebaseFirestore firestore;

  RideRemoteDatasource(this.firestore);

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

    return snapshot.docs.map((doc) {
      final d = doc.data();
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
    }).toList();
  }
}
