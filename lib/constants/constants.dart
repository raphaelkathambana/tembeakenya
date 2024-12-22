// import 'package:app_settings/app_settings.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_prefs_cookie_store/shared_prefs_cookie_store.dart';
import 'package:connectivity/connectivity.dart';

// String url = 'https://tembeakenyabackend.fly.dev/';
// String url =
// 'https://qsglphcp-8000.euw.devtunnels.ms/'; // dev tunnel port forwarding

String url =
    'https://tembeakenyabackend-edfybkb7c0dagjc9.southafricanorth-01.azurewebsites.net/';

// String url = 'http://192.168.43.74:8000/';
String apiVersion1Uri = '/api/v1/';

Future<String> getCsrfToken() async {
  Dio dio = Dio();
  var cookieJar = CookieJar();
  dio.interceptors.add(CookieManager(cookieJar));
  // final connectivityResult = await APICall()._connectivity.checkConnectivity();
  // if (connectivityResult == ConnectivityResult.none) {
  // AppSettings.openAppSettings(type: AppSettingsType.wifi);
  // return '';
  // }
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

class APICall {
  final Dio _dio;
  // final Connectivity _connectivity = Connectivity();

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
          // final connectivityResult = await _connectivity.checkConnectivity();
          // if (connectivityResult == ConnectivityResult.none) {
          //   AppSettings.openAppSettings(type: AppSettingsType.wifi);
          //   return handler.reject(
          //     DioException(
          //       requestOptions: options,
          //       error: 'No internet connection',
          //     ),
          //   );
          // }

          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            debugPrint('Token Added as a Bearer token');
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

/// Displays an error dialog with the given [message] in the specified [context].
/// The error message is extracted using the [getMainErrorMessage] function.
/// The dialog shows the error message without the surrounding square brackets.
/// Returns a [Future] that completes when the dialog is dismissed.
Future<dynamic>? alertErrorHandler(BuildContext context, dynamic message) {
  debugPrint("Extracting Errors");
  if (message == null) {
    return null;
  } else {
    var error = message is String ? message : getMainErrorMessage(message);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(error.toString().split('[').last.split(']').first),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Returns the main error message from a given map.
///
/// If the map contains a key named 'message', the value associated with that key is returned.
/// Otherwise, the string 'Key not found' is returned.
dynamic getMainErrorMessage(Map<String, dynamic> map) {
  if (map.containsKey('message')) {
    return map['message'];
  } else {
    return 'Key not found';
  }
}
