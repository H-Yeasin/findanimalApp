import 'package:flutter/material.dart';

class CommentInputBox extends StatelessWidget {
  const CommentInputBox({this.onSend, super.key});

  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: TextField(
            decoration: InputDecoration(hintText: 'Write a comment'),
          ),
        ),
        IconButton(onPressed: onSend, icon: const Icon(Icons.send)),
      ],
    );
  }
}
