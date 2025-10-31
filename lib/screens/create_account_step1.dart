import 'package:flutter/material.dart';
import 'package:quiz_app/screens/create_account_step2.dart';
import 'package:quiz_app/widgets/custom_password_field.dart';
import 'package:quiz_app/widgets/custom_text_field.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class CreateAccountStep1 extends StatefulWidget {
  const CreateAccountStep1({super.key});

  @override
  State<CreateAccountStep1> createState() => _CreateAccountStep1State();
}

class _CreateAccountStep1State extends State<CreateAccountStep1> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
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
                Center(
                  child: const Text(
                    "Fill your information below or register with your social account",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 22),

                CustomTextField(label: "Full Name", controller: nameController),
                const SizedBox(height: 15),
                CustomTextField(
                  label: "Email Address",
                  controller: emailController,
                ),
                const SizedBox(height: 15),
                CustomPasswordField(
                  label: "Password",
                  controller: passwordController,
                ),
                const SizedBox(height: 15),
                CustomPasswordField(
                  label: "Confirm Password",
                  controller: confirmController,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateAccountStep2(),
                        ),
                      );
                    },
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
    );
  }
}