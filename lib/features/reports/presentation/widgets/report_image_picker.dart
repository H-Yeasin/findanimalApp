import 'package:flutter/material.dart';

class ReportImagePicker extends StatelessWidget {
  const ReportImagePicker({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.add_a_photo_outlined),
      label: const Text('Add Images'),
    );
  }
}
