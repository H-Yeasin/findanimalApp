class PartnerAdModel {
  const PartnerAdModel({
    required this.id,
    required this.title,
    required this.address,
    required this.status,
    this.description,
    this.photoUrl,
    this.latitude,
    this.longitude,
    this.partnerCompany,
    this.createdAt,
  });

  final String id;
  final String title;
  final String address;
  final String status;
  final String? description;
  final String? photoUrl;
  final double? latitude;
  final double? longitude;
  final String? partnerCompany;
  final DateTime? createdAt;

  factory PartnerAdModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;
    final coordinates = location?['coordinates'] as List<dynamic>?;

    return PartnerAdModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: json['description']?.toString(),
      address: (json['address'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      photoUrl: (json['photo'] as Map<String, dynamic>?)?['secure_url']
          ?.toString(),
      latitude: coordinates != null && coordinates.length >= 2
          ? (coordinates[1] as num).toDouble()
          : null,
      longitude: coordinates != null && coordinates.isNotEmpty
          ? (coordinates[0] as num).toDouble()
          : null,
      partnerCompany: (json['partner'] as Map<String, dynamic>?)?['company']
          ?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
