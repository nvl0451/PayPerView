// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const CustomButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.all(17),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 23,
                color: Theme.of(context).colorScheme.background,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
