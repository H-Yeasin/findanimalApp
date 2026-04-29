class UpdateProfileRequestModel {
  const UpdateProfileRequestModel({required this.name, required this.email});

  final String name;
  final String email;

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email};
  }
}
