import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:make_my_ride/core/services/location_service.dart';
import 'package:make_my_ride/features/ride/domain/entities/ride_entity.dart';
import 'package:make_my_ride/features/ride/domain/usecases/get_address_from_coords_usecase.dart';
import 'package:make_my_ride/features/ride/domain/usecases/request_ride_usecase.dart';
import 'package:make_my_ride/features/ride/domain/usecases/watch_ride_usecase.dart';
import 'package:make_my_ride/shared/models/location_model.dart';
import 'dart:async';

// ─── Home State ──────────────────────────────────────────────────────────────

class HomeState {
  final bool isLoading;
  final Position? currentPosition;
  final LocationPoint? pickupLocation;
  final LocationPoint? destinationLocation;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final String? errorMessage;
  final bool isSearching; // True when picking destination
  final RideEntity? currentRide;

  const HomeState({
    this.isLoading = true,
    this.currentPosition,
    this.pickupLocation,
    this.destinationLocation,
    this.markers = const {},
    this.polylines = const {},
    this.errorMessage,
    this.isSearching = false,
    this.currentRide,
  });

  HomeState copyWith({
    bool? isLoading,
    Position? currentPosition,
    LocationPoint? pickupLocation,
    LocationPoint? destinationLocation,
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    String? errorMessage,
    bool? isSearching,
    RideEntity? currentRide,
    bool clearError = false,
    bool clearRide = false,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      currentPosition: currentPosition ?? this.currentPosition,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSearching: isSearching ?? this.isSearching,
      currentRide: clearRide ? null : (currentRide ?? this.currentRide),
    );
  }
}

// ─── Home ViewModel ──────────────────────────────────────────────────────────

class HomeViewModel extends StateNotifier<HomeState> {
  final LocationService _locationService;
  final GetAddressFromCoordsUseCase _getAddressFromCoordsUseCase;
  final RequestRideUseCase _requestRideUseCase;
  final WatchRideUseCase _watchRideUseCase;

  GoogleMapController? _mapController;
  StreamSubscription<RideEntity>? _rideSubscription;

  HomeViewModel({
    required LocationService locationService,
    required GetAddressFromCoordsUseCase getAddressFromCoordsUseCase,
    required RequestRideUseCase requestRideUseCase,
    required WatchRideUseCase watchRideUseCase,
  })  : _locationService = locationService,
        _getAddressFromCoordsUseCase = getAddressFromCoordsUseCase,
        _requestRideUseCase = requestRideUseCase,
        _watchRideUseCase = watchRideUseCase,
        super(const HomeState()) {
    _init();
  }

  @override
  void dispose() {
    _rideSubscription?.cancel();
    super.dispose();
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _init() async {
    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        // Reverse geocode current position
        final locationPoint = await _getAddressFromCoordsUseCase(
          position.latitude,
          position.longitude,
        );

        state = state.copyWith(
          currentPosition: position,
          isLoading: false,
          pickupLocation: locationPoint.copyWith(name: 'Current Location'),
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Could not get current location.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Location error: ${e.toString()}',
      );
    }
  }

  Future<void> recenter() async {
    if (_mapController == null || state.currentPosition == null) return;

    await _mapController!.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
            state.currentPosition!.latitude, state.currentPosition!.longitude),
      ),
    );
  }

  void updatePickup(LocationPoint location) {
    state = state.copyWith(pickupLocation: location);
  }

  void selectDestination(LocationPoint destination) {
    state = state.copyWith(
      destinationLocation: destination,
      isSearching: false,
    );
    _fitRoute();
  }

  Future<void> _fitRoute() async {
    if (_mapController == null ||
        state.pickupLocation == null ||
        state.destinationLocation == null) {
      return;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(
        state.pickupLocation!.latitude < state.destinationLocation!.latitude
            ? state.pickupLocation!.latitude
            : state.destinationLocation!.latitude,
        state.pickupLocation!.longitude < state.destinationLocation!.longitude
            ? state.pickupLocation!.longitude
            : state.destinationLocation!.longitude,
      ),
      northeast: LatLng(
        state.pickupLocation!.latitude > state.destinationLocation!.latitude
            ? state.pickupLocation!.latitude
            : state.destinationLocation!.latitude,
        state.pickupLocation!.longitude > state.destinationLocation!.longitude
            ? state.pickupLocation!.longitude
            : state.destinationLocation!.longitude,
      ),
    );

    await _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100),
    );
  }

  void startSearching() {
    state = state.copyWith(isSearching: true);
  }

  void cancelSearching() {
    state = state.copyWith(
      isSearching: false,
      destinationLocation: null,
      clearRide: true,
    );
    _rideSubscription?.cancel();
  }

  /// Initiates a ride request to Firebase
  Future<void> confirmRide({
    required String riderId,
    required String vehicleType,
    required double fare,
  }) async {
    if (state.pickupLocation == null || state.destinationLocation == null) return;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final rideId = await _requestRideUseCase(
        riderId: riderId,
        pickup: state.pickupLocation!,
        destination: state.destinationLocation!,
        vehicleType: vehicleType,
        fare: fare,
      );

      // Subscribe to real-time driver match updates
      _listenToRide(rideId);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to request ride: $e',
      );
    }
  }

  void _listenToRide(String rideId) {
    _rideSubscription?.cancel();
    _rideSubscription = _watchRideUseCase(rideId).listen(
      (ride) {
        state = state.copyWith(
          currentRide: ride,
          isLoading: false,
        );
      },
      onError: (e) {
        state = state.copyWith(
          errorMessage: 'Lost connection to ride updates: $e',
          isLoading: false,
        );
      },
    );
  }

  void clearError() => state = state.copyWith(clearError: true);
}
