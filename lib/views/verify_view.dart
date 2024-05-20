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
        backgroundColor: ColorsUtil.backgroundColorLight,
        title: const Text('Verify Email',
            style: TextStyle(color: ColorsUtil.textColorLight)),
      ),
      body: Column(
        children: [
          const Text('Please verify your email address'),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();

              if (!context.mounted) return;
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login/', (route) => false);
              
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
