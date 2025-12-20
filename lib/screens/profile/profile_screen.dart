import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_text_field.dart';

class UserProfileScreen extends StatefulWidget {
  final bool fromBottomNav;
  const UserProfileScreen({super.key, required this.fromBottomNav});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Controllers
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  String? _selectedGender;
  String? _profileImageUrl; // رابط الصورة من السيرفر
  File? _newImageFile;      // صورة جديدة من الموبايل
  int? _userId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // تحميل البيانات المحفوظة وعرضها
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId');
      nameController.text = prefs.getString('userName') ?? "";
      addressController.text = prefs.getString('userCountry') ?? "";
      phoneController.text = prefs.getString('userPhone') ?? "";
      _selectedGender = prefs.getString('userGender');
      _profileImageUrl = prefs.getString('userImage'); // تحميل الرابط القديم
    });
  }

  // اختيار صورة جديدة
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newImageFile = File(pickedFile.path); // حفظ الصورة الجديدة
      });
    }
  }

  // حفظ التعديلات
  Future<void> _updateProfile() async {
    if (_userId == null) return;
    setState(() => _isLoading = true);

    final updatedUser = await ApiService().updateProfile(
      userId: _userId!,
      name: nameController.text,
      phone: phoneController.text,
      gender: _selectedGender ?? "Male",
      country: addressController.text,
      password: passwordController.text.isNotEmpty ? passwordController.text : null,
      imageFile: _newImageFile, // إرسال الصورة الجديدة لو وجدت
    );

    if (updatedUser != null) {
      // تحديث البيانات في الذاكرة (SharedPreferences)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', updatedUser.name);
      await prefs.setString('userPhone', updatedUser.phoneNumber);
      await prefs.setString('userCountry', updatedUser.country);
      await prefs.setString('userGender', updatedUser.gender);
      if (updatedUser.profileImage != null) {
        await prefs.setString('userImage', updatedUser.profileImage!);
      }

      // تحديث الشاشة
      setState(() {
        _profileImageUrl = updatedUser.profileImage;
        _newImageFile = null; // تفريغ الملف المؤقت لأننا حفظناه خلاص
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Updated Successfully!"), backgroundColor: Colors.green),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile"), backgroundColor: Colors.red),
        );
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // تحديد الصورة التي ستعرض
    ImageProvider? imageProvider;
    if (_newImageFile != null) {
      imageProvider = FileImage(_newImageFile!); // 1. الأولوية للصورة الجديدة
    } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      if (_profileImageUrl!.startsWith('http')) {
        imageProvider = NetworkImage(_profileImageUrl!); // 2. ثم صورة السيرفر
      } else {
        imageProvider = FileImage(File(_profileImageUrl!)); // 3. ثم الملف المحلي القديم
      }
    }

    return Scaffold(
      appBar: widget.fromBottomNav ? null : AppBar(title: const Text("Your Profile"), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // صورة البروفايل
              GestureDetector(
                onTap: _pickImage,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.pink.shade50,
                      backgroundImage: imageProvider,
                      child: imageProvider == null
                          ? const Icon(Icons.person, size: 50, color: Colors.pink)
                          : null,
                    ),
                    const SizedBox(height: 8),
                    const Text("edit image ✏️", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // الحقول
              CustomTextField(label: "Name", controller: nameController),
              const SizedBox(height: 15),
              CustomTextField(label: "Address (Country)", controller: addressController),
              const SizedBox(height: 15),
              CustomTextField(label: "Phone Number", controller: phoneController),

              const SizedBox(height: 15),
              // حقل تغيير الباسورد (اختياري)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Change Password (Optional)", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "New Password",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
              // القائمة المنسدلة للنوع
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
                hint: const Text("Gender"),
                items: ["Male", "Female"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _selectedGender = val),
              ),

              const SizedBox(height: 30),

              // زر التحديث
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("UPDATE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}