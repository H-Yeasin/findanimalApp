class PointsCategorySummaryModel {
  const PointsCategorySummaryModel({
    required this.sourceKey,
    required this.label,
    required this.points,
  });

  /// The raw source key from the backend (e.g. 'animal_report').
  final String sourceKey;

  /// Human-readable display name (already localized before creation).
  final String label;

  /// Total points earned in this category. 0 if the user has no transactions.
  final int points;
}
