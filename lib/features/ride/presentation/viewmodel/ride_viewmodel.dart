import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:make_my_ride/features/ride/domain/entities/vehcle_entity.dart';
import 'package:make_my_ride/features/ride/domain/usecases/create_ride.dart';
import 'package:make_my_ride/features/ride/domain/usecases/get_user_ride.dart';

import '../../domain/repositories/ride_repository.dart';
import 'ride_state.dart';

class RideViewModel extends StateNotifier<RideState> {
  final CreateRide createRideUseCase;
  final GetUserRides getUserRidesUseCase;
  final RideRepository repository;

  RideViewModel(
    this.createRideUseCase,
    this.getUserRidesUseCase,
    this.repository,
  ) : super(RideState.initial());

  void selectVehicle(VehicleType type) {
    state = state.copyWith(selectedVehicle: type);
  }

  Future<void> createRide({
    required String userId,
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
  }) async {
    try {
      final ride = createRideUseCase(
        userId: userId,
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        dropLat: dropLat,
        dropLng: dropLng,
        vehicle: state.selectedVehicle!,
      );

      await repository.createRide(ride);

      state = state.copyWith(currentRide: ride, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> loadHistory(String userId) async {
    final rides = await getUserRidesUseCase(userId);
    state = state.copyWith(history: rides);
  }
}
