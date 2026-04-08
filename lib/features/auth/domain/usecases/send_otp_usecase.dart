import '../repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository _repository;

  const SendOtpUseCase(this._repository);

  /// Returns the verificationId on success.
  Future<String> call(String phoneNumber) =>
      _repository.sendOtp(phoneNumber);
}
