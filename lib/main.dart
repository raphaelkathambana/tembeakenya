import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/firebase_options.dart';
import 'package:tembeakenya/views/forgot_view.dart';
import 'package:tembeakenya/views/home_page.dart';

import 'package:tembeakenya/views/register_view.dart';
import 'package:tembeakenya/views/login_view.dart';
import 'package:tembeakenya/views/verify_view.dart';
import 'package:tembeakenya/views/welcome_view.dart';

// final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
//   backgroundColor: ColorsUtil.secondaryColorLight,
//   foregroundColor: ColorsUtil.textColorLight,
//   minimumSize: const Size(279, 59),
//   padding: const EdgeInsets.symmetric(horizontal: 16),
//   shape: const RoundedRectangleBorder(
//     borderRadius: BorderRadius.all(Radius.circular(10)),
//   ),
// );

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: ColorsUtil.accentColorDark,
          primary: ColorsUtil.primaryColorDark,
          secondary: ColorsUtil.secondaryColorDark,
          surface: ColorsUtil.backgroundColorDark,
          background: ColorsUtil.backgroundColorDark,
          onPrimary: ColorsUtil.textColorDark,
          onSecondary: ColorsUtil.textColorDark,
          onSurface: ColorsUtil.textColorDark,
          onBackground: ColorsUtil.textColorDark,
          onError: ColorsUtil.textColorDark,
          surfaceVariant: ColorsUtil.secondaryColorLight,
        ),
        useMaterial3: true,
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: ColorsUtil.accentColorLight,
          primary: ColorsUtil.primaryColorLight,
          secondary: ColorsUtil.secondaryColorLight,
          surface: ColorsUtil.backgroundColorLight,
          background: ColorsUtil.backgroundColorLight,
          onPrimary: ColorsUtil.textColorLight,
          onSecondary: ColorsUtil.textColorLight,
          onSurface: ColorsUtil.textColorLight,
          onBackground: ColorsUtil.textColorLight,
          onError: ColorsUtil.textColorLight,
          surfaceVariant: ColorsUtil.secondaryColorLight,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
      routes: {
        '/welcome/': (context) => const WelcomeView(),
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/verify/': (context) => const VerifyEmailView(),
        '/forgotpassword/': (context) => const ForgotPasswordView(),
        '/home/': (context) => const HomeView(),
      },
      
    ),
  );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);

  ButtonStyle get raisedButtonStyle {
    var style = MainPage.themeNotifier.value == ThemeMode.light ? true : false;
    if (style) {
      return ElevatedButton.styleFrom(
        backgroundColor: ColorsUtil.secondaryColorLight,
        foregroundColor: ColorsUtil.textColorLight,
        minimumSize: const Size(279, 59),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      );
    } else {
      return ElevatedButton.styleFrom(
        backgroundColor: ColorsUtil.secondaryColorDark,
        foregroundColor: ColorsUtil.textColorDark,
        minimumSize: const Size(279, 59),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified == true) {
                return const HomeView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const WelcomeView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
