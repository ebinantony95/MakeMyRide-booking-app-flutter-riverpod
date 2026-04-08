import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:make_my_ride/core/constants/app_constants.dart';
import 'package:make_my_ride/core/theme/app_colors.dart';
import 'package:make_my_ride/core/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:make_my_ride/features/auth/presentation/providers/auth_provider.dart';
import 'package:make_my_ride/features/ride/domain/entities/ride_entity.dart';
import 'package:make_my_ride/features/ride/presentation/providers/home_provider.dart';
import 'package:make_my_ride/features/ride/presentation/viewmodel/home_viewmodel.dart';
import 'package:make_my_ride/features/ride/presentation/view/widgets/home/confirm_ride_sheet.dart';
import 'package:make_my_ride/features/ride/presentation/view/widgets/home/driver_assigned_sheet.dart';
import 'package:make_my_ride/features/ride/presentation/view/widgets/home/searching_for_driver_sheet.dart';
import 'package:make_my_ride/shared/models/location_model.dart';
import 'package:make_my_ride/shared/widgets/app_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          // ─── Map Layer ──────────────────────────────────────────────────────
          if (state.currentPosition != null)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  state.currentPosition!.latitude,
                  state.currentPosition!.longitude,
                ),
                zoom: AppConstants.defaultZoom,
              ),
              onMapCreated: viewModel.setMapController,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              padding: const EdgeInsets.only(bottom: 240),
            )
          else if (state.errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_off_rounded, size: 64, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(
                      'Location Error',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                         ref.read(homeViewModelProvider.notifier).clearError();
                         // We could also re-trigger location init here
                      },
                      child: const Text('Retry'),
                    )
                  ],
                ),
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),

          // ─── Header: Profile & Status ──────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _HeaderButton(
                  icon: Icons.person_outline_rounded,
                  onTap: () {
                    // TODO: Navigate to profile
                  },
                ),
                _HeaderButton(
                  icon: Icons.notifications_none_rounded,
                  onTap: () {
                    // TODO: Show notifications
                  },
                ),
              ],
            ),
          ),

          // ─── Floating Buttons: Recenter ───────────────────────────────────────
          Positioned(
            bottom: 250,
            right: 16,
            child: FloatingActionButton(
              onPressed: viewModel.recenter,
              backgroundColor: Colors.white,
              mini: true,
              child: const Icon(Icons.my_location, color: AppColors.primary),
            ),
          ),

          // ─── Bottom Panel: Ride Request ────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomPanel(context, ref, state, viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(
    BuildContext context,
    WidgetRef ref,
    HomeState state,
    dynamic viewModel,
  ) {
    if (state.currentRide != null) {
      if (state.currentRide!.status == RideStatus.searching) {
        return SearchingForDriverSheet(
          onCancel: viewModel.cancelSearching,
        );
      } else {
        return DriverAssignedSheet(ride: state.currentRide!);
      }
    }

    if (state.destinationLocation != null) {
      return ConfirmRideSheet(
        pickup: state.pickupLocation!,
        destination: state.destinationLocation!,
        onConfirm: () {
          final authUser = ref.read(authViewModelProvider).user;
          if (authUser != null) {
            viewModel.confirmRide(
              riderId: authUser.uid,
              vehicleType: 'BookMyRide Go',
              fare: 145.0, // Hardcoded for simulation
            );
          }
        },
      );
    }

    return _RideRequestPanel(
      onWhereToTap: () async {
        final result = await context.push<LocationPoint>(AppRoutes.addressSearch);
        if (result != null) {
          viewModel.selectDestination(result);
        }
      },
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 24),
      ),
    );
  }
}

class _RideRequestPanel extends StatelessWidget {
  final VoidCallback onWhereToTap;

  const _RideRequestPanel({required this.onWhereToTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Where to?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onWhereToTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: AppColors.textSecondary),
                  SizedBox(width: 12),
                  Text(
                    'Search destination...',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              _QuickAction(icon: Icons.home_outlined, label: 'Home'),
              SizedBox(width: 16),
              _QuickAction(icon: Icons.work_outline, label: 'Work'),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
