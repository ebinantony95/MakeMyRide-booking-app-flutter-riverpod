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
}
