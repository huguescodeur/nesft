import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

enum AuthScreen { login, register, forgotPassword }

class AuthContainer extends StatefulWidget {
  const AuthContainer({super.key});

  @override
  State<AuthContainer> createState() => _AuthContainerState();
}

class _AuthContainerState extends State<AuthContainer> {
  AuthScreen currentScreen = AuthScreen.login;

  void showLogin() {
    setState(() {
      currentScreen = AuthScreen.login;
    });
  }

  void showRegister() {
    setState(() {
      currentScreen = AuthScreen.register;
    });
  }

  void showForgotPassword() {
    setState(() {
      currentScreen = AuthScreen.forgotPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (currentScreen) {
      case AuthScreen.login:
        return LoginScreen(
          onShowRegister: showRegister,
          onForgotPassword: showForgotPassword,
        );
      case AuthScreen.register:
        return RegisterScreen(
          onShowLogin: showLogin,
        );
      case AuthScreen.forgotPassword:
        return ForgotPasswordScreen(
          onBackToLogin: showLogin,
        );
    }
  }
}
