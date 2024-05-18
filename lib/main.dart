import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

  
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
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(color: backgroundDark);
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: backgroundDark,
        title: const Text('Register', style: TextStyle(color: Colors.white)),
      ),

      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration (
                      hintText: 'Enter your email here',
                    ),
                  ),
              
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration (
                      hintText: 'Enter your email here',
                    ),
                  ),
              
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;          
                      // final userCredential = FirebaseAuth.instance.createUserWithEmailAndPassword(
                      FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email, 
                        password: password
                      );
                    },
                    child: const Text('Register'),
                  ),
                ]
              );
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}