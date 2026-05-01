import 'package:intl/intl.dart';

import '../../../data/models/report_model.dart';

class AnimalProfileData {
  final String id;
  final String name;
  final String details;
  final String time;
  final String status;
  final String description;
  final String imageUrl;
  final String ownerName;
  final bool isPlaceholder;
  final String? contactPhone;
  final String? contactEmail;
  final bool isPhoneVisible;
  final bool isEmailVisible;
  final double? latitude;
  final double? longitude;
  final String? address;

  AnimalProfileData({
    required this.id,
    required this.name,
    required this.details,
    required this.time,
    required this.status,
    required this.description,
    required this.imageUrl,
    required this.ownerName,
    this.isPlaceholder = false,
    this.contactPhone,
    this.contactEmail,
    this.isPhoneVisible = false,
    this.isEmailVisible = false,
    this.latitude,
    this.longitude,
    this.address,
  });

  factory AnimalProfileData.fromReport(ReportModel report) {
    final isFound = report.status.toLowerCase() == 'found';
    final actionVerb = isFound ? 'Found' : 'Lost';
    final hasImage = report.images.isNotEmpty;
    final author = report.author;
    final ownerName = author == null
        ? 'Owner'
        : '${author.firstName} ${author.lastName}'.trim();
    final coordinates = report.location.coordinates;

    return AnimalProfileData(
      id: report.id,
      name: report.animalName.isNotEmpty
          ? report.animalName.toUpperCase()
          : report.species.toUpperCase(),
      details:
          '${report.age} | ${report.species} | ${report.breed} | $actionVerb',
      time: DateFormat(
        'MMM d, yyyy - h:mm a',
      ).format(report.eventDate.toLocal()),
      status: report.status,
      description: report.description,
      imageUrl: hasImage ? report.images.first.secureUrl : '',
      ownerName: ownerName.isEmpty ? 'Owner' : ownerName,
      isPlaceholder: !hasImage,
      contactPhone: report.contactPhone,
      contactEmail: report.contactEmail,
      isPhoneVisible: report.isPhoneVisible,
      isEmailVisible: report.isEmailVisible,
      latitude: coordinates.length >= 2 ? coordinates[1] : null,
      longitude: coordinates.length >= 2 ? coordinates[0] : null,
      address: report.location.address,
    );
  }
}
