import 'package:make_my_ride/features/auth/domain/entities/user_entity.dart';
import 'package:make_my_ride/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<UserEntity> call({
    required String name,
    required String email,
  }) {
    return _repository.updateUserProfile(name: name, email: email);
  }
}
