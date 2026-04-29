import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(title: Text(name)));
  }
}
