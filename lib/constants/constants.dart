import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_prefs_cookie_store/shared_prefs_cookie_store.dart';

String url = 'https://tembeakenyabackend.fly.dev/';
String apiVersion1Uri = '/api/v1/';

Future<String> getCsrfToken() async {
  Dio dio = Dio();
  var cookieJar = CookieJar();
  dio.interceptors.add(CookieManager(cookieJar));

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
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
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
