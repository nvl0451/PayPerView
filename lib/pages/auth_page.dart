import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pay_per_view/pages/home_page.dart';
import 'package:pay_per_view/pages/login_page.dart';
import 'package:pay_per_view/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            if (showLoginPage) {
              return LoginPage(
                goToRegister: togglePages,
              );
            } else {
              return RegisterPage(
                goToLogin: togglePages,
              );
            }
          }
        },
      ),
    );
  }
}
