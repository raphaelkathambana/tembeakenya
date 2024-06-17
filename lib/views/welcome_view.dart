import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../assets/colors.dart';
import 'package:tembeakenya/main.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/images/mountbackground.png'),
                fit: BoxFit.fitWidth)),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Tembea Kenya',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: ColorsUtil.primaryColorLight)),
                const Text(
                  'Where Every Step is a\nJourney',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: ColorsUtil.accentColorLight),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: () => context.push('/login'),
                            style: const MainPage().raisedButtonStyle,
                            child: const Text('Login')),
                        const SizedBox(
                          height: 19,
                        ),
                        ElevatedButton(
                            onPressed: () => context.push('/register'),
                            style: const MainPage().raisedButtonStyle,
                            child: const Text('Register')),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
