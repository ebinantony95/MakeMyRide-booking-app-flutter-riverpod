import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

import '../providers/map_providers.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final TextEditingController controller = TextEditingController();
  final MapController mapController = MapController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(mapViewModelProvider.notifier).loadLocation();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    mapController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (query.isNotEmpty) {
        ref.read(mapViewModelProvider.notifier).search(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapViewModelProvider);

    if (state.currentLocation == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final current = state.currentLocation!;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(current.latitude, current.longitude),
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.make_my_ride',
              ),
              CurrentLocationLayer(
                alignPositionOnUpdate: AlignOnUpdate.never,
                alignDirectionOnUpdate: AlignOnUpdate.never,
                style: const LocationMarkerStyle(
                  marker: DefaultLocationMarker(
                    child: Icon(
                      Icons.navigation,
                      color: Colors.white,
                    ),
                  ),
                  markerSize: Size(40, 40),
                  markerDirection: MarkerDirection.heading,
                ),
              ),
              MarkerLayer(
                markers: [
                  if (state.selectedPlace != null)
                    Marker(
                      point: LatLng(
                          state.selectedPlace!.lat, state.selectedPlace!.lon),
                      child: const Icon(Icons.location_pin, color: Colors.indigo, size: 40),
                    ),
                ],
              ),
            ],
          ),

          /// 🔍 Search Bar
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ]
                  ),
                  child: TextField(
                    controller: controller,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: "Search destination",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: controller.text.isNotEmpty ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          controller.clear();
                          _onSearchChanged("");
                        },
                      ) : null,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// Results
                if (state.searchResults.isNotEmpty && controller.text.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ]
                    ),
                    constraints: const BoxConstraints(maxHeight: 250),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.searchResults.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final place = state.searchResults[index];
                        return ListTile(
                          leading: const Icon(Icons.place, color: Colors.indigo),
                          title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                          onTap: () {
                            ref
                                .read(mapViewModelProvider.notifier)
                                .selectPlace(place);

                            mapController.move(
                              LatLng(place.lat, place.lon),
                              15,
                            );

                            controller.text = place.name;
                            ref.read(mapViewModelProvider.notifier).search(""); // clear results
                            FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mapController.move(
            LatLng(current.latitude, current.longitude),
            15,
          );
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
