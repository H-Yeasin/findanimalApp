import 'package:flutter/material.dart';

class AppBlankScreen extends StatelessWidget {
  const AppBlankScreen({super.key, this.backgroundColor});

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: const SizedBox.shrink(),
    );
  }
}
