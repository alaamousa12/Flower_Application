import 'package:flutter/material.dart';
import 'package:quiz_app/screens/Payment/payment_success.dart';
import '../Payment/add_card.dart';

// تعريف الـ Enum لتحديد طريقة الدفع المختارة
enum PaymentOption { cash, wallet, card }

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  PaymentOption? _selectedOption = PaymentOption.cash;

  static const Color pinkButtonColor = Color(0xFFF06292);

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
            _buildSectionTitle('Cash'),
            _buildPaymentOption(
              icon: Icons.monetization_on,
              iconColor: Colors.green,
              title: 'Cash',
              value: PaymentOption.cash,
              onChanged: (val) {
                setState(() {
                  _selectedOption = val;
                });
              },
            ),

            const SizedBox(height: 20),

            _buildSectionTitle('Wallet Or instapay: 01234672455'),
            _buildPaymentOption(
              icon: Icons.receipt_long,
              iconColor: cardIconColor,
              title: 'Receipt Number',
              value: PaymentOption.wallet,
              onChanged: (val) {
                setState(() {
                  _selectedOption = val;
                });
              },
              isInput: true,
            ),

            const SizedBox(height: 20),

            _buildSectionTitle('Credit & Debit Card'),

            _buildCardAction(
              icon: Icons.credit_card,
              title: 'Select Card',
              showDropdown: true,
              onTap: () {
                setState(() {
                  _selectedOption = PaymentOption.card;
                });
              },
            ),
            const SizedBox(height: 10),

            _buildCardAction(
              icon: Icons.credit_card,
              title: 'Add Card',
              color: Colors.red[300],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCardScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentSuccessfulScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: pinkButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Confirm Payment',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

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
          color: _selectedOption == value
              ? pinkButtonColor.withOpacity(0.5)
              : Colors.grey[200]!,
          width: 1.5,
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
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
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
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: <Widget>[
            Icon(icon, color: cardIconColor),
            const SizedBox(width: 12),

            Text(
              title,
              style: TextStyle(fontSize: 16, color: color ?? Colors.black87),
            ),
            const Spacer(),

            if (showDropdown)
              const Icon(
                Icons.keyboard_arrow_up,
                color: cardIconColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
