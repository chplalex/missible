import 'package:flutter/material.dart';

class AppSectionTitle extends StatelessWidget {
  final String text;

  const AppSectionTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.deepPurpleAccent,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.deepPurpleAccent, Colors.deepPurple],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white70)),
    );
  }
}
