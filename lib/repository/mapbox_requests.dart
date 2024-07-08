import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tembeakenya/constants/constants.dart';
import 'package:tembeakenya/main.dart';

// String getValidatedQueryFromQuery(String query) {
//   String validatedQuery = query.trim();
//   return validatedQuery;
// }

Future<List> getParsedResponseForQuery(String value) async {
  List parsedResponses = [];

  // If empty query send blank response
  String query = value.trim();
  if (query == '') return parsedResponses;

  // Else search and then send response
  var response = json.decode(await getSearchResultsFromQueryUsingMapbox(query));

  List features = response['features'];
  for (var feature in features) {
    Map response = {
      'name': feature['text'],
      'address': feature['place_name'].split('${feature['text']}, ')[1],
      'place': feature['place_name'],
      'location': LatLng(feature['center'][1], feature['center'][0])
    };
    parsedResponses.add(response);
  }
  return parsedResponses;
}

// ----------------------------- Mapbox Reverse Geocoding -----------------------------
Future<Map> getParsedReverseGeocoding(LatLng latLng) async {
  var response =
      json.decode(await getReverseGeocodingGivenLatLngUsingMapbox(latLng));
  Map feature = response['features'][0];
  Map revGeocode = {
    'name': feature['text'],
    'address': feature['place_name'].split('${feature['text']}, ')[1],
    'place': feature['place_name'],
    'location': latLng
  };
  return revGeocode;
}
String navType = 'walking';
Future getCyclingRouteUsingMapbox(LatLng source, LatLng destination) async {
  String url =
      '$baseUrl/$navType/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$accessToken';
  try {
    final responseData = await APICall().client.get(url);
    return responseData.data;
  } on DioException catch (e) {
    debugPrint(e.message);
  }
}
Future getReverseGeocodingGivenLatLngUsingMapbox(LatLng latLng) async {
  String query = '${latLng.longitude},${latLng.latitude}';
  String url = '$baseUrl/$query.json?access_token=$accessToken';
  try {
    final responseData = await APICall().client.get(url,

    );
    return responseData.data;
  } on DioException catch (e) {
    debugPrint(e.message);
  }
}
// ----------------------------- Mapbox Directions API -----------------------------
Future<Map> getDirectionsAPIResponse(
    LatLng sourceLatLng, LatLng destinationLatLng) async {
  final response =
      await getCyclingRouteUsingMapbox(sourceLatLng, destinationLatLng);
  Map geometry = response['routes'][0]['geometry'];
  num duration = response['routes'][0]['duration'];
  num distance = response['routes'][0]['distance'];

  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance
  };
  return modifiedResponse;
}

LatLng getCenterCoordinatesForPolyline(Map geometry) {
  List coordinates = geometry['coordinates'];
  int pos = (coordinates.length / 2).round();
  return LatLng(coordinates[pos][1], coordinates[pos][0]);
}

String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;
String searchType = 'place%2Cpostcode%2Caddress';
String searchResultsLimit = '5';
String searchCountry = 'ke';
String proximity =
    '${prefs.getDouble('longitude')}%2C${prefs.getDouble('latitude')}';
// String country = 'us';

Future getSearchResultsFromQueryUsingMapbox(String query) async {
  String url =
      '$baseUrl/$query.json?country=$searchCountry&limit=$searchResultsLimit&proximity=$proximity&types=$searchType&access_token=$accessToken';
  try {
    final responseData = await APICall().client.get(url,
        options: Options(headers: {'Content-Type': 'application/json'}));
    return responseData.data;
  } on DioException catch (e) {
    debugPrint(e.error.toString());
  }
  Future getReverseGeocodingGivenLatLngUsingMapbox(LatLng latLng) async {
    String query = '${latLng.longitude},${latLng.latitude}';
    String url = '$baseUrl/$query.json?access_token=$accessToken';
    try {
      final responseData = await APICall().client.get(url);
      return responseData.data;
    } on DioException catch (er) {
      debugPrint(er.message.toString());
    }
  }
}
