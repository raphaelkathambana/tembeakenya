import 'package:flutter/material.dart';

  
const backgroundDark = Color(0xFF171B10);
void main() {
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // return Container(color: backgroundDark);
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: backgroundDark,
        title: const Text('Login', style: TextStyle(color: Colors.white)),
      ),

      body: Center(
        child: TextButton(
          onPressed: () {},
          child: const Text('Login'),
        ),
      ),

    );
  }
}