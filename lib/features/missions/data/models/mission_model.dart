class MissionModel {
  const MissionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.duration,
    required this.status,
    this.points,
    this.photo,
    this.partner,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String description;
  final String address;
  final String duration;
  final int? points;
  final MissionPhoto? photo;
  final String status;
  final MissionPartner? partner;
  final MissionLocation? location;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    return MissionModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      duration: (json['duration'] ?? '').toString(),
      points: (json['points'] as num?)?.toInt(),
      photo: json['photo'] is Map<String, dynamic>
          ? MissionPhoto.fromJson(json['photo'] as Map<String, dynamic>)
          : null,
      status: (json['status'] ?? '').toString(),
      partner: json['partner'] is Map<String, dynamic>
          ? MissionPartner.fromJson(json['partner'] as Map<String, dynamic>)
          : null,
      location: json['location'] is Map<String, dynamic>
          ? MissionLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }
}

class MissionPhoto {
  const MissionPhoto({required this.publicId, required this.secureUrl});

  final String publicId;
  final String secureUrl;

  factory MissionPhoto.fromJson(Map<String, dynamic> json) {
    return MissionPhoto(
      publicId: (json['public_id'] ?? json['publicId'] ?? '').toString(),
      secureUrl: (json['secure_url'] ?? json['secureUrl'] ?? '').toString(),
    );
  }
}

class MissionPartner {
  const MissionPartner({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.company,
    this.email,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String? company;
  final String? email;

  factory MissionPartner.fromJson(Map<String, dynamic> json) {
    return MissionPartner(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      company: json['company']?.toString(),
      email: json['email']?.toString(),
    );
  }
}

class MissionLocation {
  const MissionLocation({
    required this.type,
    required this.coordinates,
    this.address,
  });

  final String type;
  final List<double> coordinates;
  final String? address;

  double? get longitude => coordinates.isNotEmpty ? coordinates[0] : null;
  double? get latitude => coordinates.length >= 2 ? coordinates[1] : null;

  factory MissionLocation.fromJson(Map<String, dynamic> json) {
    final rawCoordinates = json['coordinates'] as List<dynamic>? ?? const [];

    return MissionLocation(
      type: (json['type'] ?? '').toString(),
      coordinates: rawCoordinates
          .whereType<num>()
          .map((coordinate) => coordinate.toDouble())
          .toList(),
      address: json['address']?.toString(),
    );
  }
}
