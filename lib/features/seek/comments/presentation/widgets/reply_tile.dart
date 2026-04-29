import 'package:flutter/material.dart';

class ReplyTile extends StatelessWidget {
  const ReplyTile({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: const Icon(Icons.reply), title: Text(text));
  }
}
