import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import '../../features/auth/presentation/view/screens/splash_screen.dart';
import '../../features/auth/presentation/view/screens/login_screen.dart';
import '../../features/auth/presentation/view/screens/otp_verification_screen.dart';

export 'app_routes.dart';

// ─── Router config ────────────────────────────────────────────────────────────
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.otpVerification,
      name: 'otp',
      builder: (context, state) {
        final phone = state.uri.queryParameters['phone'] ?? '';
        return OtpVerificationScreen(phoneNumber: phone);
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const _PlaceholderScreen(title: 'Home'),
    ),
    GoRoute(
      path: AppRoutes.rideRequest,
      name: 'rideRequest',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Ride Request'),
    ),
    GoRoute(
      path: AppRoutes.waiting,
      name: 'waiting',
      builder: (context, state) => const _PlaceholderScreen(title: 'Waiting'),
    ),
    GoRoute(
      path: AppRoutes.driverAssigned,
      name: 'driverAssigned',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Driver Assigned'),
    ),
    GoRoute(
      path: AppRoutes.tracking,
      name: 'tracking',
      builder: (context, state) => const _PlaceholderScreen(title: 'Tracking'),
    ),
    GoRoute(
      path: AppRoutes.rideHistory,
      name: 'rideHistory',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Ride History'),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (context, state) => const _PlaceholderScreen(title: 'Profile'),
    ),
    GoRoute(
      path: AppRoutes.driverHome,
      name: 'driverHome',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Driver Home'),
    ),
    GoRoute(
      path: AppRoutes.driverRideDetail,
      name: 'driverRideDetail',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Driver Ride Detail'),
    ),
  ],
);

// Temporary placeholder while screens are built
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
