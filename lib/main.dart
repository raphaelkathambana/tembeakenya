import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/firebase_options.dart';
import 'package:tembeakenya/views/home_page.dart';

import 'package:tembeakenya/views/register_view.dart';
import 'package:tembeakenya/views/login_view.dart';
import 'package:tembeakenya/views/verify_view.dart';
import 'package:tembeakenya/views/welcome_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorsUtil.accentColorLight,
          primary: ColorsUtil.primaryColorLight,
          secondary: ColorsUtil.secondaryColorLight,
          background: ColorsUtil.backgroundColorLight,
        ),
        useMaterial3: true,
      ),
      home: const MainPage(),
      routes: {
        '/welcome/': (context) => const WelcomeView(),
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/verify/': (context) => const VerifyEmailView(),
        '/home': (context) => const MainPage(),
      },
    ),
  );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

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
            if(user != null){
              if (user.emailVerified == true) {
                return const HomeView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const WelcomeView();
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

