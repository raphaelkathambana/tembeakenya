import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/controllers/auth_controller.dart';
import '../../assets/colors.dart';
import 'package:tembeakenya/assets/nav_bar.dart';
// import 'package:tembeakenya/main.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class CustomBackButtonDispatcher extends RootBackButtonDispatcher {
  final GoRouter router;

  CustomBackButtonDispatcher(this.router) : super();

  @override
  Future<bool> didPopRoute() async {
    if (router.routerDelegate.currentConfiguration.fullPath == '/login') {
      router.go('/');
      return true;
    }
    return super.didPopRoute();
  }
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late NavigationService navigationService;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    navigationService = NavigationService(router);
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Login',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: ColorsUtil.primaryColorLight)),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 100,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                ),
              ),
            ),
            const Image(
              image: AssetImage('lib/assets/images/mountbg.png'),
            ), // 'Enter your email here'
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.85,
              child: Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Enter your email here',
                    ),
                  ),

                  // 'Enter your password here'
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'Enter your password here',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    ElevatedButton(
                      onPressed: () async {
                        AuthController(navigationService)
                            .login(_email.text, _password.text, context);
                      },
                      style: const MainPage().raisedButtonStyle,
                      child: const Text('Login'),
                    ),
                    // Forgot Password?
                    TextButton(
                        onPressed: () => context.push('/forgotpassword'),
                        child: const Text('Forgot password?')),
                    // 'Don't have an account? Sign up here!'
                    TextButton(
                        onPressed: () => context.push('/register'),
                        child: const Text(
                            'Don\'t have an account? Sign up here!')),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
