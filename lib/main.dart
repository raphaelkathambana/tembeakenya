import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/firebase_options.dart';

import 'package:tembeakenya/views/register_view.dart';
import 'package:tembeakenya/views/login_view.dart';
import 'package:tembeakenya/views/verify_view.dart';
import 'package:tembeakenya/views/welcome_view.dart';


const backgroundDark = Color(0xFF171B10);
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(103, 58, 183, 1)),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/verify/': (context) => const VerifyEmailView(),
        '/welcome/': (context) => const WelcomeView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done: 
          final user = FirebaseAuth.instance.currentUser;

          if (user?.emailVerified ?? false) {
            return const WelcomeView();
          } else {
            return const VerifyEmailView();
          }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}



// class VerifyEmailView extends StatefulWidget {
//   const VerifyEmailView({super.key});

//   @override
//   State<VerifyEmailView> createState() => _VerifyEmailViewState();
// }

// class _VerifyEmailViewState extends State<VerifyEmailView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       appBar: AppBar(
//         backgroundColor: backgroundDark,
//         title: const Text('Verify Email', style: TextStyle(color: Colors.white)),
//       ),

//       body: Column(
//         children: [
//           const Text('Please verify your email address'),
//           TextButton(
//             onPressed:() async {
//               final user = FirebaseAuth.instance.currentUser;
//               await user?.sendEmailVerification();
//           },child: const Text('Send email verification'))
//         ],
//       ),
//     );
//   }
// }

