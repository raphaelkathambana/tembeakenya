// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/navigations/community_nav_bar.dart';
import 'package:tembeakenya/views/home_page.dart';
import 'package:tembeakenya/views/map.dart';
import 'package:tembeakenya/views/profile_view.dart';

class LayoutView extends StatefulWidget {
  final dynamic user;
  // final dynamic users;
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
      const MapView(),
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
