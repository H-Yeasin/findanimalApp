import 'package:flutter/material.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(text));
  }
}
