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
<<<<<<< HEAD
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            const Text('Welcome'),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  icon: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.logout),
                  onPressed: _isLoading ? null : _handleLogout,
                )),
            ElevatedButton(
                onPressed: () => context.push('/test-view'),
                style: const MainPage().raisedButtonStyle,
                child: const Text('ViewTest')),
          ]),
        ),
=======
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
>>>>>>> 10c8c62aad0b82f3a87987baf65a8bbff6e12382
      ),
    );
  }
}