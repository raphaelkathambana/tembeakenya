import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/constants.dart';
import 'package:tembeakenya/views/login_view.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Verify Email',
            style: TextStyle(
              color: ColorsUtil.primaryColorLight,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Column(
        children: [
          const Text(
              'A Verification Link has been Sent to your Address. Please Click it to verify your account.'),
          const Text("Didn't Receive a Verification Link?"),
          TextButton(
            onPressed: () async {
              sendVerification(context);
              // final user = FirebaseAuth.instance.currentUser;
              // await user?.sendEmailVerification();
              if (!context.mounted) return;
              showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                        title: Text('New Verification Link Sent!'),
                        content:
                            Text('A fresh link has been sent to your email.'),
                      ));
            },
            child: const Text('Click Here for a New Link.'),
          ),
          TextButton(
              onPressed: () async {
                // await FirebaseAuth.instance.signOut();
                APICall().clearCookies();
                if (!context.mounted) return;
                context.go('/welcome');
              },
              child: const Text("Logout"))
        ],
      ),
    );
  }

  Future<void> sendVerification(context) async {
    String token = await getCsrfToken();
    debugPrint(token);
    try {
      final response = await APICall()
          .client
          .post('${url}api/v1/email/verification-notification',
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
