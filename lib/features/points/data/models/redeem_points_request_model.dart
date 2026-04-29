class RedeemPointsRequestModel {
  const RedeemPointsRequestModel({required this.points});

  final int points;

  Map<String, dynamic> toJson() {
    return {'points': points};
  }
}
