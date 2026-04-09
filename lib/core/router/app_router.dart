import 'app_routes.dart';
import '../../features/auth/presentation/viewmodel/auth_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/view/screens/splash_screen.dart';
import '../../features/auth/presentation/view/screens/login_screen.dart';
import '../../features/auth/presentation/view/screens/otp_verification_screen.dart';
import '../../features/auth/presentation/view/screens/profile_completion_screen.dart';
import '../../features/ride/presentation/view/screens/home_screen.dart';
import '../../features/ride/presentation/view/screens/address_search_screen.dart';

export 'app_routes.dart';

// ─── Auth Notifier for GoRouter refresh ───────────────────────────────────────

/// A [ChangeNotifier] that bridges Riverpod auth state into GoRouter's
/// [refreshListenable]. Whenever the auth state changes the router
/// re-evaluates its [redirect] logic automatically.
class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(this._ref) {
    // Subscribe to auth state changes
    _sub = _ref.listen<AuthState>(
      authViewModelProvider,
      (_, __) => notifyListeners(),
    );
  }

  final Ref _ref;
  late final ProviderSubscription<AuthState> _sub;

  AuthState get authState => _ref.read(authViewModelProvider);

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}

// Provider so the router can be resolved inside ProviderScope
final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = _AuthNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: authNotifier,

    // ─── Global redirect logic ─────────────────────────────────────────────
    // Single source of truth for all navigation guards.
    // Order:
    //   0. Not yet initialized → stay on splash (let it run the auth check)
    //   1. On splash, already initialized → hand off to navigateAfterSplash
    //   2. Public routes → block if already fully authenticated
    //   3. Profile completion gate
    //   4. Private routes → require authentication
    redirect: (BuildContext context, GoRouterState state) async {
      final currentPath = state.matchedLocation;
      final authState = authNotifier.authState;

      // ── (0) Auth check not yet done ──────────────────────────────────────
      // Stay on splash until SplashScreen calls checkCurrentUser() and sets
      // isInitialized = true. Without this gate, the router fires immediately
      // on startup with isAuthenticated = false and redirects to /login.
      if (!authState.isInitialized) {
        return currentPath == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final isAuthenticated = authState.isAuthenticated;
      final user = authState.user;
      final isProfileComplete = user?.isProfileComplete ?? false;

      // ── (1) Splash → immediately redirect now that auth is resolved ───────
      // navigateAfterSplash already handles this from the screen side, but
      // this guard handles any edge-case deep links into /splash post-init.
      if (currentPath == AppRoutes.splash) {
        if (!isAuthenticated) return AppRoutes.login;
        if (!isProfileComplete) return AppRoutes.completeProfile;
        return AppRoutes.home;
      }

      // ── (2) Public routes ─────────────────────────────────────────────────
      const publicRoutes = {
        AppRoutes.login,
        AppRoutes.otpVerification,
        AppRoutes.splash,
      };
      final isPublic = publicRoutes.contains(currentPath);

      if (isAuthenticated && isProfileComplete && isPublic) {
        return AppRoutes.home;
      }

      // ── (3) Profile completion gate ───────────────────────────────────────
      if (isAuthenticated && !isProfileComplete) {
        if (currentPath != AppRoutes.completeProfile) {
          return AppRoutes.completeProfile;
        }
        return null;
      }

      // ── (4) Private routes guard ──────────────────────────────────────────
      if (!isAuthenticated && !isPublic) {
        return AppRoutes.login;
      }

      return null;
    },

    // ─── Route Definitions ─────────────────────────────────────────────────
    routes: [
      // ── Auth Flow ──────────────────────────────────────────────────────
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
        path: AppRoutes.completeProfile,
        name: 'completeProfile',
        builder: (context, state) => const ProfileCompletionScreen(),
      ),

      // ── Rider Flow ─────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.addressSearch,
        name: 'addressSearch',
        builder: (context, state) => const AddressSearchScreen(),
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
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Waiting for Driver'),
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
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Live Tracking'),
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

      // ── Driver Flow ────────────────────────────────────────────────────
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

    // ─── Error page ────────────────────────────────────────────────────────
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(state.error?.message ?? '',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

// ─── Helper: navigate after splash resolves auth ──────────────────────────────

/// Called by [SplashScreen] once its animation + auth check is done.
/// Keeps all route decision logic out of the screen.
void navigateAfterSplash(BuildContext context, UserEntity? user) {
  if (!context.mounted) return;
  if (user == null) {
    context.go(AppRoutes.login);
  } else if (!user.isProfileComplete) {
    context.go(AppRoutes.completeProfile);
  } else {
    context.go(AppRoutes.home);
  }
}

// ─── Back-compat: module-level instance ───────────────────────────────────────
// Keep so that main.dart continues to compile without change.
// Prefer [appRouterProvider] for new code — it's auth-reactive.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash_static',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login_static',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.otpVerification,
      name: 'otp_static',
      builder: (context, state) {
        final phone = state.uri.queryParameters['phone'] ?? '';
        return OtpVerificationScreen(phoneNumber: phone);
      },
    ),
    GoRoute(
      path: AppRoutes.completeProfile,
      name: 'completeProfile_static',
      builder: (context, state) => const ProfileCompletionScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home_static',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.addressSearch,
      name: 'addressSearch_static',
      builder: (context, state) => const AddressSearchScreen(),
    ),
    GoRoute(
      path: AppRoutes.rideRequest,
      name: 'rideRequest_static',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Ride Request'),
    ),
    GoRoute(
      path: AppRoutes.waiting,
      name: 'waiting_static',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Waiting for Driver'),
    ),
    GoRoute(
      path: AppRoutes.driverAssigned,
      name: 'driverAssigned_static',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Driver Assigned'),
    ),
    GoRoute(
      path: AppRoutes.tracking,
      name: 'tracking_static',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Live Tracking'),
    ),
    GoRoute(
      path: AppRoutes.rideHistory,
      name: 'rideHistory_static',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Ride History'),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile_static',
      builder: (context, state) => const _PlaceholderScreen(title: 'Profile'),
    ),
    GoRoute(
      path: AppRoutes.driverHome,
      name: 'driverHome_static',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Driver Home'),
    ),
    GoRoute(
      path: AppRoutes.driverRideDetail,
      name: 'driverRideDetail_static',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Driver Ride Detail'),
    ),
  ],
);

// ─── Placeholder (used until feature screens are built) ───────────────────────
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
