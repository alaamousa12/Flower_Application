import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const CustomPasswordField({
    super.key,
    required this.controller,
    this.label = "Password",
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: _obscure,
          decoration: InputDecoration(
            filled: true, // خلفية الحقل
            fillColor: Colors.grey.shade200,
            suffixIcon: IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() => _obscure = !_obscure); // تبديل بين إخفاء/إظهار
              },
            ),

            // 🔹 الحواف أثناء التركيز (لما تضغط وتبدأ تكتب)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.pink, width: 2),
            ),

            // 🔹 ممكن تسيبها لو مش عايز حدود دائمة
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}
