import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/constants.dart';
import 'package:tembeakenya/main.dart';

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
                      login(_email.text, _password.text, context);
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

Future<dynamic> newMethod(BuildContext context, message) {
  debugPrint("Extracting Errors");
  loopThroughMap(message);
  var error = getMainErrorMessage(message);
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
              ]));
}

Future<void> login(String email, String password, context) async {
  // await getClient();
  String token = await getCsrfToken();
  debugPrint(token);
  try {
    final response = await APICall().client.post('${url}api/v1/login',
        data: jsonEncode({
          'email': email,
          'password': password,
        }),
        options: Options(headers: {
          'X-XSRF-TOKEN': token,
          'Accept': 'application/json',
        }));
    debugPrint(response.data.toString());
    APICall apiCall = APICall();
    await apiCall.client.get('${url}api/user');
    if (response.statusCode == 200) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home/', (route) => false);
    }
  } on DioException catch (e) {
    debugPrint('Error Occurred: Getting Message');
    debugPrint(e.response?.data.toString());
    newMethod(context, e.response?.data);
  }
}

void loopThroughMap(Map<String, dynamic> map) {
  debugPrint('Looping through map');
  map.forEach((key, value) {
    debugPrint('Key: $key, Value: $value');
  });
}

dynamic getMainErrorMessage(Map<String, dynamic> map) {
  if (map.containsKey('message')) {
    return map['message'];
  } else {
    return 'Key not found';
  }
}
