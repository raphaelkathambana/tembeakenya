import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/main.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home Page',
            style: TextStyle(
              color: ColorsUtil.primaryColorLight,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            const Text('Welcome'),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!context.mounted) return;
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/welcome/', (route) => false);
                  },
                  style: const MainPage().raisedButtonStyle,
                  child: const Text("Logout")),
            )
          ]),
        ),
      ),
    );
  }
}
