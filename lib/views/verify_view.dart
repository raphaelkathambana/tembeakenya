import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


const backgroundDark = Color(0xFF171B10);
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
        backgroundColor: backgroundDark,
        title: const Text('Verify Email', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        
        
        children: [
          
          const Text('Please verify your email address'),
          TextButton(
            onPressed:() async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
              // const LoginView();
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const LoginView(),
                //   ),
                // );
            },
            child: const Text('Send email verification'),
          ),
        ],
      ),
    );
  }
}