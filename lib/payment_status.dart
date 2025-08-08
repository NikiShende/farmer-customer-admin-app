import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PaymentStatusScreen(),
    );
  }
}

// Data model for a payment item
class PaymentItem {
  final String itemName;
  final int acceptedQuantity;
  final double finalPrice;
  final String paymentStatus;
  final String? paymentDate; // Nullable as it's only if paid

  PaymentItem({
    required this.itemName,
    required this.acceptedQuantity,
    required this.finalPrice,
    required this.paymentStatus,
    this.paymentDate,
  });
}

class PaymentStatusScreen extends StatefulWidget {
  const PaymentStatusScreen({Key? key}) : super(key: key);

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  // Dummy data for demonstration based on the image
  List<PaymentItem> _paymentItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPayments(); // Call API on screen load
  }

  Future<void> _fetchPayments() async {
    final url = Uri.parse('http://192.168.188.121:3000/api/payments?farmer_name=Nikita');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          _paymentItems = data.map((item) => PaymentItem(
            itemName: item['item_name'],
            acceptedQuantity: item['accepted_quantity'],
            finalPrice: double.parse(item['final_price'].toString()),
            paymentStatus: item['payment_status'],
            paymentDate: item['payment_date'] == 'N/A' ? null : item['payment_date'],
          )).toList();
          _isLoading = false;
        });
      } else {
        print('Failed to load payments: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching payments: $e');
      setState(() {
        _isLoading = false;
      });
    }

  // Helper to get color for payment status
 
  }
   Color _getPaymentStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Seop': // As per image
        return Colors.blue; // Example color for 'Seop'
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press, e.g., Navigator.pop(context);
          },
        ),
        title: const Text('Payment Status'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // Handle profile icon press
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu), // Menu icon as seen in the image
            onPressed: () {
              // Handle menu options
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body:  _isLoading
    ? const Center(child: CircularProgressIndicator())
    : _paymentItems.isEmpty
        ? const Center(child: Text('No payment data found.'))
        :Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: const Row(
              children: [
                SizedBox(width: 24), // For checkbox/leading space
                Expanded(
                  flex: 3,
                  child: Text(
                    'Item Name',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Accepted Quantity',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Final Price (Total ₹)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Payment Date',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          // List of payment items
          Expanded(
            child: ListView.builder(
              itemCount: _paymentItems.length,
              itemBuilder: (context, index) {
                final item = _paymentItems[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_box_outline_blank, // Placeholder for checkbox
                            size: 18,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: Text(
                              item.itemName,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.acceptedQuantity.toString(),
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '₹${item.finalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  item.paymentStatus,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getPaymentStatusColor(item.paymentStatus),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.paymentDate ?? 'N/A', // Display 'N/A' if date is null (pending)
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey[200]),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}