import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:make_my_ride/core/theme/theme.dart';
import 'package:make_my_ride/features/pending_rides/presentation/providers/pending_ride_provider.dart';
import '../../providers/map_providers.dart';

class BookYourRideButton extends ConsumerWidget {
  const BookYourRideButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeRideAsync = ref.watch(activeRideProvider);
    final hasBlockingRide = ref.watch(hasBlockingRideProvider);
    final isCheckingActiveRide =
        activeRideAsync.isLoading && activeRideAsync.valueOrNull == null;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          try {
            final mapState = ref.read(mapViewModelProvider);
            final pickup = mapState.currentLocation;
            final drop = mapState.selectedPlace;

            if (hasBlockingRide) {
              ref.read(mapViewModelProvider.notifier).setSummaryMode(true);
              return;
            }

            if (activeRideAsync.hasError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'We could not verify your active ride. Please wait for sync before creating a new ride.',
                  ),
                ),
              );
              return;
            }

            if (isCheckingActiveRide) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Checking your active ride...'),
                ),
              );
              return;
            }

            if (pickup == null || drop == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select a destination'),
                ),
              );
              return;
            }

            ref.read(mapViewModelProvider.notifier).setSummaryMode(true);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $e'),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        child: Text(
          hasBlockingRide
              ? 'View Active Ride'
              : isCheckingActiveRide
                  ? 'Checking Active Ride...'
                  : 'Make Your Ride',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
