// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                    child: Icon(
                  Icons.cruelty_free,
                  size: 69,
                  color: Theme.of(context).colorScheme.inversePrimary,
                )),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    title: Text(
                      "H O M E",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    title: Text("P R O F I L E",
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inversePrimary)),
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.pushNamed(context, '/profile_page');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.group,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    title: Text("F R I E N D S",
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inversePrimary)),
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.pushNamed(context, '/users_page');
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 35),
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                title: Text("L O G O U T",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary)),
                onTap: () {
                  Navigator.pop(context);

                  logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
