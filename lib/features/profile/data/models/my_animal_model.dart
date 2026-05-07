class MyAnimalModel {
  const MyAnimalModel({
    required this.id,
    required this.title,
    required this.description,
    this.species,
    this.breed,
    this.gender,
    this.age,
    this.hasMicrochip,
    this.hasTattoo,
    this.hasCollarOrHarness,
    this.status,
    this.slug,
    this.photo,
    this.user,
  });

  final String id;
  final String title;
  final String description;
  final String? species;
  final String? breed;
  final String? gender;
  final String? age;
  final String? hasMicrochip;
  final String? hasTattoo;
  final String? hasCollarOrHarness;
  final String? status;
  final String? slug;
  final MyAnimalPhoto? photo;
  final MyAnimalUser? user;

  factory MyAnimalModel.fromJson(Map<String, dynamic> json) {
    return MyAnimalModel(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      species: json['species'] as String?,
      breed: json['breed'] as String?,
      gender: json['gender'] as String?,
      age: json['age'] as String?,
      hasMicrochip: json['hasMicrochip'] as String?,
      hasTattoo: json['hasTattoo'] as String?,
      hasCollarOrHarness: json['hasCollarOrHarness'] as String?,
      status: json['status'] as String?,
      slug: json['slug'] as String?,
      photo: json['photo'] is Map<String, dynamic>
          ? MyAnimalPhoto.fromJson(json['photo'] as Map<String, dynamic>)
          : null,
      user: json['user'] is Map<String, dynamic>
          ? MyAnimalUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MyAnimalPhoto {
  const MyAnimalPhoto({required this.publicId, required this.secureUrl});

  final String publicId;
  final String secureUrl;

  factory MyAnimalPhoto.fromJson(Map<String, dynamic> json) {
    return MyAnimalPhoto(
      publicId: json['public_id'] as String? ?? '',
      secureUrl: json['secure_url'] as String? ?? '',
    );
  }
}

class MyAnimalUser {
  const MyAnimalUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;

  factory MyAnimalUser.fromJson(Map<String, dynamic> json) {
    return MyAnimalUser(
      id: json['_id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
}
