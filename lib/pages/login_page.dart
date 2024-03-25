// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pay_per_view/components/custom_button.dart';
import 'package:pay_per_view/components/custom_textfield.dart';
import 'package:pay_per_view/components/google_button.dart';
import 'package:pay_per_view/helper/helper_functions.dart';

class LoginPage extends StatefulWidget {
  final void Function()? goToRegister;

  LoginPage({super.key, this.goToRegister});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  void login() async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      //String msg = e.message!;
      displayErrorMessage(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cruelty_free,
                  size: 80,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "S H A D E S O F G R E Y",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 25,
                ),
                CustomTextfield(
                    hintText: "email",
                    obscureText: false,
                    controller: emailController),
                SizedBox(
                  height: 10,
                ),
                CustomTextfield(
                    hintText: "password",
                    obscureText: true,
                    controller: passwordController),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Text(
                        "forgot password?",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(child: CustomButton(text: "login", onTap: login)),
                    SizedBox(
                      width: 10,
                    ),
                    GoogleButton(onTap: () {})
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("don't have an account? "),
                    GestureDetector(
                      onTap: widget.goToRegister,
                      child: Text(
                        "register here",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
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
