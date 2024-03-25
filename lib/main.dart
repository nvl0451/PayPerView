import 'package:flutter/material.dart';
import 'package:pay_per_view/pages/auth_page.dart';
import 'package:pay_per_view/pages/home_page.dart';
import 'package:pay_per_view/pages/login_page.dart';
import 'package:pay_per_view/pages/profile_page.dart';
import 'package:pay_per_view/pages/users_page.dart';
import 'package:pay_per_view/theme/themes.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/auth_page': (context) => AuthPage(),
        '/home_page': (context) => HomePage(),
        '/profile_page': (context) => ProfilePage(),
        '/users_page': (context) => UsersPage(),
      },
    );
  }
}
