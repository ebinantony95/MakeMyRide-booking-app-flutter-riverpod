import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:make_my_ride/features/auth/presentation/providers/auth_provider.dart';
import 'package:make_my_ride/features/pending_rides/domain/ride_status.dart';
import 'package:make_my_ride/features/ride/domain/entities/ride_entitiy.dart';
import 'package:make_my_ride/features/ride/presentation/providers/ride_provider.dart';

final activeRideUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authViewModelProvider);
  return authState.user?.uid ?? FirebaseAuth.instance.currentUser?.uid;
});

final activeRideProvider = StreamProvider<RideEntity?>((ref) {
  final userId = ref.watch(activeRideUserIdProvider);

  if (userId == null || userId.isEmpty) {
    return Stream.value(null);
  }

  return ref.watch(rideRepositoryProvider).watchActiveRide(userId);
});

final hasBlockingRideProvider = Provider<bool>((ref) {
  final activeRide = ref.watch(activeRideProvider).valueOrNull;
  return RideStatusValues.isActive(activeRide?.status);
});

final pendingRideSyncProvider = Provider<void>((ref) {
  ref.listen<AsyncValue<RideEntity?>>(
    activeRideProvider,
    (previous, next) {
      final rideViewModel = ref.read(rideViewModelProvider.notifier);

      next.when(
        data: rideViewModel.syncActiveRideState,
        error: (error, _) => rideViewModel.setActiveRideSyncError(error),
        loading: () {},
      );
    },
    fireImmediately: true,
  );
});
