import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_prefs_cookie_store/shared_prefs_cookie_store.dart';

String url = 'http://10.0.223.245:8000/'; // Use your local IP address

Future<String> getCsrfToken() async {
  Dio dio = Dio();
  var cookieJar = CookieJar();
  dio.interceptors.add(CookieManager(cookieJar));

  Response response = await dio.get(
    url,
    options: Options(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  );
// Set timeout duration

  if (response.statusCode == 200) {
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
        onRequest: (options, handler) {
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

Future<void> getClient() async {
  APICall apiCall = APICall();
  //Send a dummy request to your domain to prime DioCookieManager
  await apiCall.client.get(url);

  //Request which actually sets the cookies to the DioCookieManager
  await apiCall.client.get('${url}sanctum/csrf-cookie');
  var token = await getCsrfToken();
  await apiCall.client.post('${url}api/about',
      options: Options(
          headers: {'Accept': 'application/json', 'X-XSRF-TOKEN': token}));
}
