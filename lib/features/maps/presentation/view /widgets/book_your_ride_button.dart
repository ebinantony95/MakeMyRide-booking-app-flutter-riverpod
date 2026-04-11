import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:make_my_ride/core/router/app_routes.dart';
import 'package:make_my_ride/core/theme/theme.dart';
import 'package:make_my_ride/features/ride/presentation/providers/user_id_provider.dart';
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
            final userId = ref.read(userIdProvider);

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

            GoRouter.of(context).push(
              AppRoutes.rideSummary,
              extra: {
                'pickupLat': pickup.latitude,
                'pickupLng': pickup.longitude,
                'dropLat': drop.lat,
                'dropLng': drop.lon,
                'userId': userId,
              },
            );
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
