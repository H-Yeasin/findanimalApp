import 'package:flutter/material.dart';

class HomeCommunityScreen extends StatelessWidget {
  const HomeCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFBF4E9),
      body: Center(
        child: Text(
          'Community Screen',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFBA4A22),
          ),
        ),
      ),
    );
  }
}
