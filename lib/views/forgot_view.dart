import 'package:flutter/material.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/controllers/auth_controller.dart';
import '../../assets/colors.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _email;
  late NavigationService navigationService;

  @override
  void initState() {
    _email = TextEditingController();
    navigationService = NavigationService(router);
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
            AuthController(navigationService)
                .sendForgotPasswordLink(email, context);
          },
          child: const Text('Submit'),
        ),
      ]),
    );
  }
}
