class PaymentMethodModel {
  const PaymentMethodModel({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    this.cardholderName,
    this.isDefault = false,
  });

  final String id;
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;
  final String? cardholderName;
  final bool isDefault;

  String get brandName {
    if (brand.isEmpty) {
      return 'Card';
    }

    final normalized = brand.toLowerCase();
    return switch (normalized) {
      'amex' => 'American Express',
      'american_express' => 'American Express',
      'mastercard' => 'Mastercard',
      'cartes_bancaires' => 'Cartes Bancaires',
      _ => normalized
          .split('_')
          .map(
            (word) => word.isEmpty
                ? word
                : '${word[0].toUpperCase()}${word.substring(1)}',
          )
          .join(' '),
    };
  }

  String get expiryDate =>
      '${expMonth.toString().padLeft(2, '0')}/${expYear.toString().padLeft(2, '0')}';
}
