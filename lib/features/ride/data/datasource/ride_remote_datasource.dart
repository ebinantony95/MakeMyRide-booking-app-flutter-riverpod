import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:make_my_ride/features/pending_rides/data/models/ride_model.dart';
import 'package:make_my_ride/features/pending_rides/domain/ride_status.dart';
import 'package:make_my_ride/features/ride/domain/entities/ride_entitiy.dart';

class RideRemoteDatasource {
  final FirebaseFirestore firestore;

  RideRemoteDatasource(this.firestore);

  Query<Map<String, dynamic>> _userRidesQuery(String userId) {
    return firestore.collection('rides').where('userId', isEqualTo: userId);
  }

  RideEntity? _extractActiveRide(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final rides = docs.map((doc) => RideModel.fromFirestore(doc).toEntity()).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    for (final ride in rides) {
      if (RideStatusValues.isActive(ride.status)) {
        return ride;
      }
    }

    return null;
  }

  Future<void> createRide(RideEntity ride) async {
    final rideModel = RideModel.fromEntity(ride);
    await firestore.collection('rides').doc(ride.id).set(
          rideModel.toFirestore(),
        );
  }

  Future<List<RideEntity>> getUserRides(String userId) async {
    final snapshot = await _userRidesQuery(userId).get();

    final rides = snapshot.docs
        .map((doc) => RideModel.fromFirestore(doc).toEntity())
        .toList();
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
    final snapshot = await _userRidesQuery(userId).get();
    return _extractActiveRide(snapshot.docs);
  }

  Stream<RideEntity?> watchActiveRide(String userId) {
    return _userRidesQuery(userId).snapshots().map(
          (snapshot) => _extractActiveRide(snapshot.docs),
        );
  }
}
