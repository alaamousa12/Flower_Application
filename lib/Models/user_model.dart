class User {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String country;
  final String gender;
  final String? profileImage;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.country,
    required this.gender,
    this.profileImage,
    this.token = "",
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // 👇👇 هنا التعديل المهم: طباعة البيانات للتأكد والبحث عن الـ ID بكل الطرق
    print("📥 Parsing User Data: $json");

    return User(
      // تجربة كل الاحتمالات الممكنة لاسم الـ ID
      id: json['id'] ?? json['Id'] ?? json['userId'] ?? json['UserId'] ?? 0,

      name: json['name'] ?? json['Name'] ?? '',
      email: json['email'] ?? json['Email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['PhoneNumber'] ?? json['phone'] ?? '',
      country: json['country'] ?? json['Country'] ?? '',
      gender: json['gender'] ?? json['Gender'] ?? 'Male',
      profileImage: json['profileImage'] ?? json['ProfileImage'],
      token: json['token'] ?? "",
    );
  }
}