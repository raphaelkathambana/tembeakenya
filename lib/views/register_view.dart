import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/main.dart';
import 'package:tembeakenya/views/verify_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: ColorsUtil.primaryColorLight)),
      ),
      body: SingleChildScrollView(
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
                                    .createUserWithEmailAndPassword(
                                        email: email, password: password);
                                if (!context.mounted) return;
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/verify/', (route) => false);
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'email-already-in-use') {
                                  if (!context.mounted) return;
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'Email already in use'),
                                              content: const Text(
                                                  'Please enter a new email address.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('OK'),
                                                ),
                                              ]));
                                } else if (e.code == 'weak-password') {
                                  if (!context.mounted) return;
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                              title:
                                                  const Text('Weak Password'),
                                              content: const Text(
                                                  'Please enter a stronger password.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ]));
                                } else if (e.code == 'invalid-email') {
                                  if (!context.mounted) return;
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                              title:
                                                  const Text('Invalid Email'),
                                              content: const Text(
                                                  'Please please write your email properly'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('OK'),
                                                ),
                                              ]));
                                } else {
                                  if (!context.mounted) return;
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const VerifyEmailView(),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          style: const MainPage().raisedButtonStyle,
                          child: const Text('Register'),
                        ),
                        TextButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/login/'),
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
    );
  }
}
