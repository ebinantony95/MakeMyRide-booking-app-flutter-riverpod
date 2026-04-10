import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:make_my_ride/features/maps/data/models/place_model.dart';

class SearchDatasource {
  Future<List<PlaceModel>> searchPlace(String query) async {
    final url =
        "https://nominatim.openstreetmap.org/search?q=$query&format=json";

    final response = await http
        .get(Uri.parse(url), headers: {'User-Agent': 'book-my-ride-app'});

    final data = jsonDecode(response.body);

    return (data as List).map((e) => PlaceModel.fromJson(e)).toList();
  }
}
