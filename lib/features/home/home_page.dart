import 'package:flutter/material.dart';
import 'package:make_my_ride/features/maps/presentation/view%20/map_screen.dart';
import 'package:make_my_ride/features/pending_rides/presentation/widgets/pending_ride_bootstrap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PendingRideBootstrap(
      child: MapScreen(),
    );
  }
}
