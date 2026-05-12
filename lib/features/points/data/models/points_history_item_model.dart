class PointsHistoryItemModel {
  const PointsHistoryItemModel({
    required this.id,
    required this.points,
    required this.reason,
    required this.createdAt,
    this.source,
    this.note,
    this.missionTitle,
  });

  final String id;
  final int points;
  final String reason;
  final DateTime createdAt;
  final String? source;
  final String? note;
  final String? missionTitle;

  factory PointsHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return PointsHistoryItemModel(
      id: (json['id'] ?? json['_id']) as String,
      points: (json['points'] as num).toInt(),
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      source: json['source'] as String?,
      note: json['note'] as String?,
      missionTitle: (json['mission'] as Map<String, dynamic>?)?['title'] as String?,
    );
  }

  factory PointsHistoryItemModel.fromTransactionJson(Map<String, dynamic> json) {
    final mission = json['mission'] as Map<String, dynamic>?;
    return PointsHistoryItemModel(
      id: (json['_id'] ?? json['id']) as String,
      points: (json['points'] as num?)?.toInt() ?? 0,
      reason: '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      source: json['source'] as String?,
      note: json['note'] as String?,
      missionTitle: mission?['title'] as String?,
    );
  }
}
