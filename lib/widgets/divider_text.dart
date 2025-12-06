import 'package:flutter/material.dart';

class DividerText extends StatelessWidget {
  final String text;
  const DividerText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(text, style: TextStyle(color: Colors.grey.shade700)),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
