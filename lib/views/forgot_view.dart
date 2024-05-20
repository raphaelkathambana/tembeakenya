import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';

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
        backgroundColor: ColorsUtil.backgroundColorLight,
        title: const Text('Reset Password',
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

        // 'Submit'
        TextButton(
          onPressed: () async {
            final email = _email.text;

            try {
              await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

            } on FirebaseAuthException catch (e) {
              if (e.code == 'invalid-email') {
                if (!context.mounted) return;
                showDialog (
                  context: context, 
                  builder: (context) => AlertDialog(
                    title: const Text('Invalid Email'),
                    content: const Text('Please write your email properly'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ]
                  )
                );
              }else if (e.code == 'invalid-credential') {
                if (!context.mounted) return;
                showDialog (
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
                    ]
                  )
                );
              }
            }
          },
          child: const Text('Submit'),
        ),

        ]
      ),
    );
  }
}
