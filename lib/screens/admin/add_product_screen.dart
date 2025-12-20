import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../auth/signin_screen.dart'; // للخروج
import '../../Models/category_model.dart'; // 👈 استدعاء الموديل

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  final qtyController = TextEditingController();

  File? _selectedImage;
  bool _isLoading = false;

  // 👇 متغيرات الأقسام الديناميكية
  List<CategoryModel> _categories = [];
  int? _selectedCategoryId; // جعلناه Nullable عشان ننتظر التحميل
  bool _isCategoriesLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // جلب الأقسام عند فتح الصفحة
  }

  // دالة جلب الأقسام من الـ API
  Future<void> _fetchCategories() async {
    final categories = await ApiService().getCategories();
    if (mounted) {
      setState(() {
        _categories = categories;
        _isCategoriesLoading = false;
        // اختيار أول قسم افتراضياً إذا كانت القائمة غير فارغة
        if (_categories.isNotEmpty) {
          _selectedCategoryId = _categories[0].id;
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _submitProduct() async {
    // التحقق من المدخلات
    if (_selectedImage == null ||
        nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        _selectedCategoryId == null) {

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields, select category and image"))
      );
      return;
    }

    setState(() => _isLoading = true);

    // استدعاء دالة إضافة المنتج في الـ ApiService
    final success = await ApiService().addProduct(
      name: nameController.text,
      description: descController.text,
      price: double.tryParse(priceController.text) ?? 0.0,
      quantity: int.tryParse(qtyController.text) ?? 1,
      categoryId: _selectedCategoryId!, // نرسل الـ ID المختار
      imagePath: _selectedImage!.path,
    );

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Product Added Successfully!"), backgroundColor: Colors.green)
        );
        // تفريغ الحقول بعد النجاح
        nameController.clear();
        priceController.clear();
        descController.clear();
        qtyController.clear();
        setState(() => _selectedImage = null);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to add product"), backgroundColor: Colors.red)
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // زر تسجيل الخروج
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SigninScreen())
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Add New Product", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // اختيار الصورة
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(_selectedImage!, fit: BoxFit.cover),
                )
                    : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("Tap to upload product image", style: TextStyle(color: Colors.grey))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            CustomTextField(label: "Product Name", controller: nameController),
            const SizedBox(height: 15),
            CustomTextField(label: "Price", controller: priceController, keyboardType: TextInputType.number),
            const SizedBox(height: 15),
            CustomTextField(label: "Description", controller: descController),
            const SizedBox(height: 15),
            CustomTextField(label: "Quantity", controller: qtyController, keyboardType: TextInputType.number),

            const SizedBox(height: 20),

            // 👇👇 القائمة المنسدلة الديناميكية 👇👇
            _isCategoriesLoading
                ? const Center(child: CircularProgressIndicator()) // لودينج أثناء جلب الأقسام
                : _categories.isEmpty
                ? const Text("No categories found. Please add via API.")
                : DropdownButtonFormField<int>(
              value: _selectedCategoryId,
              decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.grey.shade200
              ),
              // تحويل قائمة الـ CategoryModel إلى DropdownMenuItem
              items: _categories.map((category) {
                return DropdownMenuItem<int>(
                  value: category.id,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedCategoryId = val),
              hint: const Text("Select Category"),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : PrimaryButton(text: "Upload Product", onPressed: _submitProduct),
            ),
          ],
        ),
      ),
    );
  }
}