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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorsUtil.accentColorLight,
          primary: ColorsUtil.primaryColorLight,
          secondary: ColorsUtil.secondaryColorLight,
          background: ColorsUtil.backgroundColorLight,
        ),
        useMaterial3: true,
      ),
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
            if(user != null){
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