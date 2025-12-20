import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_password_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/social_button.dart';
import '../../widgets/divider_text.dart';
import '../home/main_navigation.dart'; // تأكد من المسار
import 'create_account_step1.dart';
import 'forgot_password_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    final user = await ApiService().login(
      emailController.text.trim(),
      passwordController.text,
    );

    setState(() => isLoading = false);

    if (user != null) {
      // حفظ بيانات المستخدم
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user.id);
      await prefs.setString('userName', user.name);
      await prefs.setString('userEmail', user.email);
      await prefs.setString('userImage', user.profileImage ?? "");

      if (mounted) {
        bool isUserAdmin = user.email.toLowerCase() == "admin@flower.com";

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            
            builder: (context) => MainNavigation(isAdmin: isUserAdmin),
          ),
              (route) => false,
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid Email or Password"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_florist, size: 80, color: Colors.pink),
                const SizedBox(height: 20),
                Text(
                  "Sign In",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                ),
                const SizedBox(height: 8),
                const Text("Hi there! Nice to see you again.", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),

                CustomTextField(
                  label: "Email",
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                CustomPasswordField(controller: passwordController),

                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ForgotPasswordScreen())),
                      child: const Text("Forgot Password?", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : PrimaryButton(text: "Sign In", onPressed: _handleLogin),
                ),

                const SizedBox(height: 30),
                const DividerText(text: "Or sign in with"),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SocialButton(asset: "assets/icons/google.jpg"),
                    SizedBox(width: 20),
                    SocialButton(asset: "assets/icons/facebook.jpg"),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const CreateAccountStep1())),
                      child: const Text("Sign Up", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}