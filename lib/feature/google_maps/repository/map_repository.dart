import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:famici/feature/google_maps/entities/address.dart';
import 'package:famici/utils/barrel.dart';

class MapRepository {
  final Dio _dio = Dio();
  final String _placesApi =
      'https://maps.googleapis.com/maps/api/place/textsearch/json';
  final String _geocodeApi =
      'https://maps.googleapis.com/maps/api/geocode/json';

  Future<List<Address>> findPlaces(String query) async {
    try {
      Response response = await _dio.get(
        _placesApi,
        queryParameters: {"query": query, "key": googleApiKey},
      );
      List<Address> addresses = Address.fromJsonList(response.data['results']);
      return addresses;
    } catch (err) {
      throw Exception({"message": "Unable to fetch search results."});
    }
  }

  Future<Address> findPlaceFromLatLong(LatLng position) async {
    try {
      Response response = await _dio.get(
        _geocodeApi,
        queryParameters: {
          "latlng": "${position.latitude},${position.longitude}",
          "key": googleApiKey
        },
      );
      List<Address> address = Address.fromJsonList(response.data['results']);
      if (address.isEmpty) {
        throw Exception({"message": "Location not found."});
      }
      return address.first;
    } catch (err) {
      throw Exception({"message": "Unable to parse location to an address."});
    }
  }
}
