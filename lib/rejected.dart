import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_2/services/api_service.dart';

class Rejected extends StatefulWidget {
  const Rejected({Key? key}) : super(key: key); // ⛔ No farmerName/farmerId anymore

  @override
  State<Rejected> createState() => _RejectedState();
}

class _RejectedState extends State<Rejected> {
  List<dynamic> rejectedItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRejectedItems();
  }

  Future<void> fetchRejectedItems() async {
    setState(() => isLoading = true);

    final response = await ApiService.get('/api/getrejected');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (!mounted) return;
      setState(() {
        rejectedItems = data;
        isLoading = false;
      });
    } else {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejected Items'),
        backgroundColor: Colors.red[700],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : rejectedItems.isEmpty
              ? const Center(child: Text('No rejected items found.'))
              : ListView.builder(
                  itemCount: rejectedItems.length,
                  itemBuilder: (context, index) {
                    final item = rejectedItems[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(item['product_name'] ?? 'Unknown Product'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quantity: ${item['quantity_kg']} kg'),
                            Text('Expected Price: ₹${item['expected_price']}'),
                            Text('Payment Status: ${item['payment_status']}'),
                            Text('Rejected on: ${item['decided_at'] ?? item['created_at'] ?? 'N/A'}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
