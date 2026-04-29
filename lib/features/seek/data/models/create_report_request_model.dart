class CreateReportRequestModel {
  const CreateReportRequestModel({
    required this.animalName,
    required this.species,
    required this.status,
  });

  final String animalName;
  final String species;
  final String status;

  Map<String, dynamic> toJson() {
    return {'animalName': animalName, 'species': species, 'status': status};
  }
}
