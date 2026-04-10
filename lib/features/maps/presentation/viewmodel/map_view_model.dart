import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_current_location.dart';
import '../../domain/usecases/search_place.dart';
import 'map_state.dart';

class MapViewModel extends StateNotifier<MapState> {
  final GetCurrentLocation getCurrentLocation;
  final SearchPlace searchPlace;

  MapViewModel(this.getCurrentLocation, this.searchPlace)
      : super(MapState.initial());

  Future<void> loadLocation() async {
    final location = await getCurrentLocation();
    state = state.copyWith(currentLocation: location);
  }

  Future<void> search(String query) async {
    final results = await searchPlace(query);
    state = state.copyWith(searchResults: results);
  }

  void selectPlace(place) {
    state = state.copyWith(selectedPlace: place);
  }
}
