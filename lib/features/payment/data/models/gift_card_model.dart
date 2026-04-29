class GiftCardModel {
  const GiftCardModel({
    required this.id,
    required this.balance,
    required this.currency,
  });

  final String id;
  final double balance;
  final String currency;

  String get formattedBalance => '$balance${currency == 'EUR' ? '€' : currency}';
}
