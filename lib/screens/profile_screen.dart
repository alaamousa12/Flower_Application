import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:quiz_app/widgets/custom_text_field.dart';
import 'package:quiz_app/widgets/primary_button.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  String selectedGender = "Male";
  File? profileImage;

  final ImagePicker picker = ImagePicker();

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void onUpdateProfile() {
    debugPrint("Profile Updated!");
  }

  Future<void> pickImage() async {
    final XFile? result = await picker.pickImage(source: ImageSource.gallery);

    if (result != null) {
      setState(() {
        profileImage = File(result.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Your Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  const SizedBox(height: 10),

                  /// -----------------------------
                  /// Profile Image + Upload
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: const Color(0xFFE6E0F8),
                          backgroundImage:
                          profileImage != null ? FileImage(profileImage!) : null,
                          child: profileImage == null
                              ? const Icon(Icons.person_outline,
                              size: 80, color: Color(0xFF7B66FF))
                              : null,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: pickImage,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Edit Image',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(Icons.edit,
                                  size: 18, color: Colors.black54),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// -----------------------------
                  /// FORM FIELDS

                  CustomTextField(
                    label: 'Name',
                    controller: nameController,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: 'Address',
                    controller: addressController,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: 'Phone Number',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

                  /// -----------------------------
                  /// GENDER DROPDOWN (برا الـ CustomTextField)
                  Text(
                    "Gender",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: DropdownButton<String>(
                      value: selectedGender,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: "Male", child: Text("Male")),
                        DropdownMenuItem(value: "Female", child: Text("Female")),
                        DropdownMenuItem(value: "Other", child: Text("Other")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  CustomTextField(
                    label: 'Email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            /// -----------------------------
            /// UPDATE BUTTON
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 30, top: 10),
              child: PrimaryButton(
                text: 'UPDATE',
                onPressed: onUpdateProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
