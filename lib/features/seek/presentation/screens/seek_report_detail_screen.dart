import 'package:flutter/material.dart';
import 'animal_profile_screen.dart';

class SeekReportDetailScreen extends StatelessWidget {
  const SeekReportDetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    final data = AnimalProfileData(
      id: id,
      name: id.isEmpty ? 'PACO' : 'PACO #$id',
      details: 'Senior | Dog | Golden Retriever | Lost',
      time: 'Today at 5:30 PM',
      status: 'Lost',
      description:
          'Seen near the park. Friendly dog, responds to his name and may wear a blue collar.',
      imageUrl:
          'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=500&q=80',
      ownerName: 'Owner',
    );

    return AnimalProfileScreen(data: data);
  }
}
