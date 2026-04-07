abstract final class AppConstants {
  // App info
  static const String appName = 'BookMyRide';
  static const String appVersion = '1.0.0';

  // Firestore collections
  static const String usersCollection = 'users';
  static const String ridesCollection = 'rides';
  static const String driversCollection = 'drivers';
  static const String locationsCollection = 'locations';

  // Storage paths
  static const String profileImagePath = 'profile_images';
  static const String vehicleImagePath = 'vehicle_images';

  // Maps
  static const double defaultLatitude = 10.8505;
  static const double defaultLongitude = 76.2711;
  static const double defaultZoom = 16.0;
  static const double searchZoom = 14.0;

  // Ride
  static const int otpTimerSeconds = 60;
  static const double rideSearchRadiusKm = 5.0;
  static const double baseFarePerKm = 12.0;

  // UI
  static const int animationDurationMs = 300;
  static const int shimmerDurationMs = 1200;
  static const double bottomSheetMinChildSize = 0.35;
  static const double bottomSheetMaxChildSize = 0.85;

  // Shared Prefs keys
  static const String prefKeyOnboarded = 'onboarded';
  static const String prefKeyUserId = 'user_id';
  static const String prefKeyUserRole = 'user_role';
}
