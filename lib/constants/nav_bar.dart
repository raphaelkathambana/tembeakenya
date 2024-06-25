// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/views/home_page.dart';
import 'package:tembeakenya/views/profile_view.dart';

class LayoutView extends StatefulWidget {
  const LayoutView({super.key});

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  int _currentIndex = 0;
    final List<Widget> _screens = [    
      const HomeView(),
      const HomeView(),
      const ProfileView(),
      const ProfileView(),
    ];
  @override
  Widget build(BuildContext context) {
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
      body: _screens[_currentIndex],
    );
  }
}
