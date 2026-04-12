import 'package:make_my_ride/features/ride/domain/entities/ride_entitiy.dart';
import 'package:make_my_ride/features/ride/domain/entities/vehcle_entity.dart';

class RideState {
  final VehicleType? selectedVehicle;
  final RideEntity? currentRide;
  final List<RideEntity> history;
  final String? error;
  final bool isBooking;
  final bool isDeletingRide;

  RideState({
    this.selectedVehicle,
    this.currentRide,
    this.history = const [],
    this.error,
    this.isBooking = false,
    this.isDeletingRide = false,
  });

  factory RideState.initial() => RideState();

  RideState copyWith({
    VehicleType? selectedVehicle,
    RideEntity? currentRide,
    bool clearCurrentRide = false,
    List<RideEntity>? history,
    String? error,
    bool? isBooking,
    bool? isDeletingRide,
  }) {
    return RideState(
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      currentRide: clearCurrentRide ? null : (currentRide ?? this.currentRide),
      history: history ?? this.history,
      error: error,
      isBooking: isBooking ?? this.isBooking,
      isDeletingRide: isDeletingRide ?? this.isDeletingRide,
    );
  }
}
