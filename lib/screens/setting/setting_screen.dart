import 'package:flutter/material.dart';
import 'package:quiz_app/screens/help/help_center_screen.dart';
import 'package:quiz_app/screens/setting/notification_setting.dart';
import 'package:quiz_app/screens/setting/password_manage_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLang = "EN"; // -------------------- (اللغة الحالية)

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Setting",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            //---------------------------------------------------------
            // LANGUAGE
            //---------------------------------------------------------
            _settingTile(
              icon: Icons.language,
              title: "Language",
              trailing: InkWell(
                onTap: _openLanguagePicker,
                child: Row(
                  children: [
                    Text(selectedLang, style: TextStyle(fontSize: 16)),
                    const Icon(Icons.arrow_drop_down, color: Colors.black),
                  ],
                ),
              ),
            ),

            _divider(),

            //---------------------------------------------------------
            // HELP CENTER
            //---------------------------------------------------------
            // _settingTile(
            //   icon: Icons.help_outline,
            //   title: "Help Center",
            //   trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primary),
            // ),
            _settingTile(
              icon: Icons.help_outline,
              title: "Help Center",
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primary),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpCenterScreen()),
                );
              },
            ),

            _divider(),

            //---------------------------------------------------------
            // PASSWORD MANAGER
            //---------------------------------------------------------
            _settingTile(
              icon: Icons.lock_outline,
              title: "Password Manager",
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primary),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PasswordManagerScreen(),
                  ),
                );
              },
            ),

            _divider(),

            //---------------------------------------------------------
            // NOTIFICATIONS
            //---------------------------------------------------------
            _settingTile(
              icon: Icons.notifications_none,
              title: "Notifications",
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primary),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationSettingsPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
            Divider(thickness: 1, color: Colors.grey.shade300),
            const SizedBox(height: 16),

            //---------------------------------------------------------
            // DELETE ACCOUNT
            //---------------------------------------------------------
            _settingTile(
              icon: Icons.delete_outline,
              title: "Delete Account",
              titleColor: Colors.red,
              iconColor: Colors.red,
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
              onTap: _showDeleteDialog,
            ),

            const Spacer(),

            const Text(
              "v1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  //---------------------------------------------------------------------------
  // LANGUAGE PICKER BOTTOM SHEET
  //---------------------------------------------------------------------------
  void _openLanguagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_langOption("EN"), const Divider(), _langOption("AR")],
          ),
        );
      },
    );
  }

  Widget _langOption(String lang) {
    return ListTile(
      title: Text(lang, style: const TextStyle(fontSize: 18)),
      trailing: selectedLang == lang
          ? const Icon(Icons.check, color: Colors.pink)
          : null,
      onTap: () {
        setState(() => selectedLang = lang);
        Navigator.pop(context);
      },
    );
  }

  //---------------------------------------------------------------------------
  // DELETE ACCOUNT DIALOG
  //---------------------------------------------------------------------------
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Delete Account",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: const Text(
            "Are you sure you want to delete your account?\nThis action cannot be undone.",
            style: TextStyle(fontSize: 15),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.black87, fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // هنا تعمل بقا كود المسح
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red.shade700, fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  //---------------------------------------------------------------------------
  // UI ELEMENTS
  //---------------------------------------------------------------------------
  Widget _settingTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    Color? titleColor,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? Colors.black54, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: titleColor ?? Colors.black87,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 44),
      child: Divider(thickness: 1, color: Colors.grey.shade300),
    );
  }
}
