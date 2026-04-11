import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:make_my_ride/features/ride/presentation/providers/ride_provider.dart';

class RideHistoryScreen extends ConsumerWidget {
  final String userId;

  const RideHistoryScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rideViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Ride History")),
      body: FutureBuilder(
        future: ref.read(rideViewModelProvider.notifier).loadHistory(userId),
        builder: (_, __) {
          if (state.history.isEmpty) {
            return const Center(child: Text("No rides yet"));
          }

          return ListView.builder(
            itemCount: state.history.length,
            itemBuilder: (_, i) {
              final ride = state.history[i];

              return Card(
                child: ListTile(
                  title: Text(
                      "${ride.vehicleType.name} - ₹${ride.price.toStringAsFixed(0)}"),
                  subtitle: Text(
                      "${ride.distanceKm.toStringAsFixed(2)} km • ${ride.status}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
