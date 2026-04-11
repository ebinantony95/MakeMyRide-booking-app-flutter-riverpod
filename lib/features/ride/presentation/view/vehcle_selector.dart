import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:make_my_ride/features/ride/domain/entities/vehcle_entity.dart';
import 'package:make_my_ride/features/ride/presentation/providers/ride_provider.dart';

class VehicleSelector extends ConsumerWidget {
  const VehicleSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(child: _btn(ref, "Bike", VehicleType.bike)),
        const SizedBox(width: 10),
        Expanded(child: _btn(ref, "Auto", VehicleType.auto)),
        const SizedBox(width: 10),
        Expanded(child: _btn(ref, "Car", VehicleType.car)),
      ],
    );
  }

  Widget _btn(WidgetRef ref, String label, VehicleType type) {
    return ElevatedButton(
      onPressed: () {
        ref.read(rideViewModelProvider.notifier).selectVehicle(type);
      },
      child: Text(label),
    );
  }
}
