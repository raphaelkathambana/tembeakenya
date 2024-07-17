// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/controllers/auth_controller.dart';
import 'package:tembeakenya/controllers/community_controller.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/navigations/community_nav_bar.dart';
import 'package:tembeakenya/views/home_page.dart';
// import 'package:tembeakenya/views/map.dart';
import 'package:tembeakenya/views/navigation_page.dart';
import 'package:tembeakenya/views/profile_view.dart';

class LayoutView extends StatefulWidget {
  final User user;
  // final dynamic users;
  const LayoutView({super.key, required this.user});

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  late NavigationService navigationService;
  User? theUser;
  dynamic locations;

  @override
  void initState() {
    theUser = widget.user;

    CommunityController().getHikes().then((hikes) {
      setState(() {
        locations = hikes;
      });
    });

    navigationService = NavigationService(router);

    int count = 0;
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        AuthController(navigationService).refreshUserDetails().then((value) {
          theUser = value;
        });
      });
      count++;
      debugPrint('User Updated times: $count');
    });

    super.initState();
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      locations != null && locations.isNotEmpty
          ? HomeView(user: theUser!, locations: locations)
          : Container(
              alignment: Alignment.center,
              width: 20,
              height: 20,
              child: const CircularProgressIndicator(),
            ),
      NavigationView(
        user: theUser,
      ),
      CommunityView(
        user: theUser,
      ),
      ProfileView(
        currentUser: theUser!,
      ),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) async {
          Future.delayed(const Duration(seconds: 2));
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Navigation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: screens[_currentIndex],
    );
  }
}
