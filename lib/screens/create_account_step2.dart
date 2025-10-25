import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:quiz_app/widgets/custom_text_field.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'create_account_step1.dart';

class CreateAccountStep2 extends StatefulWidget {
  const CreateAccountStep2({super.key});

  @override
  State<CreateAccountStep2> createState() => _CreateAccountStep2State();
}

class _CreateAccountStep2State extends State<CreateAccountStep2> {
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  String? _selectedGender;
  File? _profileImage;

  // 📸 دالة اختيار الصورة من الجهاز
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _finishAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("✅ Account Created"),
        content: const Text("Your account has been created successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
            child: const Text("Go to Home"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backflower.jpg"), // ضع مسار الصورة هنا
            fit: BoxFit.fill, // يملأ الشاشة ويحتفظ بنسبة الصورة
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // 🔹 Step Indicator (2 خطوات)
                  Center(
                    child: StepProgressIndicator(
                      totalSteps: 2,
                      currentStep: 2, // لأننا في الخطوة الثانية
                      selectedColor: Colors.pink,
                      unselectedColor: Colors.grey.shade300,
                      roundedEdges: const Radius.circular(10),
                      size: 8,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🔹 Profile Image
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: _profileImage == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey,
                                )
                              : null,
                        ),

                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: InkWell(
                            onTap: _pickImage,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.pink,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🔹 Phone Field
                  Text(
                    "Phone Number",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: Colors.pink,
                        size: 28,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.pink, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        // borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Gender Dropdown Field
                  Text(
                    "Gender",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.pink,
                          width: 2,
                        ), // لون الحواف عند التركيز
                      ),
                    ),
                    hint: const Text("Select Gender"),
                    items: const [
                      DropdownMenuItem(value: "Male", child: Text("Male")),
                      DropdownMenuItem(value: "Female", child: Text("Female")),
                      DropdownMenuItem(value: "Other", child: Text("Other")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.pink),
                    isExpanded: true,
                  ),

                  const SizedBox(height: 15),

                  // 🔹 Address Field
                  CustomTextField(
                    label: "Address",
                    controller: addressController,
                  ),

                  const SizedBox(height: 40),

                  // 🔹 Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CreateAccountStep1(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(
                              color: Colors.pink,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Back",
                            style: TextStyle(fontSize: 18, color: Colors.pink),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _finishAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Finish",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
