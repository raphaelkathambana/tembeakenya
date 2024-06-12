import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/constants.dart';
import 'package:tembeakenya/main.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home Page',
            style: TextStyle(
              color: ColorsUtil.primaryColorLight,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            const Text('Welcome'),
            Padding(
                padding: const EdgeInsets.all(10.0),
                // child: TextButton(
                child: IconButton(
                  // onPressed: () async {
                  // bool isLoggedOut = await logout();
                  // if (isLoggedOut) {
                  //   // Navigate to the login or welcome screen
                  //   if (!context.mounted) return;
                  //   context.go('/login');
                  // } else {
                  //   // Show an error message
                  //   if (!context.mounted) return;
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text('Logout failed')),
                  //   );
                  // }
                  icon: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.logout),
                  onPressed: _isLoading ? null : _handleLogout,
                  // },
                )
                // style: const MainPage().raisedButtonStyle,
                // child: const Text("Logout")),
                )
          ]),
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoading = true;
    });

    bool isLoggedOut = await logout();

    setState(() {
      _isLoading = false;
    });

    if (!context.mounted) return;
    if (isLoggedOut) {
      // Navigate to the login or welcome screen
      if (!context.mounted) return;
      context.go('/login');
    } else {
      // Show an error message
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed')),
      );
    }
  }
}

Future<bool> logout() async {
  APICall apiCall = APICall();
  apiCall.clearCookies();
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      final response = await apiCall.client.post('${url}api/v1/logout');
      if (response.statusCode == 200) {
        await prefs.remove('auth_token');
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
