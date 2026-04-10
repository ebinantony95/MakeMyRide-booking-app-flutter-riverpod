import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'app_routes.dart';

class AuthGate {
  static String? redirect({
    required String currentPath,
    required AuthState authState,
    required GoRouterState state,
  }) {
    // 1. If auth state is not yet initialized -> stay on Splash
    if (!authState.isInitialized) {
      return currentPath == AppRoutes.splash ? null : AppRoutes.splash;
    }

    final isAuthenticated = authState.isAuthenticated;
    final user = authState.user;
    final isProfileComplete = user?.isProfileComplete ?? false;

    // 2. If current path is Splash
    if (currentPath == AppRoutes.splash) {
      if (!isAuthenticated) return AppRoutes.login;
      if (!isProfileComplete) return AppRoutes.completeProfile;
      return AppRoutes.home;
    }

    // 3. Protect OTP route
    if (currentPath == AppRoutes.otpVerification) {
      final phoneInQuery = state.uri.queryParameters['phone'];
      final extraOptions = state.extra;
      final hasPhone = (phoneInQuery != null && phoneInQuery.isNotEmpty) || extraOptions != null;
      if (!hasPhone) {
        return AppRoutes.login;
      }
    }

    const publicRoutes = {
      AppRoutes.login,
      AppRoutes.otpVerification,
      AppRoutes.splash,
    };
    final isPublic = publicRoutes.contains(currentPath);

    // 4. If user is authenticated AND profile complete
    if (isAuthenticated && isProfileComplete) {
      if (isPublic || currentPath == AppRoutes.completeProfile) {
        return AppRoutes.home; // prevent access to auth flow routes
      }
    }

    // 5. If authenticated BUT profile incomplete
    if (isAuthenticated && !isProfileComplete) {
      if (currentPath != AppRoutes.completeProfile) {
        return AppRoutes.completeProfile; // force redirect to profile completion
      }
    }

    // 6. If NOT authenticated and trying to access private routes
    if (!isAuthenticated && !isPublic) {
      return AppRoutes.login; // redirect to login
    }

    return null;
  }
}
