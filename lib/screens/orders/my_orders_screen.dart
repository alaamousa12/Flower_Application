import 'package:flutter/material.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,

        title: Row(
          children: [
            // BACK BUTTON
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),

            const Spacer(),

            const Text(
              "My Orders",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            const SizedBox(width: 48), // balancing for back icon spacing
          ],
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // TABS
          Container(
            color: Colors.white,
            child: TabBar(
              controller: tabController,
              indicatorColor: Colors.pink,
              labelColor: Colors.pink,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,

              tabs: const [
                Tab(text: "Active"),
                Tab(text: "Completed"),
                Tab(text: "Cancelled"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // TAB CONTENT
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [
                Center(child: Text("Active Orders")),
                Center(child: Text("Completed Orders")),
                Center(child: Text("Cancelled Orders")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
