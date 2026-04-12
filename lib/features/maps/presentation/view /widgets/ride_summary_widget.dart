import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:make_my_ride/core/theme/app_colors.dart';
import 'package:make_my_ride/features/maps/presentation/view%20/widgets/detail_row.dart';
import 'package:make_my_ride/features/ride/presentation/providers/ride_provider.dart';
import 'package:make_my_ride/features/ride/presentation/view/vehcle_selector.dart';
import 'package:make_my_ride/features/maps/presentation/providers/map_providers.dart';
import 'package:make_my_ride/features/ride/domain/usecases/calculate_distance.dart';
import 'package:make_my_ride/features/ride/domain/usecases/calculate_price.dart';
import 'package:make_my_ride/features/ride/presentation/providers/user_id_provider.dart';
import 'searching_ride_widget.dart';

class RideSummaryWidget extends ConsumerWidget {
  const RideSummaryWidget({
    super.key,
    required this.onResetBookingFlow,
  });

  final VoidCallback onResetBookingFlow;

  bool _isBlockingRideStatus(String? status) {
    return status == 'pending' || status == 'accepted';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideState = ref.watch(rideViewModelProvider);
    final mapState = ref.watch(mapViewModelProvider);
    final userId = ref.watch(userIdProvider);

    final bool hasActiveRide = rideState.currentRide != null &&
        _isBlockingRideStatus(rideState.currentRide!.status);
    final currentRide = rideState.currentRide;
    final isPendingRide = currentRide?.status == 'pending';
    final isAcceptedRide = currentRide?.status == 'accepted';
    final pickup = mapState.currentLocation;
    final drop = mapState.selectedPlace;
    final selectedVehicle = rideState.selectedVehicle;

    double? estimatedPrice;
    if (!hasActiveRide &&
        pickup != null &&
        drop != null &&
        selectedVehicle != null) {
      final distance = CalculateDistance()(
        pickup.latitude,
        pickup.longitude,
        drop.lat,
        drop.lon,
      );
      estimatedPrice = CalculatePrice()(distance, selectedVehicle);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: rideState.isBooking
          ? SearchingRideWidget(
              onCancel: () async {
                await ref.read(rideViewModelProvider.notifier).cancelBooking();
                onResetBookingFlow();
              },
            )
          : SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                key: const ValueKey('SummaryContent'),
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          ref
                              .read(mapViewModelProvider.notifier)
                              .setSummaryMode(false);
                        },
                      ),
                      const Text(
                        'Ride Summary',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (isPendingRide || isAcceptedRide)
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isAcceptedRide
                            ? AppColors.successLight
                            : AppColors.warningLight,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: (isAcceptedRide
                                  ? AppColors.success
                                  : AppColors.warning)
                              .withValues(alpha: 0.35),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: (isAcceptedRide
                                          ? AppColors.success
                                          : AppColors.warning)
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  isAcceptedRide
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.schedule_rounded,
                                  color: isAcceptedRide
                                      ? AppColors.success
                                      : AppColors.warning,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isAcceptedRide
                                          ? 'Ride Accepted'
                                          : 'Ride Request Pending',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isAcceptedRide
                                          ? 'A driver has accepted your ride. You cannot create another one yet.'
                                          : 'Waiting for a driver to accept your ride.',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          DetailRow(
                            label: 'Vehicle',
                            value: currentRide!.vehicleType.name.toUpperCase(),
                          ),
                          const SizedBox(height: 10),
                          DetailRow(
                            label: 'Estimated Amount',
                            value: '₹${currentRide.price.toStringAsFixed(0)}',
                            emphasize: true,
                          ),
                          const SizedBox(height: 10),
                          DetailRow(
                            label: 'Distance',
                            value:
                                '${currentRide.distanceKm.toStringAsFixed(1)} km',
                          ),
                          const SizedBox(height: 10),
                          DetailRow(
                            label: 'Status',
                            value: currentRide.status.toUpperCase(),
                            valueColor: isAcceptedRide
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                await ref
                                    .read(rideViewModelProvider.notifier)
                                    .deleteCurrentRide();
                                onResetBookingFlow();
                              },
                              icon: const Icon(Icons.delete_outline_rounded),
                              label: const Text('Delete Ride'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: const BorderSide(
                                  color: AppColors.error,
                                  width: 1.2,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    const VehicleSelector(),
                    const SizedBox(height: 20),
                    if (estimatedPrice != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Estimated Price",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            Text(
                              "₹${estimatedPrice.toStringAsFixed(0)}",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    if (rideState.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          rideState.error!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (rideState.selectedVehicle == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a vehicle type.'),
                              ),
                            );
                            return;
                          }

                          if (pickup != null && drop != null) {
                            ref.read(rideViewModelProvider.notifier).createRide(
                                  userId: userId,
                                  pickupLat: pickup.latitude,
                                  pickupLng: pickup.longitude,
                                  dropLat: drop.lat,
                                  dropLng: drop.lon,
                                );
                          }
                        },
                        child: const Text("Book Ride"),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
