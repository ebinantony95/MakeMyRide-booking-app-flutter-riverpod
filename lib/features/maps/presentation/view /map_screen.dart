import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:make_my_ride/core/theme/theme.dart';
import 'package:make_my_ride/features/auth/presentation/providers/auth_provider.dart';
import 'package:make_my_ride/features/ride/presentation/providers/ride_provider.dart';
import 'package:make_my_ride/features/ride/presentation/providers/user_id_provider.dart';

import '../providers/map_providers.dart';
import 'widgets/search_bottom_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final TextEditingController controller = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final MapController mapController = MapController();
  Timer? _debounce;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        setState(() {
          _isSearching = true;
        });
      }
    });

    Future.microtask(() {
      ref.read(mapViewModelProvider.notifier).loadLocation();
      final userId = ref.read(userIdProvider);
      ref.read(rideViewModelProvider.notifier).syncActiveRide(userId);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    _searchFocusNode.dispose();
    mapController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (query.isNotEmpty) {
        ref.read(mapViewModelProvider.notifier).search(query);
      }
      setState(() {});
    });
    setState(() {}); // to show the clear button interactively
  }

  void _closeSearch() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isSearching = false;
    });
  }

  void _resetBookingFlow() {
    controller.clear();
    ref.read(mapViewModelProvider.notifier).clearSelection();
    FocusScope.of(context).unfocus();
    setState(() {
      _isSearching = false;
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
          /// 1. Background Map
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(current.latitude, current.longitude),
              initialZoom: 15,
              onTap: (_, __) {
                if (_isSearching) {
                  _closeSearch();
                }
              },
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
                    color: AppColors.primary,
                    child:
                        Icon(Icons.navigation, color: Colors.white, size: 16),
                  ),
                  markerSize: Size(36, 36),
                  markerDirection: MarkerDirection.heading,
                ),
              ),
              MarkerLayer(
                markers: [
                  if (state.selectedPlace != null)
                    Marker(
                      point: LatLng(
                          state.selectedPlace!.lat, state.selectedPlace!.lon),
                      child: const Icon(Icons.location_pin,
                          color: Colors.black87, size: 40),
                    ),
                ],
              ),
            ],
          ),

          /// 2. Floating Action Buttons (Hidden when searching)
          if (!_isSearching) ...[
            Positioned(
              top: 60,
              left: 16,
              child: _buildFloatingIcon(Icons.person_outline),
            ),
            Positioned(
              top: 60,
              right: 16,
              child: GestureDetector(
                  onTap: () {
                    //logout
                    ref.read(authViewModelProvider.notifier).signOut();
                  },
                  child: _buildFloatingIcon(Icons.notifications_none)),
            ),
            Positioned(
              bottom: 270,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  mapController.move(
                    LatLng(current.latitude, current.longitude),
                    15,
                  );
                },
                child: _buildFloatingIcon(Icons.my_location,
                    iconColor: AppColors.primary),
              ),
            ),
          ],

          /// 3. Animated Bottom "Where to?" Card -> Full Screen Search
          SearchBottomSheet(
            isSearching: _isSearching,
            searchController: controller,
            searchFocusNode: _searchFocusNode,
            onSearchChanged: _onSearchChanged,
            onCloseSearch: _closeSearch,
            onResetBookingFlow: _resetBookingFlow,
            mapController: mapController,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(IconData icon, {Color iconColor = Colors.black87}) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Center(
        child: Icon(icon, color: iconColor, size: 24),
      ),
    );
  }
}
