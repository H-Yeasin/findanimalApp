enum AppPaymentMethodType { visa, mastercard, other }

class PaymentMethodModel {
  const PaymentMethodModel({
    required this.id,
    required this.type,
    required this.lastFour,
    required this.cardholderName,
    required this.expiryDate,
    this.isDefault = false,
  });

  final String id;
  final AppPaymentMethodType type;
  final String lastFour;
  final String cardholderName;
  final String expiryDate;
  final bool isDefault;

  String get brandName {
    return switch (type) {
      AppPaymentMethodType.visa => 'Visa',
      AppPaymentMethodType.mastercard => 'MasterCard',
      AppPaymentMethodType.other => 'Card',
    };
  }
}
