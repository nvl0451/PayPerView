import 'package:flutter/material.dart';
import 'package:pay_per_view/components/custom_button.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';

class CustomEventCard extends StatelessWidget {
  final String eventName;
  final String eventAdmin;
  final String buttonText;
  final int eventPrice;
  final void Function()? onTap;

  const CustomEventCard(
      {super.key,
      required this.eventName,
      required this.eventAdmin,
      required this.eventPrice,
      required this.onTap,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: RoundedExpansionTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            tileColor: Theme.of(context).colorScheme.primary,
            focusColor: Theme.of(context).colorScheme.secondary,
            curve: Curves.easeIn,
            duration: Duration(milliseconds: 200),
            noTrailing: true,
            //trailing: SizedBox.shrink(),
            title: Text(
              eventName,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
            subtitle: Text(eventAdmin,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary)),
            children: [
              CustomButton(
                text: buttonText,
                onTap: onTap,
              )
            ],
          ),
        ),
      ),
    );
  }
}
