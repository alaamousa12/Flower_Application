class ApiConstants {
  // استخدام 10.0.2.2 ضروري جداً للمحاكي لكي يرى السيرفر المحلي
  // تأكد أن البورت 5104 هو نفس البورت اللي الباك إند شغال عليه
  static const String baseUrl = "http://10.0.2.2:5104/api";

  static const String login = "$baseUrl/Auth/login";
  static const String register = "$baseUrl/Auth/register";
  static const String products = "$baseUrl/Products";
  static const String favorites = "$baseUrl/Favorites";
  static const String orders = "$baseUrl/Orders";
  static const String notifications = "$baseUrl/Notifications";
}