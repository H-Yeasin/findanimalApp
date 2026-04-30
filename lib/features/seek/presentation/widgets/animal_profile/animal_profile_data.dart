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
  });
}
