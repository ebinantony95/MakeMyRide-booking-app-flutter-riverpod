import 'package:make_my_ride/features/ride/domain/entities/vehcle_entity.dart';

class CalculatePrice {
  double call(double distance, VehicleType type) {
    switch (type) {
      case VehicleType.bike:
        return 20 + (distance * 5);
      case VehicleType.auto:
        return 30 + (distance * 8);
      case VehicleType.car:
        return 50 + (distance * 12);
    }
  }
}
