import 'package:flutter/material.dart';
import '../contactus//contactus_screen.dart';

// 📌 شاشة مركز المساعدة الرئيسية
class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);

    // 👇 لما المستخدم يختار تاب Contact Us → افتح شاشة جديدة
    tabController.addListener(() {
      if (tabController.index == 1) {
        // رجّع التاب على FAQ بدل ما يفضل واقف على Contact Us
        tabController.index = 0;

        // فتح شاشة Contact Us
        Future.delayed(Duration.zero, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ContactusScreen(),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Help Center',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'FAQ'),
            Tab(text: 'Contact Us'),
          ],
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // 📌 TabBarView هيعرض الـ FAQ بس
      body: TabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          FaqTab(),
          SizedBox(), // فاضي… لأن التاب دا هيفتح شاشة تانية
        ],
      ),
    );
  }
}

// -------------------------------------
// 📌 علامة تبويب الأسئلة الشائعة (FAQ)
// -------------------------------------

class FaqTab extends StatelessWidget {
  const FaqTab({super.key});

  final List<Map<String, String>> faqList = const [
    {
      'question': 'Can I track my order\'s delivery status?',
      'answer':
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
    },
    {
      'question': 'Is there a return policy?',
      'answer': 'Yes, we have a 30-day return policy for most items.',
    },
    {
      'question': 'Can I save my favorite items for later?',
      'answer': 'Absolutely! Use the "Wishlist" feature to save items.',
    },
    {
      'question': 'Can I share products with my friends?',
      'answer': 'Yes, you can share products via social media or email.',
    },
    {
      'question': 'How do I contact customer support?',
      'answer':
      'You can contact us via live chat, email, or phone. See the Contact Us tab for details.',
    },
    {
      'question': 'What payment methods are accepted?',
      'answer':
      'We accept Visa, Mastercard, PayPal, and Cash on Delivery (where available).',
    },
    {
      'question': 'How to add review?',
      'answer':
      'You can add a review on the product page after purchasing an item.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Search',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // خيارات التصفية
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  CustomFilterChip(
                    label: 'All',
                    selected: true,
                    selectedColor: Colors.black,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  CustomFilterChip(label: 'Services'),
                  SizedBox(width: 8),
                  CustomFilterChip(label: 'General'),
                  SizedBox(width: 8),
                  CustomFilterChip(label: 'Account'),
                ],
              ),
            ),
          ),

          // قائمة FAQ
          ...faqList.map((faq) {
            return Column(
              children: [
                ExpansionTile(
                  title: Text(
                    faq['question']!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 16.0),
                      child: Text(
                        faq['answer']!,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 1, thickness: 0.5),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}

// -------------------------------------
// 📌 ويدجت CustomFilterChip
// -------------------------------------

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color selectedColor;
  final TextStyle labelStyle;

  const CustomFilterChip({
    required this.label,
    this.selected = false,
    this.selectedColor = Colors.grey,
    this.labelStyle = const TextStyle(color: Colors.black),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: selected ? labelStyle : null),
      backgroundColor: selected ? selectedColor : Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}