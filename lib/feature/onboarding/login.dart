
import '../../feature/onboarding/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../service/auth_service.dart';
import '../components/common_snackbar.dart';
import '../components/onboarding_textfield.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';
  String title = '';
  bool hideSnackBar = true;
  bool success = false;

  Future<void> _login() async {
    User? user = await _authService.signInWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );

    if (user != null) {
      String username = user.displayName ?? 'Anonymous';
      success = true;
      hideSnackBar = true;
      title = "Successfully Logged";
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              username: username,
              uid: user.uid,
            ),
          ),
        );
        print('User logged in: ${user.uid}, Username: $username');
      }
    } else {
      setState(() {
        title = "Login Failed.";
        _message = _authService.errorMessage?.message.toString() ??
            "Invalid Credentials. Please try again.";
        _emailController.clear();
        _passwordController.clear();
        hideSnackBar = true;
        success = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        setState(() {
          FocusManager.instance.primaryFocus?.unfocus();
        });
      },
      child: WillPopScope(
        onWillPop: () async{
          return false;
        },
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(height: 24),
                        const Text(
                          "Let's Login you in.",
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          "Welcome back.\nYou've been missed!",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(
                          height: 48,
                        ),
                        OnBoardingTextField(
                          textEditingController: _emailController,
                          label: 'Email',
                        ),
                        const SizedBox(height: 16.0),
                        OnBoardingTextField(
                          textEditingController: _passwordController,
                          label: 'Password',
                          obscure: true,
                        ),
                        const SizedBox(height: 16.0),
                        _message.isNotEmpty && hideSnackBar == true
                            ? CommonSnackBar(
                                title: "Login Failed",
                                description: "Invalid credintials. Try again",
                                onClose: () {
                                  setState(() {
                                    hideSnackBar = false;
                                  });
                                },
                                success: success,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        padding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 16)),
                        elevation: const MaterialStatePropertyAll(0),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: const BorderSide(
                                    color: Colors.transparent)))),
                    onPressed: _login,
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("I haven't account?",
                          style: TextStyle(fontSize: 14)),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()));
                          },
                          child: Text("Register",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: colorTheme.primary,
                                  fontWeight: FontWeight.w600)))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
