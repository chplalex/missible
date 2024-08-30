import 'package:flutter/material.dart';

class AppColoredButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const AppColoredButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.deepPurpleAccent,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.lightBlue, Colors.blueAccent],
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(text, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white70)),
      ),
    );
  }
}
