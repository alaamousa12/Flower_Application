// import 'package:flutter/material.dart';

// class SpecialOffersPage extends StatelessWidget {
//   const SpecialOffersPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,

//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "Special for You",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),

//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: 4,
//         itemBuilder: (context, index) {
//           return _buildOfferCard();
//         },
//       ),
//     );
//   }

//   Widget _buildOfferCard() {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 12,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),

//       child: Row(
//         children: [
//           // ---------------------------
//           // Left Section (Texts + Button)
//           // ---------------------------
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               mainAxisSize: MainAxisSize.min,

//               children: [
//                 const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Today's Offers",
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),

//                     SizedBox(height: 4),

//                     Text(
//                       "Get Special Offer",
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     SizedBox(height: 4),

//                     Text(
//                       "Up to 20%",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.pink,
//                       ),
//                     ),
//                   ],
//                 ),

//                 // ---- Order Now Button ----
//                 SizedBox(
//                   width: 130,
//                   height: 40,
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.pink,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       padding: EdgeInsets.zero,
//                     ),
//                     child: const Text(
//                       "Order Now",
//                       style: TextStyle(color: Colors.white, fontSize: 15),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(width: 12),

//           // ---------------------------
//           // Right Image Placeholder
//           // ---------------------------
//           ClipRRect(
//             borderRadius: BorderRadius.circular(14),
//             child: Container(
//               width: 115,
//               height: 120, // ← الحل الحقيقي لوقف الـ overflow
//               color: Colors.grey.shade300,
//               child: const Icon(Icons.image, size: 40, color: Colors.white70),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
