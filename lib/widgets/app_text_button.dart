import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const AppTextButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(text, style: Theme.of(context).textTheme.titleSmall?.copyWith(decoration: TextDecoration.underline)),
    );
  }
}
