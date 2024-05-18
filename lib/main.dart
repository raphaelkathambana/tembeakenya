import 'package:flutter/material.dart';

import 'package:tembeakenya/views/register_view.dart';
import 'package:tembeakenya/views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(103, 58, 183, 1)),
        useMaterial3: true,
      ),
      home: const LoginView(),
    ),
  );
}