import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorsUtil.backgroundColorDark,
        title: const Text('Home Page',
            style: TextStyle(color: ColorsUtil.textColorDark)),
      ),
      body: Column(children: [
        const Text('Welcome'),
       
        TextButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if (!context.mounted) return;
            Navigator.of(context)
              .pushNamedAndRemoveUntil('/welcome/', (route) => false);
          },
          child: const Text("Logout"))
        ]
      ),
    );
  }
}
