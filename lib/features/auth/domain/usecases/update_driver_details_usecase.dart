import 'package:make_my_ride/features/auth/domain/entities/user_entity.dart';
import 'package:make_my_ride/features/auth/domain/repositories/auth_repository.dart';

class UpdateDriverDetailsUseCase {
  final AuthRepository _repository;

  UpdateDriverDetailsUseCase(this._repository);

  Future<UserEntity> call({
    required String vehicleType,
    required String vehicleNumber,
  }) {
    return _repository.updateDriverDetails(
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
    );
  }
}
