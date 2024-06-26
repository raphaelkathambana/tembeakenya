import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/controllers/auth_controller.dart';
import 'package:tembeakenya/main.dart';
// import 'package:tembeakenya/model/user_model.dart';
import '../../assets/colors.dart';

class HomeView extends StatefulWidget {
  final user;
  const HomeView({super.key, required this.user});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isLoading = false;
  late NavigationService navigationService;

  @override
  void initState() {
    navigationService = NavigationService(router);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorsUtil.backgroundColorDark,
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
            Text('Welcome ${widget.user.fullName}'),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  icon: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.logout),
                  onPressed: _isLoading ? null : _handleLogout,
                )),
            ElevatedButton(
                onPressed: () => context.go('/test-view'),
                style: const MainPage().raisedButtonStyle,
                child: const Text('ViewTest')),
          ]),
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoading = true;
    });

    bool isLoggedOut = await AuthController(navigationService).logout();

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;
    if (isLoggedOut) {
      // Navigate to the login or welcome screen
      if (!mounted) return;
      // context.go('/login');
      navigationService.navigateToLogin(context);
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed')),
      );
    }
  }
}
