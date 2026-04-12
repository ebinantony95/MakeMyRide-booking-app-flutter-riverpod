import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:make_my_ride/features/auth/presentation/providers/auth_provider.dart';

class DriverHome extends ConsumerWidget {
  const DriverHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
            onTap: () {
              //logout
              ref.read(authViewModelProvider.notifier).signOut();
            },
            child: Text('Driver home')),
      ),
    );
  }
}
