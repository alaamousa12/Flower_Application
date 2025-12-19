import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactusScreen extends StatelessWidget {
  const ContactusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Help Center",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle("Support"),

          _buildTile(
            icon: FontAwesomeIcons.phone,
            iconColor: Colors.red,
            title: "Customer Service",
            subtitle: "Call us anytime",
          ),

          _buildTile(
            icon: FontAwesomeIcons.whatsapp,
            iconColor: Colors.green,
            title: "WhatsApp",
            subtitle: "+123 456 7890",
          ),

          _buildTile(
            icon: Icons.email_outlined,
            iconColor: Colors.blue,
            title: "Email",
            subtitle: "support@flowershop.com",
          ),

          _sectionTitle("Social Media"),

          _buildTile(
            icon: FontAwesomeIcons.facebook,
            iconColor: Colors.blue,
            title: "Facebook",
            subtitle: "facebook.com/flowershop",
          ),

          _buildTile(
            icon: FontAwesomeIcons.instagram,
            iconColor: Colors.purple,
            title: "Instagram",
            subtitle: "@flowershop",
          ),

          _sectionTitle("Website"),

          _buildTile(
            icon: FontAwesomeIcons.globe,
            iconColor: Colors.blueGrey,
            title: "Website",
            subtitle: "www.flowershop.com",
            expandedContent: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 10),
              child: Text(
                "www.flowershop.com",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),

          _sectionTitle("Location"),

          _buildTile(
            icon: Icons.location_pin,
            iconColor: Colors.red,
            title: "Address",
            subtitle: "123 Flower Street, Garden City",
          ),
        ],
      ),
    );
  }

  // ---------------- Widgets ----------------

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? expandedContent,
  }) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 10),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
      iconColor: Colors.black,
      collapsedIconColor: Colors.grey,

      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),

      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),

      children: [if (expandedContent != null) expandedContent],
    );
  }
}
