import 'package:flutter/material.dart';
import 'package:quiz_app/screens/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/onboarding_list.dart';
import '../widgets/onboarding_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController =
      PageController(); // يتحكم في الـ PageView
  int _currentIndex = 0;

  Future<void> _completeOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('onboarding', false);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SigninScreen()),
      );
    }
  }

  void _nextPage() {
    if (_currentIndex < onboardingList.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut, //تُستخدم لتحديد شكل (منحنى)
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: onboardingList.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                final item = onboardingList[index];
                return OnboardingItem(
                  image: item.image,
                  title1: item.title1,
                  title2: item.title2,
                  desc: item.desc,
                );
              },
            ),

            if (_currentIndex < onboardingList.length - 1)
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      onboardingList.length - 1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingList.length,
                      (dotIndex) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        height: 8,
                        width: _currentIndex == dotIndex ? 16 : 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == dotIndex
                              ? Colors.pink
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (_currentIndex < onboardingList.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: _nextPage,
                          child: const CircleAvatar(
                            backgroundColor: Colors.pink,
                            radius: 28,
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: _completeOnboarding,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Let's Get Started",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
