import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
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
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      if (email == '' || password == '') {
                        if (!context.mounted) return;
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                        'Please fill out all the details'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('OK'),
                                      ),
                                    ]));
                      } else {
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);

                          final user = FirebaseAuth.instance.currentUser;

                          if (user?.emailVerified ?? false) {
                            if (!context.mounted) return;
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home/', (route) => false);
                          } else {
                            if (!context.mounted) return;
                            Navigator.of(context).pushNamed('/verify/');
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-email') {
                            if (!context.mounted) return;
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                        title: const Text('Invalid Email'),
                                        content: const Text(
                                            'Please write your email properly'),
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
                                        title: const Text(
                                            'Wrong Email or Password'),
                                        content:
                                            const Text('Please try again.'),
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
                      }
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
