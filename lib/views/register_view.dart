// import 'package:cloud_firestore/cloud_firestore.dart';
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
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _passwordConfirm;
  late NavigationService navigationService;

  bool hidePassword = true;
  bool isCheched = false;

  @override
  void initState() {
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _passwordConfirm = TextEditingController();
    navigationService = NavigationService(router);
    super.initState();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
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
              const SizedBox(
                height: 20,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                  ),
                ),
              ),
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
                          controller: _firstName,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            labelText: 'Enter your First name here',
                          ),
                        ),
                        TextField(
                          controller: _lastName,
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
                          obscureText: hidePassword,
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
                        Row(
                          children: [
                            Checkbox(
                                value: isCheched,
                                onChanged: (value) {
                                  setState(() {
                                    isCheched = value!;
                                    hidePassword = !hidePassword;
                                  });
                                }),
                            const Text('Show Password'),
                          ],
                        )
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
                              final firstName = _firstName.text;
                              final lastName = _lastName.text;
                              final email = _email.text;
                              final password = _password.text;
                              final passwordConfirm = _passwordConfirm.text;
                              AuthController(navigationService).register(
                                  firstName,
                                  lastName,
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
                            // // *********** FOR AUTHENTICATION *********** //
                            //     await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                            // // ************* FOR FIRESTORE ************** //
                            //     await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).set({
                            //       "fname": _fname.text,
                            //       "lname": _lname.text,
                            //       "username": _username.text,
                            //       "email": _email.text
                            //     });