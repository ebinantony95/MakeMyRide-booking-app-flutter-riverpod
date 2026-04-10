import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:make_my_ride/features/maps/data/datasource/location_data_source.dart';
import 'package:make_my_ride/features/maps/data/datasource/search_data_source.dart';
import 'package:make_my_ride/features/maps/data/repositories/map_repository_impl.dart';
import 'package:make_my_ride/features/maps/domain/repositories/map_repository.dart';
import 'package:make_my_ride/features/maps/domain/usecases/get_current_location.dart';
import 'package:make_my_ride/features/maps/domain/usecases/search_place.dart';
import 'package:make_my_ride/features/maps/presentation/viewmodel/map_state.dart';
import 'package:make_my_ride/features/maps/presentation/viewmodel/map_view_model.dart';

final locationDatasourceProvider = Provider((ref) => LocationDatasource());
final searchDatasourceProvider = Provider((ref) => SearchDatasource());

final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepositoryImpl(
    ref.read(locationDatasourceProvider),
    ref.read(searchDatasourceProvider),
  );
});

final mapViewModelProvider =
    StateNotifierProvider<MapViewModel, MapState>((ref) {
  return MapViewModel(
    GetCurrentLocation(ref.read(mapRepositoryProvider)),
    SearchPlace(ref.read(mapRepositoryProvider)),
  );
});
