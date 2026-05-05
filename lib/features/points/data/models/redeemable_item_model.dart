class RewardPhotoModel {
  const RewardPhotoModel({
    required this.publicId,
    required this.secureUrl,
  });

  final String publicId;
  final String secureUrl;

  factory RewardPhotoModel.fromJson(Map<String, dynamic> json) {
    return RewardPhotoModel(
      publicId: json['public_id'] as String,
      secureUrl: json['secure_url'] as String,
    );
  }
}

class RedeemableItemModel {
  const RedeemableItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.type,
    this.amount,
    required this.category,
    required this.stock,
    required this.isActive,
    required this.photo,
  });

  final String id;
  final String title;
  final String description;
  final int points;
  final String type;
  final int? amount;
  final String category;
  final int stock;
  final bool isActive;
  final RewardPhotoModel photo;

  factory RedeemableItemModel.fromJson(Map<String, dynamic> json) {
    return RedeemableItemModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      points: json['points'] as int,
      type: json['type'] as String,
      amount: json['amount'] as int?,
      category: json['category'] as String,
      stock: json['stock'] as int,
      isActive: json['isActive'] as bool,
      photo: RewardPhotoModel.fromJson(json['photo'] as Map<String, dynamic>),
    );
  }
}
