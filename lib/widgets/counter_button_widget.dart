import 'package:flutter/material.dart';

class CounterButtonWidget extends StatelessWidget {
  /// Whether the button should increase the counter.
  final bool increase;

  /// The icon to display inside the button.
  final IconData icon;

  /// Callback that triggers when the button is pressed.
  final void Function() onPressed;

  /// A custom button widget that displays an icon button
  const CounterButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    this.increase = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.black),
      child: IconButton(color: Colors.white, icon: Icon(icon, size: 30), onPressed: onPressed),
    );
  }
}
