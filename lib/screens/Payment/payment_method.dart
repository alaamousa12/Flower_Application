import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/screens/Payment/payment_success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Managers/cart_manager.dart';
import '../../Models/payment_card_model.dart';
import '../../services/api_service.dart';
import '../orders/my_orders_screen.dart';
import 'add_card.dart';

// ✅ Success Page (عدّل المسار حسب مكان الملف عندك)
import 'payment_success.dart';


enum PaymentOption { cash, wallet, card }

class PaymentMethodsScreen extends StatefulWidget {
  final int? addressId;
  const PaymentMethodsScreen({super.key, this.addressId});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  PaymentOption? _selectedOption = PaymentOption.cash;
  List<PaymentCardModel> _cards = [];
  int? _selectedCardId;
  bool _isLoading = true;
  bool _isProcessing = false;

  // ✅ Receipt Number Controller
  final TextEditingController _receiptController = TextEditingController();

  static const Color pinkButtonColor = Color(0xFFF06292);
  static const Color cardIconColor = Color(0xFF4C5874);

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  @override
  void dispose() {
    _receiptController.dispose();
    super.dispose();
  }

  Future<void> _fetchCards() async {
    final cards = await ApiService().getPaymentCards();
    if (!mounted) return;

    setState(() {
      _cards = cards;
      _isLoading = false;
      if (_cards.isNotEmpty && _selectedCardId == null) {
        _selectedCardId = _cards.first.cardId;
      }
    });
  }

  Future<void> _confirmOrder(CartManager cartManager) async {
    if (widget.addressId == null) return;

    // ✅ تحديد طريقة الدفع
    String paymentMethodStr = "Cash";

    if (_selectedOption == PaymentOption.card) {
      if (_selectedCardId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a card")),
        );
        return;
      }
      paymentMethodStr = "Card";
    } else if (_selectedOption == PaymentOption.wallet) {
      if (_receiptController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter receipt number")),
        );
        return;
      }
      paymentMethodStr = "Wallet";
    }

    setState(() => _isProcessing = true);

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId != null) {
      final items = cartManager.cartItems.map((product) {
        return {"productId": product.id, "quantity": 1};
      }).toList();

      final success = await ApiService().createOrder(
        userId: userId,
        addressId: widget.addressId!,
        paymentMethod: paymentMethodStr,
        items: items,
      );

      if (!mounted) return;

      if (success) {
        cartManager.clearCart();

        // ✅ SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Order Created Successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        // ✅ Cash -> Success Screen
        if (_selectedOption == PaymentOption.cash) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const PaymentSuccessfulScreen(
                paymentMethod: "Cash", // ✅ بعتنا نوع الدفع
              ),
            ),
                (route) => false,
          );
        } else {
          // ✅ Card/Wallet -> Orders
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
                (route) => false,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to create order"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartManager>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
              onChanged: (val) => setState(() => _selectedOption = val),
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Wallet Or instapay: 01234672455'),
            _buildPaymentOption(
              icon: Icons.receipt_long,
              iconColor: cardIconColor,
              title: 'Receipt Number',
              value: PaymentOption.wallet,
              onChanged: (val) => setState(() => _selectedOption = val),
              isInput: true,
            ),

            const SizedBox(height: 20),
            _buildSectionTitle('Credit & Debit Card'),
            GestureDetector(
              onTap: () => setState(() => _selectedOption = PaymentOption.card),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: _selectedOption == PaymentOption.card
                      ? Border.all(color: pinkButtonColor, width: 1.5)
                      : null,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.credit_card, color: cardIconColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _isLoading
                          ? const Text("Loading cards...")
                          : _cards.isEmpty
                          ? const Text(
                        "No cards found",
                        style: TextStyle(color: Colors.grey),
                      )
                          : DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _selectedCardId,
                          hint: const Text("Select Card"),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: cardIconColor),
                          items: _cards.map((card) {
                            final last4 = card.cardNumber.length > 4
                                ? card.cardNumber.substring(
                                card.cardNumber.length - 4)
                                : card.cardNumber;
                            return DropdownMenuItem<int>(
                              value: card.cardId,
                              child: Text(
                                "**** $last4 (${card.name})",
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedOption = PaymentOption.card;
                              _selectedCardId = val;
                            });
                          },
                        ),
                      ),
                    ),
                    Radio<PaymentOption>(
                      value: PaymentOption.card,
                      groupValue: _selectedOption,
                      onChanged: (val) => setState(() => _selectedOption = val),
                      activeColor: pinkButtonColor,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            _buildCardAction(
              icon: Icons.add_card,
              title: 'Add New Card',
              color: Colors.red[300],
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCardScreen()),
                );
                _fetchCards();
              },
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
      bottomNavigationBar: widget.addressId == null
          ? null
          : Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed:
            _isProcessing ? null : () => _confirmOrder(cartManager),
            style: ElevatedButton.styleFrom(
              backgroundColor: pinkButtonColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: _isProcessing
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
              'Confirm Order',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
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
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
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
          padding:
          EdgeInsets.symmetric(horizontal: 16.0, vertical: isInput ? 4 : 16),
          child: Row(
            children: <Widget>[
              Icon(icon, color: iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: isInput
                    ? TextField(
                  controller: _receiptController,
                  decoration: InputDecoration(
                    hintText: title,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  keyboardType: TextInputType.number,
                  onTap: () => onChanged(value),
                )
                    : Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, color: Colors.black87),
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
      ),
    );
  }

  Widget _buildCardAction({
    required IconData icon,
    required String title,
    Color? color,
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
          ],
        ),
      ),
    );
  }
}
