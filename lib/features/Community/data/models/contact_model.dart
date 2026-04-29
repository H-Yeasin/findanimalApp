import '../../../../core/network/api_endpoints.dart';

class ContactModel {
  final String id;
  final String name;
  final String type;
  final String? city;
  final String? country;
  final String? image;
  final String status;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? phone;
  final String? email;
  final String? website;
  final String? description;

  ContactModel({
    required this.id,
    required this.name,
    required this.type,
    this.city,
    this.country,
    this.image,
    required this.status,
    this.latitude,
    this.longitude,
    this.address,
    this.phone,
    this.email,
    this.website,
    this.description,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    String? imageUrl;
    
    // Debug print for user to see in console
    // print('ContactModel JSON: $json'); 

    final imageData = json['image'] ?? 
                      json['photo'] ?? // Found in actual API response
                      json['profileImage'] ?? 
                      json['imageUrl'] ?? 
                      json['profile_image'] ?? 
                      json['images'] ?? 
                      json['avatar'];

    if (imageData != null) {
      if (imageData is Map) {
        imageUrl = (imageData['secure_url'] ?? imageData['url']) as String?;
      } else if (imageData is String) {
        imageUrl = imageData;
      } else if (imageData is List && imageData.isNotEmpty) {
        final firstItem = imageData.first;
        if (firstItem is Map) {
          imageUrl = (firstItem['secure_url'] ?? firstItem['url'] ?? firstItem['image']) as String?;
        } else if (firstItem is String) {
          imageUrl = firstItem;
        }
      }
    }

    return ContactModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      city: json['city'],
      country: json['country'],
      image: imageUrl,
      status: json['status'] ?? 'active',
      latitude: (json['location']?['coordinates']?[1] as num?)?.toDouble(),
      longitude: (json['location']?['coordinates']?[0] as num?)?.toDouble(),
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      description: json['description'],
    );
  }

  String get fullAddress {
    if (address != null) return address!;
    final parts = [city, country].where((e) => e != null).toList();
    return parts.join(' - ');
  }

  String? get fullImageUrl {
    if (image == null || image!.isEmpty) return null;
    if (image!.startsWith('http')) return image;
    
    // Dynamically derive the media base URL from the API base URL
    // ApiEndpoints.baseUrl: http://.../api/v1
    // We want: http://...
    String mediaBaseUrl = ApiEndpoints.baseUrl.split('/api/').first;
    
    // Ensure the path starts with a slash
    final path = image!.startsWith('/') ? image : '/$image';
    return '$mediaBaseUrl$path';
  }
}
