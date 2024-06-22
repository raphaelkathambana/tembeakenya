import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/controllers/auth_controller.dart';
import '../../assets/colors.dart';
import 'package:tembeakenya/main.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _firstname;
  late final TextEditingController _lastname;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _passwordConfirm;
  late NavigationService navigationService;

  @override
  void initState() {
    _firstname = TextEditingController();
    _lastname = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _passwordConfirm = TextEditingController();
    navigationService = NavigationService(router);
    super.initState();
  }

  @override
  void dispose() {
    _firstname.dispose();
    _lastname.dispose();
    _email.dispose();
    _password.dispose();
    _passwordConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Register',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: ColorsUtil.primaryColorLight)),
      ),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.9,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // const SizedBox(
              //   height: 20,
              //   child: Center(
              //     child: Padding(
              //       padding: EdgeInsets.all(10),
              //     ),
              //   ),
              // ),
              const Image(
                image: AssetImage('lib/assets/images/mountbg.png'),
              ),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    child: Column(
                      children: [
                        TextField(
                          controller: _firstname,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            labelText: 'Enter your First name here',
                          ),
                        ),
                        TextField(
                          controller: _lastname,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            labelText: 'Enter your Last name here',
                          ),
                        ),
                        TextField(
                          controller: _email,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Enter your Email here',
                          ),
                        ),
                        TextField(
                          controller: _password,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            labelText: 'Enter your password here',
                          ),
                        ),
                        TextField(
                          controller: _passwordConfirm,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            labelText: 'Re-enter your password here',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final firstname = _firstname.text;
                              final lastname = _lastname.text;
                              final email = _email.text;
                              final password = _password.text;
                              final passwordConfirm = _passwordConfirm.text;
                              AuthController(navigationService).register(
                                  firstname,
                                  lastname,
                                  email,
                                  password,
                                  passwordConfirm,
                                  context);
                            },
                            style: const MainPage().raisedButtonStyle,
                            child: const Text('Register'),
                          ),
                          TextButton(
                              onPressed: () => context.push('/login'),
                              child: const Text(
                                  "Already have an account? Sign in here!")),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
