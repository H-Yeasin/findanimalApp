import 'package:flutter/material.dart';

class PartnerAdCard extends StatelessWidget {
  const PartnerAdCard({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(title: Text(title)));
  }
}
