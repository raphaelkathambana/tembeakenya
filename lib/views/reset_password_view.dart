import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/controllers/auth_controller.dart';

class ResetPassword extends StatefulWidget {
  final Map<String, String> email;
  final String token;
  const ResetPassword({super.key, required this.email, required this.token});
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late final TextEditingController _newPassword;
  late final TextEditingController _newPasswordConfirm;

  @override
  void initState() {
    _newPassword = TextEditingController();
    _newPasswordConfirm = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _newPassword.dispose();
    _newPasswordConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Reset Password',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: ColorsUtil.primaryColorLight)),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            'Reset Password',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Email: ${widget.email}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _newPassword,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _newPasswordConfirm,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              final password = _newPassword.text;
              final passwordConfirm = _newPasswordConfirm.text;
              if (password != passwordConfirm) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Passwords do not match'),
                  ),
                );
                return;
              }
              resetPassword(widget.email, password, passwordConfirm,
                  widget.token, context);
            },
            child: const Text('Reset Password'),
          )
        ]),
      ),
    );
  }
}
