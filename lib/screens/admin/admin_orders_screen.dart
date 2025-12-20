import 'package:flutter/material.dart';
import '../../Models/admin_order_model.dart';
import '../../services/api_service.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  bool _loading = true;
  List<AdminOrderModel> _orders = [];

  final _statuses = const ["Pending", "Processing", "Shipped", "Delivered", "Cancelled"];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await ApiService().getAllOrdersAdmin();
    if (!mounted) return;
    setState(() {
      _orders = data;
      _loading = false;
    });
  }

  Future<void> _changeStatus(AdminOrderModel o, String newStatus) async {
    final oldStatus = o.status;

    // optimistic update
    setState(() {
      _orders = _orders.map((e) => e.id == o.id ? e.copyWith(status: newStatus) : e).toList();
    });

    final ok = await ApiService().updateOrderStatus(o.id, newStatus);

    if (!ok && mounted) {
      // rollback
      setState(() {
        _orders = _orders.map((e) => e.id == o.id ? e.copyWith(status: oldStatus) : e).toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update status"), backgroundColor: Colors.red),
      );
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order #${o.id} updated ✅")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Admin Orders", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _load,
        child: _orders.isEmpty
            ?  ListView(
          children: const[
            SizedBox(height: 200),
            Center(child: Text("No orders found")),
          ],
        )
            : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _orders.length,
          separatorBuilder: (_, __) => const Divider(height: 16),
          itemBuilder: (context, i) {
            final o = _orders[i];

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order #${o.id}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      DropdownButton<String>(
                        value: o.status,
                        underline: const SizedBox(),
                        items: _statuses
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (v) {
                          if (v == null || v == o.status) return;
                          _changeStatus(o, v);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("UserId: ${o.userId}", style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 6),
                  Text("Items: ${o.itemsCount}   |   Payment: ${o.paymentMethod}",
                      style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 6),
                  Text("Total: \$${o.totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text("Date: ${o.orderDate.toLocal()}",
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
