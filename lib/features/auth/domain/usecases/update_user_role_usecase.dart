import 'package:make_my_ride/features/auth/domain/entities/user_entity.dart';
import 'package:make_my_ride/features/auth/domain/repositories/auth_repository.dart';

class UpdateUserRoleUseCase {
  final AuthRepository _repository;

  UpdateUserRoleUseCase(this._repository);

  Future<UserEntity> call(String role) {
    return _repository.updateUserRole(role);
  }
}
