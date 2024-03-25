// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pay_per_view/components/custom_button.dart';
import 'package:pay_per_view/components/custom_textfield.dart';
import 'package:pay_per_view/components/google_button.dart';
import 'package:pay_per_view/helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? goToLogin;

  RegisterPage({super.key, required this.goToLogin});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  void register() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);

      displayErrorMessage("passwords don't match", context);
    } else if (usernameController.text == "") {
      Navigator.pop(context);

      displayErrorMessage("username cant be empty", context);
    } else {
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        createUserDocument(userCredential);

        if (context.mounted) {
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        //String msg = e.message!;
        displayErrorMessage(e.code, context);
      }
    }
  }

  void createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
        'balance': 0
      });
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
                    hintText: "username",
                    obscureText: false,
                    controller: usernameController),
                SizedBox(
                  height: 10,
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
                CustomTextfield(
                    hintText: "confirm password",
                    obscureText: true,
                    controller: confirmPasswordController),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                        child: CustomButton(text: "register", onTap: register)),
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
                    Text("already have an account? "),
                    GestureDetector(
                      onTap: widget.goToLogin,
                      child: Text(
                        "sign in",
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
