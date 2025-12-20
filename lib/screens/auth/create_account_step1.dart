import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../widgets/custom_password_field.dart'; // تأكد من المسار
import '../../widgets/custom_text_field.dart';     // تأكد من المسار
import 'create_account_step2.dart';

class CreateAccountStep1 extends StatefulWidget {
  const CreateAccountStep1({super.key});

  @override
  State<CreateAccountStep1> createState() => _CreateAccountStep1State();
}

class _CreateAccountStep1State extends State<CreateAccountStep1> {
  // مفتاح الفورم للتحقق
  final _formKey = GlobalKey<FormState>();

  // الكنترولرز
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  // دالة الانتقال للصفحة التالية
  void _onNext() {
    // 1. التحقق من صحة جميع الحقول (بما فيها الباسورد القوي)
    if (_formKey.currentState!.validate()) {

      // 2. التحقق الإضافي: تطابق الباسورد وتأكيده
      if (passwordController.text != confirmController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords do not match"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // 3. الانتقال
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAccountStep2(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form( // 👈 تغليف المحتوى بـ Form
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // شريط التقدم
                  const Center(
                    child: StepProgressIndicator(
                      totalSteps: 2,
                      currentStep: 1,
                      selectedColor: Colors.pink,
                      unselectedColor: Colors.grey,
                      roundedEdges: Radius.circular(10),
                      size: 8,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Center(
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      "Fill your information below or register with your social account",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // حقل الاسم
                  CustomTextField(
                    label: "Full Name",
                    controller: nameController,
                    validator: (val) => val!.isEmpty ? "Name is required" : null,
                  ),
                  const SizedBox(height: 15),

                  // حقل الإيميل
                  CustomTextField(
                    label: "Email Address",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.isEmpty) return "Email is required";
                      if (!val.contains('@')) return "Invalid email address";
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // 👇👇 حقل الباسورد مع شروط القوة 👇👇
                  CustomPasswordField(
                    label: "Password",
                    controller: passwordController,
                    validator: (val) {
                      if (val == null || val.isEmpty) return "Password is required";

                      // شرط الطول
                      if (val.length < 8) return "Must be at least 8 characters";

                      // شرط الحرف الكبير
                      if (!RegExp(r'[A-Z]').hasMatch(val)) {
                        return "Must contain an Uppercase letter (A-Z)";
                      }

                      // شرط الرمز الخاص
                      if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(val)) {
                        return "Must contain a special char (@, #, !, etc.)";
                      }

                      return null; // الباسورد ممتاز ✅
                    },
                  ),
                  const SizedBox(height: 15),

                  // حقل تأكيد الباسورد
                  CustomPasswordField(
                    label: "Confirm Password",
                    controller: confirmController,
                    validator: (val) {
                      if (val == null || val.isEmpty) return "Confirm your password";
                      if (val != passwordController.text) return "Passwords do not match";
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // زر التالي
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // زر تسجيل الدخول
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
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