import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/main.dart';
// import 'package:tembeakenya/views/verify_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/images/mountbackground.png'),
                fit: BoxFit.fitWidth)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            verticalDirection: VerticalDirection.down,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
=======
      body: Column(
        children: [
          const SizedBox(
            height: 100,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(10),
              ),
            ),
>>>>>>> 10c8c62aad0b82f3a87987baf65a8bbff6e12382
          ),
          const Image(
            image: AssetImage('lib/assets/images/mountbackground.png'),
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
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/login/'),
                          style: const MainPage().raisedButtonStyle,
                          child: const Text('Login')),
                      const SizedBox(
                        height: 19,
                      ),
                      ElevatedButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/register/'),
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
    );
  }
}