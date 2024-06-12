import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/constants.dart';
import 'package:tembeakenya/views/login_view.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: ColorsUtil.primaryColorLight)),
      ),
      body: Column(children: [
        const Text(
          'A Reset Link will be shared to your Email.',
        ),
        // 'Enter your email here'
        Center(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: Column(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
          ),
        ),

        // 'Submit'
        TextButton(
          onPressed: () async {
            final email = _email.text;
            sendForgotPasswordLink(email, context);
            try {
              await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'invalid-email') {
                if (!context.mounted) return;
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                            title: const Text('Invalid Email'),
                            content:
                                const Text('Please write your email properly'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ]));
              } else if (e.code == 'invalid-credential') {
                if (!context.mounted) return;
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                            title: const Text('Email does not exist.'),
                            content: const Text('Please try again.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ]));
              }
            }
          },
          child: const Text('Submit'),
        ),
      ]),
    );
  }

  Future<void> sendForgotPasswordLink(String email, context) async {
    String token = await getCsrfToken();
    debugPrint(token);
    try {
      final response =
          await APICall().client.post('${url}api/v1/forgot-password',
              data: jsonEncode({
                'email': email,
              }),
              options: Options(headers: {
                'X-XSRF-TOKEN': token,
                'Accept': 'application/json',
              }));
      debugPrint(response.data.toString());
    } on DioException catch (e) {
      debugPrint('Error Occurred: Getting Message');
      debugPrint(e.response?.data.toString());
      newMethod(context, e.response?.data);
    }
  }
}
