// import 'package:flutter/material.dart';

// class NotificationSettingsPage extends StatelessWidget {
//   const NotificationSettingsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final Color primaryPink = Colors.pink;

//     return Scaffold(
//       backgroundColor: Colors.white,

//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         centerTitle: true,

//         title: Row(
//           children: [
//             // Back Button
//             IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.black),
//               onPressed: () => Navigator.pop(context),
//             ),

//             const Spacer(),

//             const Text(
//               "Notification Settings",
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.black,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),

//             const Spacer(),

//             // مساحة تعويضية لضبط التمركز
//             const SizedBox(width: 48),
//           ],
//         ),
//       ),

//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               children: [
//                 const SizedBox(height: 10),

//                 // ******** Enable All *********
//                 buildTile(
//                   icon: "🔔",
//                   title: "Enable All Notifications",
//                   subtitle: "Turn on or off all app notifications.",
//                   trailing: Checkbox(
//                     activeColor: primaryPink,
//                     value: false,
//                     onChanged: (_) {},
//                   ),
//                 ),

//                 // ******** Offers *********
//                 buildTile(
//                   icon: "🎉",
//                   title: "Offers & Promotions",
//                   subtitle: "Get updates about new deals and discounts.",
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                 ),

//                 // ******** Orders *********
//                 buildTile(
//                   icon: "📦",
//                   title: "Order Updates",
//                   subtitle:
//                       "Receive alerts when your order is confirmed or shipped.",
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                 ),

//                 // ******** Recommendations *********
//                 buildTile(
//                   icon: "🌸",
//                   title: "Product Recommendations",
//                   subtitle: "Suggestions for similar or trending flowers.",
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                 ),

//                 // ******** Payment *********
//                 buildTile(
//                   icon: "💳",
//                   title: "Payment & Refund Alerts",
//                   subtitle: "Notifications for payments or refunds.",
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                 ),

//                 // ******** Occasions *********
//                 buildTile(
//                   icon: "📅",
//                   title: "Occasion Reminders",
//                   subtitle: "Get reminders for birthdays, anniversaries, etc.",
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                 ),

//                 const SizedBox(height: 20),

//                 // ******** DEVICE SETTINGS *********
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade100,
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 18,
//                         backgroundColor: Colors.pink.withOpacity(0.15),
//                         child: const Text("⚙️", style: TextStyle(fontSize: 20)),
//                       ),
//                       const SizedBox(width: 14),
//                       const Expanded(
//                         child: Text(
//                           "Manage from device settings",
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                       const Icon(Icons.arrow_forward_ios, size: 16),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),

//           // ******** Save Button *********
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: SizedBox(
//               width: double.infinity,
//               height: 52,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryPink,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   "Save",
//                   style: TextStyle(
//                     fontSize: 17,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // -------------------- COMPONENT -----------------------

//   Widget buildTile({
//     required String icon,
//     required String title,
//     required String subtitle,
//     required Widget trailing,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100.withOpacity(0.6),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CircleAvatar(
//             radius: 20,
//             backgroundColor: Colors.pink.withOpacity(0.15),
//             child: Text(icon, style: const TextStyle(fontSize: 20)),
//           ),
//           const SizedBox(width: 12),

//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   subtitle,
//                   style: const TextStyle(fontSize: 13, color: Colors.black54),
//                 ),
//               ],
//             ),
//           ),

//           trailing,
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool enableAll = false;

  @override
  Widget build(BuildContext context) {
    final Color primaryPink = Colors.pink;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            const Spacer(),
            const Text(
              "Notification Settings",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 48),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 10),

                // ******** Enable All *********
                buildTile(
                  icon: "🔔",
                  title: "Enable All Notifications",
                  subtitle: "Turn on or off all app notifications.",
                  trailing: Checkbox(
                    activeColor: primaryPink,
                    value: enableAll,
                    onChanged: (value) {
                      setState(() {
                        enableAll = value ?? false;
                      });
                    },
                  ),
                ),

                buildTile(
                  icon: "🎉",
                  title: "Offers & Promotions",
                  subtitle: "Get updates about new deals and discounts.",
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),

                buildTile(
                  icon: "📦",
                  title: "Order Updates",
                  subtitle:
                      "Receive alerts when your order is confirmed or shipped.",
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),

                buildTile(
                  icon: "🌸",
                  title: "Product Recommendations",
                  subtitle: "Suggestions for similar or trending flowers.",
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),

                buildTile(
                  icon: "💳",
                  title: "Payment & Refund Alerts",
                  subtitle: "Notifications for payments or refunds.",
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),

                buildTile(
                  icon: "📅",
                  title: "Occasion Reminders",
                  subtitle: "Get reminders for birthdays, anniversaries, etc.",
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),

                const SizedBox(height: 20),

                // ******** DEVICE SETTINGS *********
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.pink.withOpacity(0.15),
                        child: const Text("⚙️", style: TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          "Manage from device settings",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          // ******** Save Button *********
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- COMPONENT -----------------------

  Widget buildTile({
    required String icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.pink.withOpacity(0.15),
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),

          trailing,
        ],
      ),
    );
  }
}
