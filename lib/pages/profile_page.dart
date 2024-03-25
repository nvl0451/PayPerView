// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pay_per_view/components/custom_back_button.dart';
import 'package:pay_per_view/components/custom_button.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: getUserDetails(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text("error: ${snapshot.error}");
              } else if (snapshot.hasData) {
                Map<String, dynamic>? user = snapshot.data!.data();

                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 15),
                    child: Center(
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              CustomBackButton(),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(24)),
                            padding: EdgeInsets.all(25),
                            child: Icon(
                              Icons.cruelty_free,
                              size: 75,
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            (user?['username'] != null)
                                ? user!['username']
                                : "username not found",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            (user?['email'] != null)
                                ? user!['email']
                                : "email not found",
                            style: TextStyle(fontSize: 22),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "balance: \$${(user?['balance'] != null) ? user!['balance'].toString() : "balance not found"}",
                              style: TextStyle(fontSize: 22)),
                          SizedBox(
                            height: 15,
                          ),
                          CustomButton(
                            text: "withdraw",
                            onTap: () {},
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Text('no data');
              }
            })),
      ),
    );
  }
}
