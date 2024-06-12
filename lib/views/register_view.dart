import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/constants.dart';
import 'package:tembeakenya/main.dart';
import 'package:tembeakenya/views/login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _passwordConfirm;

  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _passwordConfirm = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _passwordConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Register',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: ColorsUtil.primaryColorLight)),
      ),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.9,
        child: SingleChildScrollView(
          child: Column(
            children: [
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
              ),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    child: Column(
                      children: [
                        TextField(
                          controller: _name,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: 'Enter your name here',
                          ),
                        ),
                        TextField(
                          controller: _email,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Enter your email here',
                          ),
                        ),
                        TextField(
                          controller: _password,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            hintText: 'Enter your password here',
                          ),
                        ),
                        TextField(
                          controller: _passwordConfirm,
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
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final name = _name.text;
                              final email = _email.text;
                              final password = _password.text;
                              final passwordConfirm = _passwordConfirm.text;
                              register(name, email, password, passwordConfirm,
                                  context);
                            },
                            style: const MainPage().raisedButtonStyle,
                            child: const Text('Register'),
                          ),
                          TextButton(
                              onPressed: () => context.go('/login'),
                              child: const Text(
                                  "Already have an account? Sign in here!")),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> register(String name, String email, String password,
      String passwordConfirm, BuildContext context) async {
    String token = await getCsrfToken();
    debugPrint(token);
    try {
      final response = await APICall().client.post('${url}api/v1/register',
          data: jsonEncode({
            'name': name,
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
        if (!context.mounted) return;
        context.goNamed('/verify');
      }
    } on DioException catch (e) {
      debugPrint('Error Occurred: Getting Message');
      debugPrint(e.response?.data.toString());
      if (!context.mounted) return;
      newMethod(context, e.response?.data);
    }
  }
}
