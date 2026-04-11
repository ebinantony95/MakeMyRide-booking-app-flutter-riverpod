import 'package:make_my_ride/features/ride/domain/entities/ride_entitiy.dart';
import 'package:make_my_ride/features/ride/domain/repositories/ride_repository.dart';

class GetUserRides {
  final RideRepository repository;

  GetUserRides(this.repository);

  Future<List<RideEntity>> call(String userId) {
    return repository.getUserRides(userId);
  }
}
