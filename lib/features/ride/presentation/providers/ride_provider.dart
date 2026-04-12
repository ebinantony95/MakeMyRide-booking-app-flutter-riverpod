import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:make_my_ride/features/ride/data/datasource/ride_remote_datasource.dart';
import 'package:make_my_ride/features/ride/data/repositories/ride_repository_impl.dart';
import 'package:make_my_ride/features/ride/domain/repositories/ride_repository.dart';
import 'package:make_my_ride/features/ride/domain/usecases/calculate_distance.dart';
import 'package:make_my_ride/features/ride/domain/usecases/calculate_price.dart';
import 'package:make_my_ride/features/ride/domain/usecases/create_ride.dart';
import 'package:make_my_ride/features/ride/domain/usecases/get_user_ride.dart';
import 'package:make_my_ride/features/ride/domain/entities/ride_entitiy.dart';
import 'package:make_my_ride/features/ride/presentation/viewmodel/ride_state.dart';
import 'package:make_my_ride/features/ride/presentation/viewmodel/ride_viewmodel.dart';

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final rideRemoteDatasourceProvider =
    Provider((ref) => RideRemoteDatasource(ref.read(firestoreProvider)));

final rideRepositoryProvider = Provider<RideRepository>((ref) {
  return RideRepositoryImpl(ref.read(rideRemoteDatasourceProvider));
});

final createRideProvider = Provider((ref) {
  return CreateRide(
    CalculateDistance(),
    CalculatePrice(),
  );
});

final getUserRidesProvider = Provider((ref) {
  return GetUserRides(ref.read(rideRepositoryProvider));
});

// Centralized history loader so the history page stays on the provider path
// instead of calling Firestore or repository code directly from the UI.
final userRideHistoryProvider =
    FutureProvider.family.autoDispose<List<RideEntity>, String>((
      ref,
      userId,
    ) async {
      final getUserRides = ref.watch(getUserRidesProvider);
      return getUserRides(userId);
    });

final rideViewModelProvider =
    StateNotifierProvider<RideViewModel, RideState>((ref) {
  return RideViewModel(
    ref.read(createRideProvider),
    ref.read(getUserRidesProvider),
    ref.read(rideRepositoryProvider),
  );
});
