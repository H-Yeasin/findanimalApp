class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.company,
    this.profileImage,
    this.phone,
    this.address,
  });

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String? company;
  final String? profileImage;
  final String? phone;
  final String? address;

  String get fullName => '$firstName $lastName'.trim();

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    String? imageUrl;
    if (json['profileImage'] != null && json['profileImage'] is Map) {
      imageUrl = json['profileImage']['secure_url'] as String?;
    } else if (json['profileImage'] is String) {
      imageUrl = json['profileImage'] as String?;
    }

    return AuthUserModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      company: json['company'] as String?,
      profileImage: imageUrl,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'company': company,
      'profileImage': profileImage,
      'phone': phone,
      'address': address,
    };
  }
}
