import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:tembeakenya/constants/constants.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/controllers/auth_controller.dart';

// Generate the mock classes
@GenerateNiceMocks([
  MockSpec<APICall>(),
  MockSpec<BuildContext>(),
  MockSpec<SharedPreferences>(),
  MockSpec<DeviceInfoPlugin>(),
  MockSpec<Dio>(),
  MockSpec<NavigationService>()
])
import 'auth_controller_test.mocks.dart';

void main() {
  late AuthController authController;
  late MockAPICall mockApiCall;
  late MockBuildContext mockContext;
  late MockSharedPreferences mockPrefs;
  late MockDeviceInfoPlugin mockDeviceInfo;
  late MockDio mockDio;
  late MockNavigationService mockNavigationService;

  setUp(() {
    mockApiCall = MockAPICall();
    mockContext = MockBuildContext();
    mockPrefs = MockSharedPreferences();
    mockDeviceInfo = MockDeviceInfoPlugin();
    mockDio = MockDio();
    mockNavigationService = MockNavigationService();
    authController = AuthController(mockNavigationService);
    when(mockApiCall.client).thenReturn(mockDio);
    SharedPreferences.setMockInitialValues({});
    when(mockContext.mounted).thenReturn(true); // Stub for the mounted property
  });

  tearDown(() {
    mockApiCall.clearCookies();
  });

  group('AuthController', () {
    test('initializes correctly', () {
      expect(authController, isNotNull);
    });

    test('failed login due to network error', () async {
      when(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Network error',
      ));

      await authController.login('test@example.com', 'password', mockContext);

      verifyNever(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .called(0);
      verifyNever(mockDio.get(any));
      verifyNever(mockPrefs.setString('auth_token', any));
    });

    test('failed registration due to network error', () async {
      when(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Network error',
      ));

      await authController.register('John', 'Doe', 'test@example.com',
          'password', 'password', mockContext);

      verifyNever(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .called(0);
      verifyNever(mockDio.get(any));
    });

    test('failed verification email sending due to network error', () async {
      when(mockDio.post(any, options: anyNamed('options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Network error',
      ));

      await authController.sendVerification(mockContext);

      verify(mockDio.post(any, options: anyNamed('options'))).called(1);
    });

    test('failed forgot password link sending due to network error', () async {
      when(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Network error',
      ));

      await authController.sendForgotPasswordLink(
          'test@example.com', mockContext);

      verify(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .called(1);
    });

    test('failed logout due to network error', () async {
      when(mockPrefs.getString('auth_token')).thenReturn('dummy_token');
      when(mockDio.post(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Network error',
      ));

      final result = await authController.logout();

      expect(result, isFalse);
      verify(mockPrefs.remove('auth_token')).called(1);
    });

    test('failed login due to incorrect credentials', () async {
      when(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Unauthorized'},
        ),
      ));

      await authController.login(
          'wrong@example.com', 'wrongpassword', mockContext);

      verify(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .called(1);
      verifyNever(mockDio.get(any));
      verifyNever(mockPrefs.setString('auth_token', any));
    });

    test('successful registration', () async {
      when(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                data: {'message': 'Registered successfully'},
                statusCode: 201,
                requestOptions: RequestOptions(path: ''),
              ));
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {'email_verified_at': null},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      await authController.register('John', 'Doe', 'test@example.com',
          'password', 'password', mockContext);

      verify(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .called(2); // Two posts: register and get-token
      verify(mockDio.get(any)).called(1);
    });

    test('failed registration due to validation errors', () async {
      when(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 422,
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Validation error'},
        ),
      ));

      await authController.register('John', 'Doe', 'test@example.com',
          'password', 'password', mockContext);

      verify(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .called(1);
      verifyNever(mockDio.get(any));
    });

    test('successful verification email sending', () async {
      when(mockDio.post(any, options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                data: {'message': 'Verification email sent'},
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      await authController.sendVerification(mockContext);

      verify(mockDio.post(any, options: anyNamed('options'))).called(1);
    });

    test('failed verification email sending', () async {
      when(mockDio.post(any, options: anyNamed('options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Failed to send verification email'},
        ),
      ));

      await authController.sendVerification(mockContext);

      verify(mockDio.post(any, options: anyNamed('options'))).called(1);
    });

    test('successful forgot password link sending', () async {
      when(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                data: {'message': 'Reset link sent'},
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      await authController.sendForgotPasswordLink(
          'test@example.com', mockContext);

      verify(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .called(1);
    });

    test('failed forgot password link sending', () async {
      when(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Failed to send reset link'},
        ),
      ));

      await authController.sendForgotPasswordLink(
          'test@example.com', mockContext);

      verify(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .called(1);
    });

    test('successful logout', () async {
      when(mockPrefs.getString('auth_token')).thenReturn('dummy_token');
      when(mockDio.post(any)).thenAnswer((_) async => Response(
            data: {'message': 'Logged out'},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await authController.logout();

      expect(result, isTrue);
      verify(mockPrefs.remove('auth_token')).called(1);
      verify(mockDio.post(any)).called(1);
    });

    test('failed logout', () async {
      when(mockPrefs.getString('auth_token')).thenReturn('dummy_token');
      when(mockDio.post(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Server error'},
        ),
      ));

      final result = await authController.logout();

      expect(result, isTrue);
      verify(mockPrefs.remove('auth_token')).called(1);
    });
  });
}
