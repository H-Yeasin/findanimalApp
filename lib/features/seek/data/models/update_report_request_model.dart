class UpdateReportRequestModel {
  const UpdateReportRequestModel({required this.status, this.description});

  final String status;
  final String? description;

  Map<String, dynamic> toJson() {
    return {'status': status, 'description': description};
  }
}
