import 'package:flutter/material.dart';
import 'package:make_my_ride/core/theme/app_colors.dart';
import 'package:make_my_ride/core/theme/app_text_styles.dart';
import 'package:make_my_ride/shared/models/location_model.dart';
import 'package:make_my_ride/shared/widgets/app_button.dart';

class ConfirmRideSheet extends StatelessWidget {
  final LocationPoint pickup;
  final LocationPoint destination;
  final VoidCallback onConfirm;

  const ConfirmRideSheet({
    super.key,
    required this.pickup,
    required this.destination,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── Header
          Text('Confirm Ride', style: AppTextStyles.heading),
          const SizedBox(height: 24),

          // ─── Route Summary
          _RouteSummary(pickup: pickup, destination: destination),
          const SizedBox(height: 24),

          // ─── Vehicle Selection
          const Row(
            children: [
              _VehicleOption(
                type: 'BookMyRide Go',
                fare: '₹145',
                isSelected: true,
                icon: Icons.directions_car_rounded,
              ),
              SizedBox(width: 12),
              _VehicleOption(
                type: 'Go XL',
                fare: '₹220',
                isSelected: false,
                icon: Icons.airport_shuttle_rounded,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // ─── Confirm Button
          AppButton.primary(
            label: 'Confirm Booking',
            onPressed: onConfirm,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _RouteSummary extends StatelessWidget {
  final LocationPoint pickup;
  final LocationPoint destination;

  const _RouteSummary({required this.pickup, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Column(
            children: [
              const Icon(Icons.my_location, color: AppColors.primary, size: 18),
              Container(width: 2, height: 20, color: AppColors.border),
              const Icon(Icons.place_rounded, color: AppColors.error, size: 18),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pickup.name ?? 'Pickup', style: AppTextStyles.bodyMedium, maxLines: 1),
                const SizedBox(height: 12),
                Text(destination.name ?? 'Destination', style: AppTextStyles.bodyMedium, maxLines: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleOption extends StatelessWidget {
  final String type;
  final String fare;
  final bool isSelected;
  final IconData icon;

  const _VehicleOption({
    required this.type,
    required this.fare,
    required this.isSelected,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary, size: 32),
            const SizedBox(height: 8),
            Text(type, style: AppTextStyles.captionBold),
            const SizedBox(height: 4),
            Text(fare, style: AppTextStyles.bodySemiBold),
          ],
        ),
      ),
    );
  }
}
