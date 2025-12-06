import 'package:flutter/material.dart';
import '../Payment/add_card.dart';
// تعريف الـ Enum لتحديد طريقة الدفع المختارة
enum PaymentOption { cash, wallet, card }

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  // الحالة لتتبع الخيار المحدد، القيمة الافتراضية هي الدفع نقدًا
  PaymentOption? _selectedOption = PaymentOption.cash;

  // لون الزر الرئيسي (الوردي المشابه للصورة)
  static const Color pinkButtonColor = Color(0xFFF06292);
  // لون أيقونات البطاقة والخطوط
  static const Color cardIconColor = Color(0xFF4C5874);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Payment Methods',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. قسم الدفع النقدي (Cash)
            _buildSectionTitle('Cash'),
            _buildPaymentOption(
              icon: Icons.monetization_on, // أيقونة العملة
              iconColor: Colors.green, // لون مختلف لأيقونة النقد
              title: 'Cash',
              value: PaymentOption.cash,
              onChanged: (val) {
                setState(() {
                  _selectedOption = val;
                });
              },
            ),

            const SizedBox(height: 20),

            // 2. قسم المحفظة/إنستاباي (Wallet Or instapay)
            _buildSectionTitle('Wallet Or instapay: 01234672455'),
            _buildPaymentOption(
              icon: Icons.receipt_long, // أيقونة الإيصال أو المحفظة
              iconColor: cardIconColor,
              title: 'Receipt Number',
              value: PaymentOption.wallet,
              // يتم تمرير دالة فارغة لأن هذا الحقل قد يكون للإدخال وليس فقط اختيار
              onChanged: (val) {
                setState(() {
                  _selectedOption = val;
                });
              },
              isInput: true, // للإشارة إلى أن هذا الحقل هو إدخال نصي
            ),

            const SizedBox(height: 20),

            // 3. قسم بطاقة الائتمان/الخصم (Credit & Debit Card)
            _buildSectionTitle('Credit & Debit Card'),

            // زر "Select Card" (اختيار بطاقة محفوظة)
            _buildCardAction(
                icon: Icons.credit_card,
                title: 'Select Card',
                showDropdown: true,
                onTap: () {
                  setState(() {
                    _selectedOption = PaymentOption.card;
                  });
                  // كود فتح قائمة اختيار البطاقات المحفوظة
                }
            ),
            const SizedBox(height: 10),

            // زر "Add Card" (إضافة بطاقة جديدة)
            _buildCardAction(
                icon: Icons.credit_card,
                title: 'Add Card',
                color: Colors.red[300], // لون النص "Add Card"
                onTap: () {
                  // كود الانتقال إلى شاشة "Add Card"
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCardScreen()));
                }
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),

      // زر تأكيد الدفع الثابت في الأسفل
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              // كود تأكيد الدفع بناءً على _selectedOption
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: pinkButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Confirm Payment',
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء عنوان القسم
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء خيار الدفع (Cash, Wallet)
  Widget _buildPaymentOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    required PaymentOption value,
    required ValueChanged<PaymentOption?> onChanged,
    bool isInput = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          // تظليل الخيار المحدد باللون الوردي الفاتح
            color: _selectedOption == value ? pinkButtonColor.withOpacity(0.5) : Colors.grey[200]!,
            width: 1.5
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: <Widget>[
            Icon(icon, color: iconColor),
            const SizedBox(width: 12),

            Expanded(
              child: isInput
                  ? TextField(
                decoration: InputDecoration(
                  hintText: title,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                keyboardType: TextInputType.number,
              )
                  : Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),

            Radio<PaymentOption>(
              value: value,
              groupValue: _selectedOption,
              onChanged: onChanged,
              activeColor: pinkButtonColor,
            ),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء أزرار البطاقة (Select Card, Add Card)
  Widget _buildCardAction({
    required IconData icon,
    required String title,
    Color? color,
    bool showDropdown = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.grey[100], // لون خلفية خفيف
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: <Widget>[
            Icon(icon, color: cardIconColor),
            const SizedBox(width: 12),

            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: color ?? Colors.black87,
              ),
            ),
            const Spacer(),

            if (showDropdown)
              const Icon(Icons.keyboard_arrow_up, color: cardIconColor, size: 20),
          ],
        ),
      ),
    );
  }
}