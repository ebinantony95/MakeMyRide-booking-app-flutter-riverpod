import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:make_my_ride/features/maps/polylines_route/data/repositories/route_repository_impl.dart';
import 'package:make_my_ride/features/maps/polylines_route/data/services/route_service.dart';
import 'package:make_my_ride/features/maps/polylines_route/domain/repositories/route_repository.dart';
import 'package:make_my_ride/features/maps/polylines_route/domain/usecases/fetch_route.dart';

final routeServiceProvider = Provider<RouteService>(
  (ref) => RouteService(),
);

final routeRepositoryProvider = Provider<RouteRepository>(
  (ref) => RouteRepositoryImpl(ref.read(routeServiceProvider)),
);

final fetchRouteUseCaseProvider = Provider<FetchRoute>(
  (ref) => FetchRoute(ref.read(routeRepositoryProvider)),
);
