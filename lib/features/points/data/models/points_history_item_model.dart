class PointsHistoryItemModel {
  const PointsHistoryItemModel({
    required this.id,
    required this.points,
    required this.reason,
    required this.createdAt,
  });

  final String id;
  final int points;
  final String reason;
  final DateTime createdAt;

  factory PointsHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return PointsHistoryItemModel(
      id: json['id'] as String,
      points: json['points'] as int,
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
