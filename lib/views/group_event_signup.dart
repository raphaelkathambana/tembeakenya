
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';


class GroupEventSignUp extends StatefulWidget {
  final user;
  const GroupEventSignUp({super.key, required this.user});

  @override
  State<GroupEventSignUp> createState() => _GroupEventSignUpState();
}
/* Sign up -> form
		- Event ID
		- User details
			- Name
			- Email
		- phone number
		- emergency contact
			- name 
			- phone number
*/

class _GroupEventSignUpState extends State<GroupEventSignUp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtil.backgroundColorDark,
        title: const Text(
          'Sign Up',
          style: TextStyle(color: ColorsUtil.textColorDark),
        ),
      ),
    );
  }
}