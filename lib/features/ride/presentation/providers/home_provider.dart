import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:make_my_ride/core/services/location_service.dart';
import 'package:make_my_ride/features/ride/data/datasource/ride_firebase_datasource.dart';
import 'package:make_my_ride/features/ride/data/repositories/ride_repository_impl.dart';
import 'package:make_my_ride/features/ride/domain/repositories/ride_repository.dart';
import 'package:make_my_ride/features/ride/domain/usecases/get_address_from_coords_usecase.dart';
import 'package:make_my_ride/features/ride/domain/usecases/request_ride_usecase.dart';
import 'package:make_my_ride/features/ride/domain/usecases/search_address_usecase.dart';
import 'package:make_my_ride/features/ride/domain/usecases/watch_ride_usecase.dart';
import 'package:make_my_ride/features/ride/presentation/viewmodel/home_viewmodel.dart';

// ─── Service Providers ────────────────────────────────────────────────────────

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

// ─── Data Layer Providers ─────────────────────────────────────────────────────

final rideDataSourceProvider = Provider<RideFirebaseDataSource>((ref) {
  return RideFirebaseDataSource();
});

final rideRepositoryProvider = Provider<RideRepository>((ref) {
  return RideRepositoryImpl(ref.watch(rideDataSourceProvider));
});

// ─── Use Case Providers ───────────────────────────────────────────────────────

final searchAddressUseCaseProvider = Provider<SearchAddressUseCase>((ref) {
  return SearchAddressUseCase(ref.watch(rideRepositoryProvider));
});

final getAddressFromCoordsUseCaseProvider =
    Provider<GetAddressFromCoordsUseCase>((ref) {
  return GetAddressFromCoordsUseCase(ref.watch(rideRepositoryProvider));
});

final requestRideUseCaseProvider = Provider<RequestRideUseCase>((ref) {
  return RequestRideUseCase(ref.watch(rideRepositoryProvider));
});

final watchRideUseCaseProvider = Provider<WatchRideUseCase>((ref) {
  return WatchRideUseCase(ref.watch(rideRepositoryProvider));
});

// ─── View Model Providers ─────────────────────────────────────────────────────

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  final locationService = ref.watch(locationServiceProvider);
  final getAddressUseCase = ref.watch(getAddressFromCoordsUseCaseProvider);
  final requestRideUseCase = ref.watch(requestRideUseCaseProvider);
  final watchRideUseCase = ref.watch(watchRideUseCaseProvider);

  return HomeViewModel(
    locationService: locationService,
    getAddressFromCoordsUseCase: getAddressUseCase,
    requestRideUseCase: requestRideUseCase,
    watchRideUseCase: watchRideUseCase,
  );
});
