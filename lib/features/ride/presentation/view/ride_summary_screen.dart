import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:make_my_ride/features/ride/presentation/providers/ride_provider.dart';
import 'package:make_my_ride/features/ride/presentation/view/vehcle_selector.dart';

class RideSummaryScreen extends ConsumerWidget {
  final double pickupLat;
  final double pickupLng;
  final double dropLat;
  final double dropLng;
  final String userId;

  const RideSummaryScreen({
    super.key,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropLat,
    required this.dropLng,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("🔥 RideSummaryScreen BUILDING");
    final state = ref.watch(rideViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Summary'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VehicleSelector(),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (state.selectedVehicle == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a vehicle type.'),
                              ),
                            );
                            return;
                          }

                          ref.read(rideViewModelProvider.notifier).createRide(
                                userId: userId,
                                pickupLat: pickupLat,
                                pickupLng: pickupLng,
                                dropLat: dropLat,
                                dropLng: dropLng,
                              );
                        },
                        child: const Text("Book Ride"),
                      ),
                    ),
                    if (state.currentRide != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          "₹${state.currentRide!.price.toStringAsFixed(0)}",
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    if (state.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          state.error!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
