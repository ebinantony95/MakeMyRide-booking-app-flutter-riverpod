import 'package:make_my_ride/features/maps/domain/enitites/location_enitiy.dart';
import 'package:make_my_ride/features/maps/domain/enitites/place_entity.dart';

class MapState {
  final LocationEntity? currentLocation;
  final List<PlaceEntity> searchResults;
  final PlaceEntity? selectedPlace;
  final bool isSummaryMode;

  MapState({
    this.currentLocation,
    this.searchResults = const [],
    this.selectedPlace,
    this.isSummaryMode = false,
  });

  factory MapState.initial() => MapState();

  MapState copyWith({
    LocationEntity? currentLocation,
    List<PlaceEntity>? searchResults,
    PlaceEntity? selectedPlace,
    bool? isSummaryMode,
  }) {
    return MapState(
      currentLocation: currentLocation ?? this.currentLocation,
      searchResults: searchResults ?? this.searchResults,
      selectedPlace: selectedPlace ?? this.selectedPlace,
      isSummaryMode: isSummaryMode ?? this.isSummaryMode,
    );
  }
}
