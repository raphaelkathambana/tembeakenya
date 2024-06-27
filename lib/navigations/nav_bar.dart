// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/navigations/community_nav_bar.dart';
import 'package:tembeakenya/views/home_page.dart';
import 'package:tembeakenya/views/profile_view.dart';

class LayoutView extends StatefulWidget {
  final dynamic user;
  const LayoutView({super.key, required this.user});

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeView(
        user: widget.user,
      ),
      HomeView(
        user: widget.user,
      ),
      CommunityView(
        user: widget.user,
      ),
      ProfileView(
        user: widget.user,
        currentUser: widget.user,
      ),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
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
