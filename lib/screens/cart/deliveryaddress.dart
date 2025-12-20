import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/address_model.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../Payment/payment_method.dart'; // 👈 استدعاء صفحة الدفع

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  List<AddressModel> _addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    final addresses = await ApiService().getAddresses();
    if (mounted) {
      setState(() {
        _addresses = addresses;
        _isLoading = false;
      });
    }
  }

  void _showAddAddressSheet() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final streetController = TextEditingController();
    final cityController = TextEditingController();
    final postalController = TextEditingController();
    final countryController = TextEditingController();

    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Add New Address", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  CustomTextField(label: 'Name', controller: nameController),
                  const SizedBox(height: 10),
                  CustomTextField(label: 'Phone Number', controller: phoneController, keyboardType: TextInputType.phone),
                  const SizedBox(height: 10),
                  CustomTextField(label: 'City', controller: cityController),
                  const SizedBox(height: 10),
                  CustomTextField(label: 'Street Address', controller: streetController),
                  const SizedBox(height: 10),
                  CustomTextField(label: 'Postal Code', controller: postalController, keyboardType: TextInputType.number),
                  const SizedBox(height: 10),
                  CustomTextField(label: 'Country', controller: countryController),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: isSaving
                        ? const Center(child: CircularProgressIndicator(color: Colors.pink))
                        : PrimaryButton(
                      text: 'SAVE ADDRESS',
                      color: Colors.pink,
                      onPressed: () async {
                        if (cityController.text.isEmpty || streetController.text.isEmpty || postalController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill City, Street and Postal Code")));
                          return;
                        }
                        setModalState(() => isSaving = true);
                        final prefs = await SharedPreferences.getInstance();
                        final userId = prefs.getInt('userId');
                        if (userId != null) {
                          final success = await ApiService().addAddress(
                            userId: userId,
                            city: cityController.text,
                            street: streetController.text,
                            postalCode: postalController.text,
                          );
                          if (success) {
                            Navigator.pop(context);
                            _fetchAddresses();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to add address")));
                          }
                        }
                        setModalState(() => isSaving = false);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Delivery Address', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.pink))
            : _addresses.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 10),
              const Text("No addresses found. Add one!", style: TextStyle(color: Colors.grey)),
            ],
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: _addresses.length,
          itemBuilder: (context, index) {
            final address = _addresses[index];
            // 👇 جعل الكارت قابل للضغط للانتقال للدفع
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // نمرر الـ id الخاص بالعنوان لصفحة الدفع
                    builder: (context) => PaymentMethodsScreen(addressId: address.addressId), // تأكد أن الموديل به id أو addressId
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_on, color: Colors.pink),
                  ),
                  title: Text(address.city, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text("${address.street}, Postal: ${address.postalCode}"),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.pink),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddAddressSheet,
        backgroundColor: Colors.pink,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add New Address", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}