import 'package:flutter/material.dart';

class PublishEventButton extends StatelessWidget {
  final void Function()? onTap;

  const PublishEventButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(
            Icons.done,
            size: 70,
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        height: 132,
      ),
    );
  }
}
