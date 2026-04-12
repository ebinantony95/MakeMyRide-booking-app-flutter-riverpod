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

    ///  1. Wait for app init
    if (!isInitialized) {
      return path == AppRoutes.splash ? null : AppRoutes.splash;
    }

    ///  2. Wait for user data after login
    if (isAuthenticated && user == null) {
      return null; //  don't redirect yet
    }

    final isProfileComplete = user?.isProfileComplete ?? false;
    final role = user?.role?.trim().toLowerCase();
    final hasSelectedRole = role?.isNotEmpty ?? false;
    final isDriver = role == 'driver';
    final isUser = role == 'user';
    final hasDriverDetails =
        (user?.driverVehicleType?.trim().isNotEmpty ?? false) &&
            (user?.driverVehicleNumber?.trim().isNotEmpty ?? false);

    ///  Public routes
    const publicRoutes = {
      AppRoutes.splash,
      AppRoutes.login,
      AppRoutes.otpVerification,
    };

    final isPublic = publicRoutes.contains(path);

    /// 3. Not logged in
    if (!isAuthenticated && path == AppRoutes.splash) {
      return AppRoutes.login;
    }

    if (!isAuthenticated && !isPublic) {
      return AppRoutes.login;
    }

    ///  4. Logged in but profile NOT complete
    if (isAuthenticated && !isProfileComplete) {
      if (path != AppRoutes.completeProfile) {
        return AppRoutes.completeProfile;
      }
      return null;
    }

    ///  5. Logged in + profile complete but role NOT selected
    if (isAuthenticated && isProfileComplete && !hasSelectedRole) {
      if (path != AppRoutes.chooseRole) {
        return AppRoutes.chooseRole;
      }
      return null;
    }

    ///  6. Driver selected but driver setup not complete
    if (isAuthenticated && isProfileComplete && isDriver && !hasDriverDetails) {
      if (path != AppRoutes.driverDetails) {
        return AppRoutes.driverDetails;
      }
      return null;
    }

    ///  7. User role → always use rider home
    if (isAuthenticated && isProfileComplete && isUser) {
      if (path == AppRoutes.login ||
          path == AppRoutes.otpVerification ||
          path == AppRoutes.splash ||
          path == AppRoutes.completeProfile ||
          path == AppRoutes.chooseRole ||
          path == AppRoutes.driverDetails ||
          path == AppRoutes.driverHome) {
        return AppRoutes.home;
      }
    }

    ///  8. Driver role + setup complete → always use driver home
    if (isAuthenticated && isProfileComplete && isDriver && hasDriverDetails) {
      if (path == AppRoutes.login ||
          path == AppRoutes.otpVerification ||
          path == AppRoutes.splash ||
          path == AppRoutes.completeProfile ||
          path == AppRoutes.chooseRole ||
          path == AppRoutes.driverDetails ||
          path == AppRoutes.home) {
        return AppRoutes.driverHome;
      }
    }

    return null; //  allow navigation
  }
}
