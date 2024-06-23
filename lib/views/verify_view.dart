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
              showDialog (
                context: context, 
                builder: (context) => AlertDialog(
                  title: const Text('Verification Link Sent'),
                  content: const Text('A link has been sent to your email.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();  
                        Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
                      },
                      child: const Text('OK'),
                    ),
                  ]
                )
              );
              
              
            },
            child: const Text('Send email verification'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil('/welcome/', (route) => false);
            },
            child: const Text("Logout"))
        ],
      ),
    );
  }
<<<<<<< HEAD

  Future<void> _verifyEmail(String id, String token, params) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await APICall().client.get(
            '${url}api/v1/email/verify/$id/$token',
            queryParameters: Map.of(params),
            options: Options(headers: {
              'Accept': 'application/json',
            }),
          );

      setState(() {
        _verificationMessage = 'Email successfully verified!';
      });

      // delay 1 second before continuing to home
      await Future.delayed(const Duration(seconds: 1));
      // Navigate to the home page or perform other actions
      if (!mounted) return;
      context.go('/home');
    } on DioException catch (e) {
      setState(() {
        _verificationMessage = 'Verification failed: ${e.response?.data}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoading = true;
    });

    bool isLoggedOut = await AuthController(navigationService).logout();

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;
    if (isLoggedOut) {
      context.go('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed')),
      );
    }
  }
}
=======
}
>>>>>>> 10c8c62aad0b82f3a87987baf65a8bbff6e12382
