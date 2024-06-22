import 'package:flutter/material.dart';
import 'package:tembeakenya/controllers/auth_controller.dart';
import '../assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/views/home_page.dart';
import 'package:tembeakenya/views/verify_view.dart';
import 'package:tembeakenya/views/welcome_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp.router(
      title: 'Flutter Demo',
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
    return FutureBuilder<Map<String, bool>>(
      future: AuthController(NavigationService(router)).isAuthenticated(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, bool>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.data?['isAuthenticated'] == true) {
            if (snapshot.data?['isVerified'] == true) {
              return const HomeView();
            } else {
              return const VerifyEmailView(id: '', params: null, token: '');
            }
          } else {
            return const WelcomeView();
          }
        }
      },
    );
  }
}
