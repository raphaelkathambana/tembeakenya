import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tembeakenya/navigations/nav_bar.dart';
import 'package:tembeakenya/constants/constants.dart';
import 'package:tembeakenya/main.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/views/change_password.dart';
import 'package:tembeakenya/views/forgot_view.dart';
import 'package:tembeakenya/views/home_page.dart';
import 'package:tembeakenya/views/login_view.dart';
import 'package:tembeakenya/views/profile_edit_view.dart';
import 'package:tembeakenya/views/profile_view.dart';
import 'package:tembeakenya/views/register_view.dart';
import 'package:tembeakenya/views/reset_password_view.dart';
import 'package:tembeakenya/views/verify_view.dart';
import 'package:tembeakenya/views/view_test.dart';
import 'package:tembeakenya/views/welcome_view.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(child: MainPage()),
    ),
    GoRoute(
      path: '/welcome',
      pageBuilder: (context, state) => const MaterialPage(child: WelcomeView()),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => const MaterialPage(child: LoginView()),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) =>
          const MaterialPage(child: RegisterView()),
    ),
    GoRoute(
      path: '/test-view',
      pageBuilder: (context, state) => const MaterialPage(child: TestView()),
    ),
    GoRoute(
      path: '/verify',
      name: '/email-verify',
      pageBuilder: (context, state) => MaterialPage(
          child: VerifyEmailView(
              user: state.extra as User, id: '', params: null, token: '')),
    ),
    GoRoute(
      path: '/profile',
      name: '/profile',
      pageBuilder: (context, state) => MaterialPage(
          child: ProfileView(
        user: state.extra as User,
        currentUser: state.extra as User,
      )),
    ),
    GoRoute(
      path: '/edit-profile',
      name: '/edit-profile',
      pageBuilder: (context, state) => MaterialPage(
          child: ProfileEditView(
        currentUser: state.extra as User,
      )),
    ),
    GoRoute(
      path: '/change-password',
      name: '/change-password',
      pageBuilder: (context, state) => MaterialPage(
          child: ChangePasswordView(
        currentUser: state.extra as User,
      )),
    ),
    GoRoute(
      path: '${apiVersion1Uri}email/verify/:userId/:token',
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        final token = state.pathParameters['token']!;
        final queryParams = state.uri.queryParameters;
        return VerifyEmailView(
          user: null,
          id: userId,
          token: token,
          params: queryParams,
        );
      },
    ),
    GoRoute(
      path: '${apiVersion1Uri}reset-password/:token',
      name: '/reset-password',
      builder: (context, state) {
        final token = state.pathParameters['token']!;
        final queryParams = state.uri.queryParameters;
        return ResetPassword(
          token: token,
          email: queryParams,
        );
      },
    ),
    GoRoute(
      path: '/forgotpassword',
      pageBuilder: (context, state) =>
          const MaterialPage(child: ForgotPasswordView()),
    ),
    GoRoute(
      path: '/navbar',
      name: '/navbar',
      pageBuilder: (context, state) => MaterialPage(
          child: LayoutView(
        user: state.extra as User,
      )),
    ),
    GoRoute(
        name: '/home',
        path: '/home',
        builder: (context, state) => HomeView(
              user: state.extra as User,
            )),
    GoRoute(
      path: '/verify-email-success',
      builder: (context, state) => HomeView(
        user: state.extra as User,
      ),
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    final Uri uri = state.uri;
    if (uri.toString().contains('${url}verify-email-success')) {
      return '/verify-email-success';
    }
    if (uri.toString().contains('${url}api/v1/email') ||
        uri.toString().contains('api/v1/email')) {
      debugPrint('attempting to extract id and token');
      final userId = uri.pathSegments[4];
      final token = uri.pathSegments[5];
      debugPrint('id: $userId');
      final queryString =
          convertQueryParametersToString(uri.queryParametersAll);
      final finalToken = '$token?$queryString';
      debugPrint(finalToken);
      debugPrint('final link: url/email/verify/$userId/$finalToken');
      return '${apiVersion1Uri}email/verify/$userId/$token?$queryString';
    }
    if (uri.toString().contains('${url}api/v1/reset-password')) {
      debugPrint('attempting to extract email and token');
      final token = uri.pathSegments[3];
      final queryString =
          convertQueryParametersToString(uri.queryParametersAll);
      final finalToken = '$token?$queryString';
      debugPrint(finalToken);
      debugPrint('final link: url/reset-password/$finalToken');
      return '${apiVersion1Uri}reset-password/$finalToken?';
    }
    return null;
  },
);

class NavigationService {
  final GoRouter _router;

  NavigationService(this._router);

  void navigateToHome(BuildContext context, User user) {
    _router.go('/home', extra: user);
  }

  void navigateToProfile(BuildContext context, User user) {
    _router.go('/profile', extra: user);
  }

  void navigateToEmailVerify(BuildContext context, User user) {
    _router.goNamed('/email-verify', extra: user);
  }

  void navigateToLogin(BuildContext context) {
    _router.go('/login');
  }

  void navigateToRegister(BuildContext context) {
    _router.go('/register');
  }

  void navigateToForgotPassword(BuildContext context) {
    _router.go('/forgotpassword');
  }

  void navigateToResetPassword(
      BuildContext context, String token, String email) {
    _router.go('/reset-password/$token?email=$email');
  }

  void navigateToEditProfile(BuildContext context, User? user) {
    _router.go('/edit-profile', extra: user);
  }

  navigatePushToEditProfile(BuildContext context, User? user) {
    _router.push('/edit-profile', extra: user);
  }

  navigatePushToChangePassword(BuildContext context, User? user) {
    _router.push('/change-password', extra: user);
  }

  void navigateToNavbar(BuildContext context, User user) {
    _router.go('/navbar', extra: user);
  }
}
