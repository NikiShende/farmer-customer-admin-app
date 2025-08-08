import 'package:flutter/material.dart';
import 'dart:convert';
import 'services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupplyHistory extends StatefulWidget {
  const SupplyHistory({Key? key}) : super(key: key);  // removed farmerId param

  @override
  State<SupplyHistory> createState() => _SupplyHistoryState();
}

class _SupplyHistoryState extends State<SupplyHistory> {
  List<Map<String, dynamic>> _pastSubmissions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSupplyHistory();
  }

  Future<void> fetchSupplyHistory() async {
    setState(() => isLoading = true);

    final response = await ApiService.get(
      '/api/supplyhistory',
      // ApiService.get should internally add the Authorization header with the token
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      setState(() {
        _pastSubmissions = data.map<Map<String, dynamic>>((item) {
          return {
            'name': item['product_name'] ?? 'Unknown',
            'quantity': '${item['quantity_kg'] ?? 0} kg',
            'price': '₹${item['expected_price'] ?? '0'}',
            'status': item['status'] ?? 'Unknown',
            'payment': item['payment_status'] ?? 'Unknown',
          };
        }).toList();
        isLoading = false;
      });
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session expired. Please login again.')),
      );
      setState(() => isLoading = false);
      // TODO: Navigate to login screen if needed
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
      setState(() => isLoading = false);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supply History'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pastSubmissions.isEmpty
              ? const Center(child: Text('No accepted supply items found.'))
              : ListView.builder(
                  itemCount: _pastSubmissions.length,
                  itemBuilder: (context, index) {
                    final item = _pastSubmissions[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item['name'],
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(item['status']).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    item['status'],
                                    style: TextStyle(
                                      color: _getStatusColor(item['status']),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Quantity', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    Text(item['quantity'], style: const TextStyle(fontSize: 15)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Price', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    Text(item['price'], style: const TextStyle(fontSize: 15)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Payment', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    Text(item['payment'], style: const TextStyle(fontSize: 15)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
