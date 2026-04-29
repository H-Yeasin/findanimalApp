class RedeemableItemModel {
  const RedeemableItemModel({
    required this.id,
    required this.name,
    required this.pointsCost,
    required this.imageUrl,
    required this.category,
  });

  final String id;
  final String name;
  final int pointsCost;
  final String imageUrl;
  final String category;

  factory RedeemableItemModel.fromJson(Map<String, dynamic> json) {
    return RedeemableItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      pointsCost: json['pointsCost'] as int,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
    );
  }
}
