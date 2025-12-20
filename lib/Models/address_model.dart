class AddressModel {
  final int addressId; // لاحظ الاسم في الباك إند address_id
  final String city;
  final String street;
  final String postalCode;

  AddressModel({
    required this.addressId,
    required this.city,
    required this.street,
    required this.postalCode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['addressId'] ?? 0,
      city: json['city'] ?? '',
      street: json['street'] ?? '',
      postalCode: json['postalCode'] ?? '',
    );
  }
}