import 'package:make_my_ride/features/ride/domain/entities/ride_entitiy.dart';
import 'package:make_my_ride/features/ride/domain/entities/vehcle_entity.dart';

class RideState {
  final VehicleType? selectedVehicle;
  final RideEntity? currentRide;
  final List<RideEntity> history;
  final String? error;

  RideState({
    this.selectedVehicle,
    this.currentRide,
    this.history = const [],
    this.error,
  });

  factory RideState.initial() => RideState();

  RideState copyWith({
    VehicleType? selectedVehicle,
    RideEntity? currentRide,
    List<RideEntity>? history,
    String? error,
  }) {
    return RideState(
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      currentRide: currentRide ?? this.currentRide,
      history: history ?? this.history,
      error: error,
    );
  }
}
