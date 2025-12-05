import 'package:flutter/material.dart';
import 'package:quiz_app/widgets/custom_text_field.dart';
import 'package:quiz_app/widgets/primary_button.dart';

class DeliveryAddressScreen extends StatelessWidget {
  DeliveryAddressScreen({super.key});

  // Controllers لجمع البيانات من الفورم
  final TextEditingController nameController = TextEditingController(text: '');
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postalController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Delivery Address',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20.0),
                children: [

                  CustomTextField(

                    label: 'Name',
                    controller: nameController,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: 'Phone Number',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: 'Street Address',
                    controller: streetController,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: 'City',
                    controller: cityController,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: 'Postal Code',
                    controller: postalController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: 'Country',
                    controller: countryController,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 30, top: 10),
              child: PrimaryButton(
                text: 'SAVE ADDRESS',
                color: Colors.pink,
                onPressed: () {
                  // هنا تقدر تجمع الداتا وتبعتها للسيرفر أو تخزنها
                  print("Name: ${nameController.text}");
                  print("Phone: ${phoneController.text}");
                  print("Street: ${streetController.text}");
                  print("City: ${cityController.text}");
                  print("PostalCode: ${postalController.text}");
                  print("Country: ${countryController.text}");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
