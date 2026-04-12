import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:make_my_ride/core/theme/theme.dart';
import '../../providers/map_providers.dart';

class BookYourRideButton extends ConsumerWidget {
  const BookYourRideButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // print("BUTTON CLICKED");
          try {
            /// ✅ Get userId cleanly

            final mapState = ref.read(mapViewModelProvider);
            final pickup = mapState.currentLocation;
            final drop = mapState.selectedPlace;
            // print("PICKUP: ${mapState.currentLocation}");
            // print("DROP: ${mapState.selectedPlace}");

            if (pickup == null || drop == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select a destination'),
                ),
              );
              return;
            }

            // print("Navigating to Ride Summary Screen...");

            ref.read(mapViewModelProvider.notifier).setSummaryMode(true);
          } catch (e) {
            //, stack) {
            // print("ERROR IN ONPRESSED: $e");
            // print("STACK: $stack");

            /// 🔐 Not logged in
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
        child: const Text(
          "Make Your Ride",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
