import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository _repository;

  const VerifyOtpUseCase(this._repository);

  Future<UserEntity> call({
    required String verificationId,
    required String smsCode,
  }) =>
      _repository.verifyOtp(
        verificationId: verificationId,
        smsCode: smsCode,
      );
}
