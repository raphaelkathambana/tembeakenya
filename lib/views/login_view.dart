import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/main.dart';
import 'package:tembeakenya/test_backend.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
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
    return Scaffold(
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
                    hintText: 'Enter your email here',
                  ),
                ),

                // 'Enter your password here'
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password here',
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
                    onPressed: () {
                      TestBackend().login(_email.text, _password.text);
                    },
                    style: const MainPage().raisedButtonStyle,
                    child: const Text('Login'),
                  ),
                  // Forgot Password?
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/forgotpassword/'),
                      child: const Text('Forgot password?')),
                  // 'Don't have an account? Sign up here!'
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/register/'),
                      child:
                          const Text('Don\'t have an account? Sign up here!')),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
