import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/controllers/auth_controller.dart';
import 'package:tembeakenya/model/user.dart';
import '../../assets/colors.dart';
import 'package:tembeakenya/constants/constants.dart';

class VerifyEmailView extends StatefulWidget {
  final Map<String, String>? params;
  final String? id;
  final String? token;
  final User? user;

  const VerifyEmailView({
    super.key,
    this.params,
    this.id,
    this.token,
    this.user,
  });

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  bool _isLoading = false;
  String? _verificationMessage;
  late NavigationService navigationService;

  @override
  void initState() {
    navigationService = NavigationService(router);
    super.initState();
    if (widget.id != null && widget.token != null && widget.params != null) {
      _verifyEmail(widget.id!, widget.token!, widget.params!, widget.user);
    } else {
      _verificationMessage =
          'A Verification Link has been Sent to your Address. Please Click it to verify your account.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Verify Email',
            style: TextStyle(
              color: ColorsUtil.primaryColorLight,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_verificationMessage != null) Text(_verificationMessage!),
              if (_verificationMessage == null)
                const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text("Didn't Receive a Verification Link?"),
              TextButton(
                onPressed: () async {
                  AuthController(navigationService).sendVerification(context);
                  if (!context.mounted) return;
                  showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                            title: Text('New Verification Link Sent!'),
                            content: Text(
                                'A fresh link has been sent to your email.'),
                          ));
                },
                child: const Text('Click Here for a New Link.'),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  icon: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.logout),
                  onPressed: _isLoading ? null : _handleLogout,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyEmail(String id, String token, params, User? user) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await APICall().client.get(
            '${url}api/v1/email/verify/$id/$token',
            queryParameters: Map.of(params),
            options: Options(headers: {
              'Accept': 'application/json',
            }),
          );

      setState(() {
        _verificationMessage = 'Email successfully verified!';
      });

      // delay 1 second before continuing to home
      await Future.delayed(const Duration(seconds: 1));

      // check if the user variable is present or null and pass it to the route
      if (user != null) {
        debugPrint('User should be loaded');
        debugPrint(user.toJson().toString());
        // Navigate to the home page or perform other actions
        if (!mounted) return;
        navigationService.navigateToNavbar(context, user);
      } else {
        debugPrint('User is null');
        final userData = await APICall().client.get('${url}api/user');
        user = User.fromJson(userData.data);
        if (!mounted) return;
        navigationService.navigateToNavbar(context, user);
      }
      // context.go('/home');
      // navigationService.navigateToNavbar(context, user);
    } on DioException catch (e) {
      setState(() {
        _verificationMessage = 'Verification failed: ${e.response?.data}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
      context.go('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed')),
      );
    }
  }
}
