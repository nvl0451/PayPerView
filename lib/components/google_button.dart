// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final void Function()? onTap;

  const GoogleButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.all(11),
        child: Center(
          child: Image.asset(
            'lib/images/google.png',
            height: 45,
            width: 45,
            color: Theme.of(context).colorScheme.background,
          ),
        ),
      ),
    );
  }
}
