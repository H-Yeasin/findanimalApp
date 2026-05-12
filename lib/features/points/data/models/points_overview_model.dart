import 'points_history_item_model.dart';

class PointsOverviewModel {
  const PointsOverviewModel({
    required this.balance,
    required this.transactions,
  });

  final int balance;
  final List<PointsHistoryItemModel> transactions;

  factory PointsOverviewModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final transactions = (data['transactions'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(PointsHistoryItemModel.fromTransactionJson)
        .toList();

    return PointsOverviewModel(
      balance: (data['balance'] as num?)?.toInt() ?? 0,
      transactions: transactions,
    );
  }
}
