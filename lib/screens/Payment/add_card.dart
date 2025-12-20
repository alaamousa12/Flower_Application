import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_text_field.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  // Controllers
  final TextEditingController holderController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  bool saveCard = true;
  bool isSaving = false; // متغير للتحميل

  @override
  Widget build(BuildContext context) {
    // استخدمت نفس ألوانك وتصميمك
    const Color primaryColor = Color(0xFF673AB7);
    const SizedBox spacer = SizedBox(height: 16);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Card',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildCreditCard(primaryColor),
            const SizedBox(height: 30),

            CustomTextField(
              label: 'Card Holder Name',
              controller: holderController,
            ),
            spacer,

            CustomTextField(
              label: 'Card Number',
              controller: numberController,
              keyboardType: TextInputType.number,
            ),
            spacer,

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Expiry Date (MM/YY)',
                    controller: expiryController,
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    label: 'CVV',
                    controller: cvvController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Checkbox(
                  value: saveCard,
                  onChanged: (bool? newValue) {
                    setState(() {
                      saveCard = newValue ?? true;
                    });
                  },
                  activeColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Text(
                  'Save Card',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 50),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // 👇👇 المنطق الجديد للحفظ 👇👇
                onPressed: isSaving ? null : () async {
                  // 1. التحقق من الحقول
                  if (holderController.text.isEmpty ||
                      numberController.text.isEmpty ||
                      expiryController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all fields")),
                    );
                    return;
                  }

                  setState(() => isSaving = true);

                  // 2. جلب معرف المستخدم
                  final prefs = await SharedPreferences.getInstance();
                  final userId = prefs.getInt('userId');

                  if (userId != null) {
                    // 3. الاتصال بالسيرفر
                    final success = await ApiService().addPaymentCard(
                      userId: userId,
                      name: holderController.text,
                      cardNumber: numberController.text,
                      expiryDate: expiryController.text,
                    );

                    if (success) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Card Saved Successfully"), backgroundColor: Colors.green),
                        );
                        // 4. الرجوع للصفحة السابقة مع إرسال true لتحديث القائمة
                        Navigator.pop(context, true);
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Failed to save card"), backgroundColor: Colors.red),
                        );
                      }
                    }
                  }
                  if (mounted) setState(() => isSaving = false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                )
                    : const Text(
                  'Add Card',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // الـ Widget الخاصة بتصميم الكارت (كما هي)
  Widget _buildCreditCard(Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Align(
                alignment: Alignment.topRight,
                child: Text(
                  'VISA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                // عرض الرقم المدخل أو رقم افتراضي
                numberController.text.isNotEmpty ? numberController.text : '**** **** **** ****',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Card holder name',
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                      Text(
                        holderController.text.isNotEmpty ? holderController.text : 'YOUR NAME',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Expiry date',
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                      Text(
                        expiryController.text.isNotEmpty ? expiryController.text : 'MM/YY',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.credit_card,
                    color: Colors.white70,
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}