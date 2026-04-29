import 'package:flutter/material.dart';

class PointsHistoryTile extends StatelessWidget {
  const PointsHistoryTile({
    required this.title,
    required this.points,
    super.key,
  });

  final String title;
  final int points;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(title), trailing: Text(points.toString()));
  }
}
