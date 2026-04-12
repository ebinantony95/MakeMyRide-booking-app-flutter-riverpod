import 'package:make_my_ride/features/auth/data/datasource/auth_firebase_datasource.dart';
import 'package:make_my_ride/features/auth/domain/entities/user_entity.dart';
import 'package:make_my_ride/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseDataSource _dataSource;

  const AuthRepositoryImpl(this._dataSource);

  @override
  Future<String> sendOtp(String phoneNumber) =>
      _dataSource.sendOtp(phoneNumber);

  @override
  Future<UserEntity> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) =>
      _dataSource.verifyOtp(
        verificationId: verificationId,
        smsCode: smsCode,
      );

  @override
  Future<UserEntity?> getCurrentUser() => _dataSource.getCurrentUser();

  @override
  Future<void> signOut() => _dataSource.signOut();

  @override
  Future<UserEntity> updateUserProfile({
    required String name,
    required String email,
  }) {
    return _dataSource.updateUserProfile(name: name, email: email);
  }

  @override
  Future<UserEntity> updateUserRole(String role) {
    return _dataSource.updateUserRole(role);
  }

  @override
  Future<UserEntity> updateDriverDetails({
    required String vehicleType,
    required String vehicleNumber,
  }) {
    return _dataSource.updateDriverDetails(
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
    );
  }
}
