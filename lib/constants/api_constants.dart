class ApiConstants {
  // ده عنوان السيرفر (الـ IP السحري للمحاكي)
  // لو شغال على موبايل حقيقي، غير الرقم ده لـ IP اللابتوب بتاعك
  static const String baseUrl = "http://10.0.2.2:5104/api";

  // دي الروابط الفرعية لكل صفحة في التطبيق
  // كأننا بنقوله: هات العنوان الرئيسي ولزق فيه اسم القسم

  // رابط المنتجات
  static const String products = "$baseUrl/Products";

  // رابط تسجيل الدخول
  static const String login = "$baseUrl/Auth/login";

  // رابط إنشاء حساب جديد
  static const String register = "$baseUrl/Auth/register";

  // رابط الأوردرات
  static const String orders = "$baseUrl/Orders";
}