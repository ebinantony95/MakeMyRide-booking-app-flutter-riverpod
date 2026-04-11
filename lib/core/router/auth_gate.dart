import 'package:go_router/go_router.dart';
import 'package:make_my_ride/core/router/app_routes.dart';
import 'package:make_my_ride/features/auth/presentation/viewmodel/auth_viewmodel.dart';

class AuthGate {
  static String? redirect({
    required AuthState authState,
    required GoRouterState state,
  }) {
    final path = state.uri.path;

    final isInitialized = authState.isInitialized;
    final isAuthenticated = authState.isAuthenticated;
    final user = authState.user;

    /// 🟡 1. Wait for app init
    if (!isInitialized) {
      return path == AppRoutes.splash ? null : AppRoutes.splash;
    }

    /// 🟡 2. Wait for user data after login
    if (isAuthenticated && user == null) {
      return null; // ⛔ don't redirect yet
    }

    final isProfileComplete = user?.isProfileComplete ?? false;

    /// 🌐 Public routes
    const publicRoutes = {
      AppRoutes.splash,
      AppRoutes.login,
      AppRoutes.otpVerification,
    };

    final isPublic = publicRoutes.contains(path);

    /// 🔐 3. Not logged in
    if (!isAuthenticated && !isPublic) {
      return AppRoutes.login;
    }

    /// 🧾 4. Logged in but profile NOT complete
    if (isAuthenticated && !isProfileComplete) {
      if (path != AppRoutes.completeProfile) {
        return AppRoutes.completeProfile;
      }
      return null;
    }

    /// 🚫 5. Logged in + profile complete → block auth screens
    if (isAuthenticated && isProfileComplete) {
      if (path == AppRoutes.login ||
          path == AppRoutes.otpVerification ||
          path == AppRoutes.splash ||
          path == AppRoutes.completeProfile) {
        return AppRoutes.home;
      }
    }

    return null; // ✅ allow navigation
  }
}
