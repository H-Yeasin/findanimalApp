import 'redeemable_item_model.dart';

class RedemptionModel {
  const RedemptionModel({
    required this.id,
    required this.user,
    required this.rewardItem,
    required this.pointsAtRedemption,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String user;
  final RedeemableItemModel rewardItem;
  final int pointsAtRedemption;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory RedemptionModel.fromJson(Map<String, dynamic> json) {
    return RedemptionModel(
      id: json['_id'] as String,
      user: json['user'] as String,
      rewardItem: RedeemableItemModel.fromJson(json['rewardItem'] as Map<String, dynamic>),
      pointsAtRedemption: json['pointsAtRedemption'] as int,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
