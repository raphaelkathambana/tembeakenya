import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';

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
          const Text('Please verify your email address'),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();

              if (!context.mounted) return;
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                          title: const Text('Verification Link Sent'),
                          content:
                              const Text('A link has been sent to your email.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/login/', (route) => false);
                              },
                              child: const Text('OK'),
                            ),
                          ]));
            },
            child: const Text('Send email verification'),
          ),
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/welcome/', (route) => false);
              },
              child: const Text("Logout"))
        ],
      ),
    );
  }
}
