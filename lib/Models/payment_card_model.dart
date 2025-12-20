class PaymentCardModel {
  final int cardId;
  final String name;
  final String cardNumber;
  final String expiryDate;

  PaymentCardModel({
    required this.cardId,
    required this.name,
    required this.cardNumber,
    required this.expiryDate,
  });

  factory PaymentCardModel.fromJson(Map<String, dynamic> json) {
    return PaymentCardModel(
      // لاحظ: الحروف الكبيرة في JSON عشان تطابق الباك إند
      cardId: json['cardId'] ?? json['CardId'] ?? 0,
      name: json['name'] ?? json['Name'] ?? '',
      cardNumber: json['cardNumber'] ?? json['CardNumber'] ?? '',
      expiryDate: json['expiryDate'] ?? json['ExpiryDate'] ?? '',
    );
  }
}