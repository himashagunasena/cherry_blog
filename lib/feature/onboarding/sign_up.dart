import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../service/auth_service.dart';
import '../components/common_snackbar.dart';
import '../components/onboarding_textfield.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String _message = '';
  String title = '';
  bool hideSnackBar = true;
  bool success = false;

  Future<void> _register() async {
    User? user = await _authService.signUp(
      _emailController.text,
      _passwordController.text,
      _usernameController.text, // Pass username to the signup method
    );

    if (user != null) {
      setState(() {
        title = "Successful";
        _message = 'Registration successfully done.';
        success = true;
        hideSnackBar = true;
        Future.delayed(Duration(seconds: 2)).then((value) =>
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen())));
      });
      print('User registered: ${user.uid}');
    } else {
      setState(() {
        title = "Register Unsuccessfully!";
        if (_usernameController.text.isEmpty) {
          _message = 'Please enter your user name';
        } else if (_emailController.text.isEmpty) {
          _message = 'Please enter your email';
        } else if (_passwordController.text.isEmpty) {
          _message = 'Please input your password';
        } else {
          _message = _authService.errorMessage?.message.toString() ??
              "Invalid Input. Please check again";
        }
        success = false;
        hideSnackBar = true;
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
                      SizedBox(
                        height: 24,
                      ),
                      const Text(
                        "Let's Register you in.",
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      OnBoardingTextField(
                        textEditingController: _usernameController,
                        label: 'Username',
                      ),
                      const SizedBox(height: 16.0),
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
                              title: title,
                              description: _message,
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
                              side: BorderSide(color: Colors.transparent)))),
                  onPressed: _register,
                  child: const Text(
                    'Create an account',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("I already have an account?",
                        style: TextStyle(fontSize: 14)),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text("Log In",
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
    );
  }
}
