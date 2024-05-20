import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/main.dart';
import 'package:tembeakenya/views/verify_view.dart';
// import 'package:tembeakenya/views/verify_view.dart';

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
        backgroundColor: ColorsUtil.backgroundColorLight,
        title: const Text('Login',
            style: TextStyle(color: ColorsUtil.textColorLight)),
      ),
      body: Column(children: [
        // 'Enter your email here'
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

        // 'Login'
        TextButton(
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;
            try {
              await FirebaseAuth.instance
                  .signInWithEmailAndPassword(email: email, password: password);

              final user = FirebaseAuth.instance.currentUser;

              if (user?.emailVerified ?? false) {
                if (!context.mounted) return;
                Navigator.of(context)
                  .pushNamedAndRemoveUntil('/home/', (route) => false);
              } else {
                if (!context.mounted) return;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const VerifyEmailView(),
                  ),
                );
              }
            } on FirebaseAuthException catch (e) {
              if (e.code == 'invalid-credential') {
                print('Invalid Credential');
              }
            }
          },
          child: const Text('Login'),
        ),

        // 'Don't have an account? Sign up here!'
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/register/', (route) => false);
            },
            child: const Text('Don\'t have an account? Sign up here!'))
      ]),
    );
  }
}
