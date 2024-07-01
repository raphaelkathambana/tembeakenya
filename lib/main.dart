import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/nav_bar.dart';
import 'package:tembeakenya/controllers/auth_controller.dart';
import 'package:tembeakenya/views/verify_view.dart';
import 'package:tembeakenya/views/welcome_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(
    MaterialApp.router(
      title: 'Tembea Kenya',
      themeMode: ThemeMode.system,
      darkTheme: darkThemeData,
      theme: lightThemeData,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
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
    return FutureBuilder<Map<String, dynamic>>(
      future: AuthController(NavigationService(router)).isAuthenticated(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.data?['isAuthenticated'] == true) {
            if (snapshot.data?['isVerified'] == true) {
              return LayoutView(
                user: snapshot.data?['user'],
              );
            } else {
              return VerifyEmailView(
                  user: snapshot.data?['user'],
                  id: '',
                  params: null,
                  token: '');
            }
          } else {
            return const WelcomeView();
          }
        }
      },
    );
  }
}
