import 'package:make_my_ride/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Sends an OTP to the given phone number.
  /// Returns the Firebase verificationId.
  Future<String> sendOtp(String phoneNumber);

  /// Verifies the OTP with the given verificationId and sms code.
  /// Returns the authenticated [UserEntity].
  Future<UserEntity> verifyOtp({
    required String verificationId,
    required String smsCode,
  });

  /// Returns the currently signed-in user, or null.
  Future<UserEntity?> getCurrentUser();

  /// Signs the user out.
  Future<void> signOut();

  /// Updates the user profile with name and email, and marks profile as complete.
  Future<UserEntity> updateUserProfile({
    required String name,
    required String email,
  });

  /// Updates the user role for future role-based navigation.
  Future<UserEntity> updateUserRole(String role);

  /// Updates driver-specific setup fields after selecting the driver role.
  Future<UserEntity> updateDriverDetails({
    required String vehicleType,
    required String vehicleNumber,
  });
}
