import 'dart:convert';

import 'package:app_settings/app_settings.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_prefs_cookie_store/shared_prefs_cookie_store.dart';
import 'package:connectivity/connectivity.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

String url = 'https://tembeakenyabackend.fly.dev/';
String apiVersion1Uri = '/api/v1/';
String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;

Future<String> getCsrfToken() async {
  Dio dio = Dio();
  var cookieJar = CookieJar();
  dio.interceptors.add(CookieManager(cookieJar));
  final connectivityResult = await APICall()._connectivity.checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    AppSettings.openAppSettings(type: AppSettingsType.wifi);
    return '';
  }
  Response response = await APICall().client.get('${url}sanctum/csrf-cookie');

  if (response.statusCode == 200 || response.statusCode == 204) {
    debugPrint('CSRF token retrieved successfully');
    // The CSRF token is now set in cookies, you can proceed with login
  } else {
    debugPrint('Failed to get CSRF token: ${response.statusMessage}');
    debugPrint(response.statusCode.toString());
  }
  return Uri.decodeComponent((response.headers['set-cookie']?.first
          .split('=')
          .asMap()[1]
          ?.split(';')
          .first)!)
      .toString();
}

String convertQueryParametersToString(Map<String, List<String>> queryParams) {
  return queryParams.entries.map((entry) {
    final key = Uri.encodeComponent(entry.key);
    return entry.value
        .map((value) => '$key=${Uri.encodeComponent(value)}')
        .join('&');
  }).join('&');
}

Future<void> initializeLocationAndSave() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  // Ensure all permissions are collected for Locations
  Location location = Location();
  bool? serviceEnabled;
  PermissionStatus? permissionGranted;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
  }

  // Get the current user location
  LocationData locationData = await location.getLocation();
  debugPrint(locationData.latitude!.toString());
  debugPrint(locationData.longitude!.toString());

  // Store the user location in sharedPreferences
  sharedPreferences.setDouble('latitude', locationData.latitude!);
  sharedPreferences.setDouble('longitude', locationData.longitude!);
}

class APICall {
  final Dio _dio;
  final Connectivity _connectivity = Connectivity();

  static final APICall _instance = APICall._internal();
  final SharedPrefCookieStore _cookieStore = SharedPrefCookieStore();

  factory APICall() => _instance;

  APICall._internal() : _dio = Dio() {
    init();
  }

  void init() async {
    _dio.interceptors.add(CookieManager(_cookieStore));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final connectivityResult = await _connectivity.checkConnectivity();
          if (connectivityResult == ConnectivityResult.none) {
            AppSettings.openAppSettings(type: AppSettingsType.wifi);
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'No internet connection',
              ),
            );
          }

          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null && token.isNotEmpty) {
            debugPrint('Bearer token Added: $token');
            options.headers['Authorization'] = 'Bearer $token';
          }
          debugPrint('Sending request to ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('Received response: $response');
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          debugPrint('Error has occurred: $error');
          return handler.next(error);
        },
      ),
    );
  }

  void clearCookies() {
    _cookieStore.deleteAll();
  }

  Dio get client => _dio;
}

Future<bool> checkInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return true;
  } else {
    return false;
  }
}

void showNoInternetSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('lol'),
    ),
  );
}

// Future<Map> getParsedReverseGeocoding(LatLng latLng) async {
//   var response =
//       json.decode(await getReverseGeocodingGivenLatLngUsingMapbox(latLng));
//   Map feature = response['features'][0];
//   Map revGeocode = {
//     'name': feature['text'],
//     'address': feature['place_name'].split('${feature['text']}, ')[1],
//     'place': feature['place_name'],
//     'location': latLng
//   };
//   return revGeocode;
// }

// Future getReverseGeocodingGivenLatLngUsingMapbox(LatLng latLng) async {
//   String query = '${latLng.longitude},${latLng.latitude}';
//   try {
//     final responseData = await APICall()
//         .client
//         .get('$baseUrl/$query.json?access_token=$accessToken');
//     return responseData.data;
//   } on DioException catch (e) {
//     debugPrint('Error occurred: $e');
//     return '';
//   }
// }
