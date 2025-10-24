import 'package:flutter/material.dart';

class OnboardingItem extends StatelessWidget {
  final String image;
  final String title1;
  final String title2;
  final String desc;

  const OnboardingItem({
    super.key,
    required this.image,
    required this.title1,
    required this.title2,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        // الجزء العلوي (الصورة)
        Container(
          height: size.height * 0.50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          ),
        ),

        // الجزء السفلي (النصوص)
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "$title1 ",
                        style: const TextStyle(color: Colors.pink),
                      ),
                      TextSpan(text: title2),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
