import 'package:flutter/material.dart';
import '../../assets/colors.dart';

class TestView extends StatelessWidget {
  const TestView({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: ColorsUtil.secondaryColorLight,
      foregroundColor: ColorsUtil.textColorLight,
      minimumSize: const Size(279, 59),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/images/mountbackground.png'),
                fit: BoxFit.fitWidth)),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                ),
              ),
            ),
            Column(
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
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login/', (route) => false);
                            },
                            style: raisedButtonStyle,
                            child: const Text('Login')),
                        const SizedBox(
                          height: 19,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/register/', (route) => false);
                            },
                            style: raisedButtonStyle,
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
