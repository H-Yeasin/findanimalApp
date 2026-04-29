class RegisterPartnerRequestModel {
  const RegisterPartnerRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.company,
    required this.password,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String company;
  final String password;

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'company': company,
      'password': password,
    };
  }
}
