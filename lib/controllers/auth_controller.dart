import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tembeakenya/constants/constants.dart';
import 'package:tembeakenya/constants/routes.dart';

/// The controller class responsible for handling authentication logic.
class AuthController {
  final APICall apiCall = APICall();
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  NavigationService navigationService = NavigationService(router);

  AuthController(this.navigationService);

  /// Logs in the user with the provided [email] and [password].
  ///
  /// This method authenticates the user with the given credentials and
  /// performs the necessary actions based on the authentication result.
  /// The [context] parameter is used to access the current build context.
  ///
  /// Throws an exception if the authentication fails.
  Future<void> login(
      String email, String password, BuildContext context) async {
    final deviceName = await _getDeviceName();
    String token = await getCsrfToken();
    debugPrint(token);
    try {
      final response = await apiCall.client.post('${url}api/v1/login',
          data: jsonEncode({
            'email': email,
            'password': password,
            'device_name': deviceName,
          }),
          options: Options(headers: {
            'X-XSRF-TOKEN': token,
            'Accept': 'application/json',
          }));
      // debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        final token = response.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        if (!context.mounted) return;
        isVerified(await apiCall.client.get('${url}api/user'), context);
        if (!context.mounted) return;
        // context.goNamed('/home');
        navigationService.navigateToHome(context);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 302) {
        debugPrint(
            "User Might be Logged in, Attempting to get User information");
        final user = await apiCall.client.get('${url}api/user');
        if (!context.mounted) return;
        if (user.statusCode == 200) {
          navigationService
              .navigateToHome(context); // context.goNamed('/home');
        }
      } else {
        if (!context.mounted) return;
        debugPrint('Error Occurred: Getting Message');
        debugPrint(e.response?.data.toString());
        alertErrorHandler(context, e.response?.data);
      }
    }
  }

  /// Registers a new user with the provided information.
  ///
  /// The [firstname], [lastname], [email], [password], and [passwordConfirm] parameters
  /// are used to create a new user account. The [context] parameter is used for navigation.
  ///
  /// This method sends a POST request to the server's registration endpoint with the user's
  /// information. If the registration is successful (status code 201), it retrieves the user's
  /// data and assigns a new token to the user. The token is then saved in the device's shared preferences.
  /// Finally, it navigates to the '/email-verify' route.
  ///
  /// If any error occurs during the registration process, such as a validation error or a network error,
  /// it handles the error and displays an appropriate message.
  ///
  /// Throws a [DioException] if there is an error with the HTTP request.
  Future<void> register(String firstname, String lastname, String email,
      String password, String passwordConfirm, BuildContext context) async {
    String token = await getCsrfToken();
    debugPrint(token);
    try {
      final response = await apiCall.client.post('${url}api/v1/register',
          data: jsonEncode({
            'firstname': firstname,
            'lastname': lastname,
            'email': email,
            'password': password,
            'password_confirmation': passwordConfirm
          }),
          options: Options(headers: {
            'X-XSRF-TOKEN': token,
            'Accept': 'application/json',
          }));
      debugPrint(response.data.toString());
      if (response.statusCode == 201) {
        debugPrint('User Registered Successfully');
        debugPrint('Attempting to get User Data');
        final userResponse = await apiCall.client.get('${url}api/user');
        if (userResponse.statusCode == 200) {
          debugPrint('User Data Retrieved Successfully');
          final user = userResponse.data;
          debugPrint(user.toString());
          debugPrint('attempting to assign a new user a token');
          final deviceName = await _getDeviceName();
          String token = await getCsrfToken();
          debugPrint(token);
          final tokenResponse = await apiCall.client.post('${url}api/get-token',
              data: jsonEncode({
                'device_name': deviceName,
              }),
              options: Options(headers: {
                'X-XSRF-TOKEN': token,
                'Accept': 'application/json',
              }));
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('auth_token', tokenResponse.data['token']);
          debugPrint('Auth Token Saved');
          if (!context.mounted) return;
          // context.goNamed('/email-verify');
          navigationService.navigateToEmailVerify(context);
        } else {
          debugPrint('Failed to get User Data');
          debugPrint(userResponse.data.toString());
          if (!context.mounted) return;
          alertErrorHandler(context, userResponse.data);
        }
        if (!context.mounted) return;
        // context.goNamed('/email-verify');
        navigationService.navigateToEmailVerify(context);
      }
    } on DioException catch (e) {
      debugPrint('Error Occurred: Getting Message');
      debugPrint(e.response?.data.toString());
      if (!context.mounted) return;
      alertErrorHandler(context, e.response?.data);
    }
  }

  /// Sends a verification notification via email.
  ///
  /// This method sends a verification notification via email by making an API call.
  /// It retrieves a CSRF token using the [getCsrfToken] method and includes it in the request headers.
  /// The response data is printed to the debug console.
  /// If an error occurs, the error message is printed to the debug console and the [alertErrorHandler] is called with the error response data.
  ///
  /// Parameters:
  /// - [context]: The [BuildContext] of the current widget.
  ///
  /// Returns: A [Future] that completes when the verification notification is sent.
  Future<void> sendVerification(BuildContext context) async {
    String token = await getCsrfToken();
    debugPrint(token);
    try {
      final response = await apiCall.client.post(
        '${url}api/v1/email/verification-notification',
        options: Options(headers: {
          'X-XSRF-TOKEN': token,
          'Accept': 'application/json',
        }),
      );
      debugPrint(response.data.toString());
    } on DioException catch (e) {
      if (!context.mounted) return;
      debugPrint('Error Occurred: Getting Message');
      debugPrint(e.response?.data.toString());
      alertErrorHandler(context, e.response?.data);
    }
  }

  /// Displays an error dialog with the given [message] in the specified [context].
  /// The error message is extracted using the [getMainErrorMessage] function.
  /// The dialog shows the error message without the surrounding square brackets.
  /// Returns a [Future] that completes when the dialog is dismissed.
  Future<dynamic> alertErrorHandler(BuildContext context, dynamic message) {
    debugPrint("Extracting Errors");
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

  Future<void> isVerified(Response response, BuildContext context) async {
    //check if the response has an email verified field and if it has a value
    if (response.data['email_verified_at'] == null) {
      //if the email_verified_at field is null, then the user has not verified their email
      //navigate to the verify page
      if (!context.mounted) return;
      navigationService.navigateToEmailVerify(context);
    }
  }

  /// Retrieves the name of the device.
  ///
  /// This method uses the `DeviceInfoPlugin` plugin to get the device information.
  /// It checks if the platform is Android or iOS and retrieves the corresponding device name.
  /// If the platform is neither Android nor iOS, it returns "Unknown Device".
  ///
  /// Returns the name of the device as a [String].
  Future<String> _getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = '${androidInfo.manufacturer} ${androidInfo.model}';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.name;
    } else {
      deviceName = 'Unknown Device';
    }

    return deviceName;
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

  /// Sends a forgot password link to the specified email address.
  ///
  /// This method sends a POST request to the server with the email address
  /// to request a forgot password link. It uses the CSRF token obtained
  /// from the [getCsrfToken] method to authenticate the request.
  ///
  /// If the request is successful (status code 200), it displays an alert dialog
  /// with a success message. Otherwise, it handles any DioException that occurs
  /// and displays an error message using the [alertErrorHandler] method.
  ///
  /// Parameters:
  /// - [email]: The email address to send the forgot password link to.
  /// - [context]: The context of the current widget.
  ///
  /// Returns: A [Future] that completes when the request is finished.
  Future<void> sendForgotPasswordLink(String email, context) async {
    String token = await getCsrfToken();
    debugPrint(token);
    try {
      final response = await apiCall.client.post('${url}api/v1/forgot-password',
          data: jsonEncode({
            'email': email,
          }),
          options: Options(headers: {
            'X-XSRF-TOKEN': token,
            'Accept': 'application/json',
          }));
      debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text('Reset Link Sent!'),
                  content: Text('A reset link has been sent to your email.'),
                ));
      }
    } on DioException catch (e) {
      debugPrint('Error Occurred: Getting Message');
      debugPrint(e.response?.data.toString());
      alertErrorHandler(context, e.response?.data);
    }
  }

  /// Logs out the user by removing the authentication token and clearing cookies.
  /// Returns `true` if the logout is successful, otherwise `false`.
  /// Throws a [DioException] if there is an error during the logout process.
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        final response = await apiCall.client.post('${url}api/v1/logout');
        if (response.statusCode == 200) {
          await prefs.remove('auth_token');
          debugPrint('token has been removed');
          apiCall.clearCookies();
          return true;
        } else {
          debugPrint(
              'token was not removed, and logout was not successful. Check Catch');
          return false;
        }
      } else {
        return false;
      }
    } on DioException catch (e) {
      debugPrint('Some error: Either a redirect or token error occurred');
      debugPrint(
          "We might have a server error... let's see if the token is still there");
      //may have gotten a 302 error meaning the logout redirected
      //to the login page, so we can still consider it a success
      if (e.response?.statusCode == 302) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
        debugPrint('token has been removed');
        apiCall.clearCookies();
        return true;
      } else if (e.response?.statusCode == 500) {
        debugPrint('Server error');
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
        apiCall.clearCookies();
        return true;
      } else {
        return false;
      }
    }
  }

  /// Checks if the user is authenticated and returns a map with the authentication status and verification status.
  /// Returns a map with the following keys:
  /// - 'isAuthenticated': A boolean indicating if the user is authenticated.
  /// - 'isVerified': A boolean indicating if the user's email is verified.
  Future<Map<String, dynamic>> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      final response = await apiCall.client.get('${url}api/user');
      final userData = json.decode(response.data);
      if (response.statusCode == 200) {
        return {
          'isAuthenticated': true,
          'isVerified': userData['email_verified_at'] != null,
        };
      } else {
        return {
          'isVerified': userData['email_verified_at'] != null,
          'isAuthenticated': false,
        };
      }
    } else {
      final response = await apiCall.client.get('${url}api/user');
      final userData = json.decode(response.data);
      return {
        'isVerified': userData['email_verified_at'] != null,
        'isAuthenticated': false,
      };
    }
  }

  /// Resets the password for a user.
  ///
  /// Takes in the [email], [password], [passwordConfirm], [passwordToken], and [context] as parameters.
  /// Sends a POST request to the reset password API endpoint with the provided data.
  /// If the request is successful (status code 200), shows a success message using a SnackBar and navigates to the login screen.
  /// If the request fails, shows an error message using a SnackBar.
  Future<void> resetPassword(Map<String, String> email, String password,
      String passwordConfirm, passwordToken, BuildContext context) async {
    String token = await getCsrfToken();
    try {
      final response = await apiCall.client.post(
        '${url}api/v1/reset-password',
        data: jsonEncode({
          'email': email['email'],
          'password': password,
          'password_confirmation': passwordConfirm,
          'token': passwordToken
        }),
        options: Options(headers: {
          'X-XSRF-TOKEN': token,
          'Accept': 'application/json',
        }),
      );
      if (response.statusCode == 200) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset successfully'),
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
        if (!context.mounted) return;
        // context.go('/login');
        navigationService.navigateToLogin(context);
      }
    } on DioException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.response?.data}'),
        ),
      );
    }
  }
}
