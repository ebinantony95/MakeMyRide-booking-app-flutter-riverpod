import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/enitites/place_entity.dart';
import '../../domain/usecases/get_current_location.dart';
import '../../domain/usecases/search_place.dart';
import '../../domain/enitites/location_enitiy.dart';
import 'map_state.dart';

class MapViewModel extends StateNotifier<MapState> {
  final GetCurrentLocation getCurrentLocation;
  final SearchPlace searchPlace;

  MapViewModel(this.getCurrentLocation, this.searchPlace)
      : super(MapState.initial());

  Future<void> loadLocation() async {
    try {
      final location = await getCurrentLocation();
      state = state.copyWith(currentLocation: location);
    } catch (e) {
      // Fallback location to prevent infinite loading screen if location hangs or is denied
      state = state.copyWith(
        currentLocation: LocationEntity(
          latitude: 28.6139,
          longitude: 77.2090, // New Delhi fallback
        ),
      );
    }
  }

  Future<void> search(String query) async {
    final results = await searchPlace(query);
    state = state.copyWith(searchResults: results);
  }

  void selectPlace(PlaceEntity place) {
    state = state.copyWith(selectedPlace: place);
  }

  void setSummaryMode(bool value) {
    state = state.copyWith(isSummaryMode: value);
  }

  void clearSelection() {
    state = MapState(
      currentLocation: state.currentLocation,
      searchResults: state.searchResults,
      selectedPlace: null,
      isSummaryMode: false,
    );
  }
}
