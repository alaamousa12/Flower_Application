import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constants.dart';
import '../Models/product_model.dart';
import '../Models/user_model.dart';
import '../Models/notification_model.dart';
import '../Models/order_model.dart';
import '../Models/address_model.dart';
import '../Models/payment_card_model.dart';
import '../Models/admin_order_model.dart';
import '../Models/category_model.dart';

class ApiService {
  // -------------------- Helpers --------------------
  Map<String, String> get _jsonHeaders => {"Content-Type": "application/json"};

  // 1. تسجيل مستخدم جديد
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String country,
    required String gender,
    File? imageFile,
  }) async {
    try {
      var request =
      http.MultipartRequest('POST', Uri.parse(ApiConstants.register));

      request.fields['Name'] = name;
      request.fields['Email'] = email;
      request.fields['Password'] = password;
      request.fields['PhoneNumber'] = phone;
      request.fields['Country'] = country;
      request.fields['Gender'] = gender;

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'ImageFile', imageFile.path));
      }

      var response = await request.send();

      if (response.statusCode != 200 && response.statusCode != 201) {
        final respStr = await response.stream.bytesToString();
        print("🔴 Register Error: $respStr");
      }

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Register Exception: $e");
      return false;
    }
  }

  // 2. تسجيل الدخول
  Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: _jsonHeaders,
        body: json.encode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // 3. تحديث البروفايل
  Future<User?> updateProfile({
    required int userId,
    required String name,
    required String phone,
    required String gender,
    required String country,
    String? password,
    File? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse("${ApiConstants.baseUrl}/Auth/update/$userId"),
      );

      request.fields['Name'] = name;
      request.fields['PhoneNumber'] = phone;
      request.fields['Gender'] = gender;
      request.fields['Country'] = country;

      if (password != null && password.isNotEmpty) {
        request.fields['Password'] = password;
      }

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'ImageFile', imageFile.path));
      }

      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(respStr));
      } else {
        print("🔴 Update Failed: $respStr");
        return null;
      }
    } catch (e) {
      print("Update Error: $e");
      return null;
    }
  }

  // 4. إنشاء طلب
  Future<bool> createOrder({
    required int userId,
    required int addressId,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/Orders"),
        headers: _jsonHeaders,
        body: json.encode({
          "userId": userId,
          "addressId": addressId,
          "paymentMethod": paymentMethod,
          "items": items
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("🔴 Create Order Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Create Order Error: $e");
      return false;
    }
  }

  // -------------------- Notifications --------------------

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) return [];

      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/Notifications/user/$userId"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        return data.map((e) => NotificationModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<int> getUnreadNotificationCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) return 0;

      final res = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/Notifications/user/$userId/unread-count"),
      );

      if (res.statusCode == 200) {
        final body = res.body.trim();
        final decoded = jsonDecode(body);
        if (decoded is int) return decoded;
        return int.tryParse(decoded.toString()) ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> markNotificationAsRead(int notificationId) async {
    try {
      final res = await http.put(
        Uri.parse("${ApiConstants.baseUrl}/Notifications/$notificationId/mark-read"),
        headers: _jsonHeaders,
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // -------------------- Orders --------------------

  Future<List<OrderModel>> getOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) return [];

      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/Orders/user/$userId"),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => OrderModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ✅ Admin: Get all orders
  Future<List<AdminOrderModel>> getAllOrdersAdmin() async {
    try {
      final res = await http.get(Uri.parse("${ApiConstants.baseUrl}/Orders"));
      if (res.statusCode == 200) {
        final list = json.decode(res.body) as List;
        return list.map((e) => AdminOrderModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ✅ Admin: Update order status
  Future<bool> updateOrderStatus(int orderId, String status) async {
    try {
      final res = await http.put(
        Uri.parse("${ApiConstants.baseUrl}/Orders/$orderId/status"),
        headers: _jsonHeaders,
        body: json.encode({"status": status}),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // -------------------- Products --------------------

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.products));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => ProductModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> addProduct({
    required String name,
    required String description,
    required double price,
    required int quantity,
    required int categoryId,
    required String imagePath,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId') ?? 1;

      var request =
      http.MultipartRequest('POST', Uri.parse(ApiConstants.products));
      request.fields['Name'] = name;
      request.fields['Description'] = description;
      request.fields['Price'] = price.toString();
      request.fields['Quantity'] = quantity.toString();
      request.fields['CategoryId'] = categoryId.toString();
      request.fields['SellerId'] = userId.toString();

      if (imagePath.isNotEmpty) {
        request.files.add(
            await http.MultipartFile.fromPath('ImageFile', imagePath));
      }

      var response = await request.send();
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<List<ProductModel>> getUserFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) return [];

      final response =
      await http.get(Uri.parse("${ApiConstants.favorites}/user/$userId"));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => ProductModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // -------------------- Auth helpers --------------------

  Future<bool> resetPassword(String email, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/Auth/reset-password"),
        headers: _jsonHeaders,
        body: json.encode({"email": email, "newPassword": newPassword}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // -------------------- Address --------------------

  Future<bool> addAddress({
    required int userId,
    required String city,
    required String street,
    required String postalCode,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/Addresses"),
        headers: _jsonHeaders,
        body: json.encode({
          "userId": userId,
          "city": city,
          "street": street,
          "postalCode": postalCode,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Add Address Error: $e");
      return false;
    }
  }

  Future<List<AddressModel>> getAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) return [];

      final response = await http.get(
          Uri.parse("${ApiConstants.baseUrl}/Addresses/user/$userId"));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => AddressModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Get Addresses Error: $e");
      return [];
    }
  }

  // -------------------- Payment --------------------

  Future<bool> addPaymentCard({
    required int userId,
    required String name,
    required String cardNumber,
    required String expiryDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/PaymentMethods"),
        headers: _jsonHeaders,
        body: json.encode({
          "userId": userId,
          "name": name,
          "cardNumber": cardNumber,
          "expiryDate": expiryDate,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Add Card Error: $e");
      return false;
    }
  }

  Future<List<PaymentCardModel>> getPaymentCards() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) return [];

      final response = await http.get(
          Uri.parse("${ApiConstants.baseUrl}/PaymentMethods/user/$userId"));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => PaymentCardModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Get Cards Error: $e");
      return [];
    }
  }

  Future<List<ProductModel>> getSpecialOffers() async {
    try {
      final res = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/Products/special-offers"),
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body) as List;
        return data.map((e) => ProductModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // -------------------- Categories --------------------

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response =
      await http.get(Uri.parse("${ApiConstants.baseUrl}/Categories"));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }

  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    try {
      final response = await http
          .get(Uri.parse("${ApiConstants.products}/category/$categoryId"));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => ProductModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching category products: $e");
      return [];
    }
  }

  // ✅✅ FIXED: Search Products (matches your API: /Products/search/{name})
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final q = Uri.encodeComponent(query.trim());
      if (q.isEmpty) return [];

      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/Products/search/$q"),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => ProductModel.fromJson(e)).toList();
      }

      // لو السيرفر رجّع 404 معناها مفيش نتائج → رجّع []
      return [];
    } catch (e) {
      print("Search Error: $e");
      return [];
    }
  }
}
