import 'package:flutter/material.dart';
import 'package:quiz_app/screens/auth/create_account_step1.dart';
import 'package:quiz_app/widgets/custom_password_field.dart';
import 'package:quiz_app/widgets/custom_text_field.dart';
import 'package:quiz_app/widgets/home_wrapper.dart';
import 'package:quiz_app/widgets/primary_button.dart';
import 'package:quiz_app/widgets/social_button.dart';
import 'package:quiz_app/widgets/divider_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "Sign in",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Hi! Welcome back, you've been missed",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              CustomTextField(label: "Email", controller: emailController),
              const SizedBox(height: 20),

              CustomPasswordField(controller: passwordController),
              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.pink),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              PrimaryButton(
                text: "Sign In",
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', true);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeWrapper()),
                  );
                },
              ),

              const SizedBox(height: 30),
              const DividerText(text: "Or sign in with"),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SocialButton(asset: "assets/icons/google.jpg"),
                  SizedBox(width: 100),
                  SocialButton(asset: "assets/icons/facebook.jpg"),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateAccountStep1(),
                        ),
                      );
                    },
                    child: const Text(
                      "create account",
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
    );
  }
}
