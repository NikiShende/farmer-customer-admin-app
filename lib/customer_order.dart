import 'package:flutter/material.dart';

class CustomerOrder extends StatelessWidget {
  // Sample order data
  final List<Map<String, dynamic>> orders = [
    {
      'orderId': 'ORD001',
      'date': '2025-06-12',
      'status': 'Delivered',
      'total': 350,
      'products': [
        {'name': 'Apple', 'quantity': 2, 'price': 100},
        {'name': 'Banana', 'quantity': 3, 'price': 50},
      ],
    },
    {
      'orderId': 'ORD002',
      'date': '2025-06-10',
      'status': 'Pending',
      'total': 150,
      'products': [
        {'name': 'Orange', 'quantity': 3, 'price': 50},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
       
      AppBar(title: Text('My Orders',style: TextStyle(fontSize: 25),),
      automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text('Order ${order['orderId']}'),
              subtitle: Text('Date: ${order['date']} | Status: ${order['status']}'),
              trailing: Text('₹${order['total']}'),
              onTap: () {
                // Navigate to detailed order view screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsScreen(order: order),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Detailed order page showing products in that order
class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  OrderDetailsScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    final List products = order['products'];
    return Scaffold(
      appBar: AppBar(title: Text('Order ${order['orderId']} Details')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text('Date: ${order['date']}'),
            Text('Status: ${order['status']}'),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    title: Text(product['name']),
                    subtitle: Text('Quantity: ${product['quantity']}'),
                    trailing: Text('₹${product['price'] * product['quantity']}'),
                  );
                },
              ),
            ),
            Divider(),
            Text(
              'Total: ₹${order['total']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
