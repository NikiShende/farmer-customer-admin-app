import 'package:flutter/material.dart';

class OrderSummaryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> orderedProducts;

  OrderSummaryScreen({required this.orderedProducts});

  @override
  Widget build(BuildContext context) {
double totalAmount = 0.0;

for (var product in orderedProducts) {
  var priceRaw = product['price'];
  var quantityRaw = product['quantity'];

  print('Raw price: $priceRaw, Raw quantity: $quantityRaw');

  double price = 0.0;
  int quantity = 0;

  // Parse price
  if (priceRaw is int) {
    price = priceRaw.toDouble();
  } else if (priceRaw is double) {
    price = priceRaw;
  } else if (priceRaw is String) {
    price = double.tryParse(priceRaw) ?? 0.0;
  } else {
    print('Unexpected price type: ${priceRaw.runtimeType}');
  }

  // Parse quantity
  if (quantityRaw is int) {
    quantity = quantityRaw;
  } else if (quantityRaw is String) {
    quantity = int.tryParse(quantityRaw) ?? 0;
  } else {
    print('Unexpected quantity type: ${quantityRaw.runtimeType}');
  }

  print('Parsed price: $price, Parsed quantity: $quantity');

  totalAmount += price * quantity;
}

print('Total amount: $totalAmount');



    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Summary"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: orderedProducts.length,
              itemBuilder: (context, index) {
                final product = orderedProducts[index];
                return ListTile(
                  leading: Image.network(
                    product['image'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product['name']),
                  subtitle: Text('Qty: ${product['quantity']}'),
                  trailing:
                      Text('₹${product['price'] * product['quantity']}'),
                );
              },
            ),
          ),
          const Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '₹$totalAmount',
                      style:
                          const TextStyle(fontSize: 20, color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Order placed successfully!"),
                        ),
                      );
                    },
                    child: const Text(
                      'Confirm Order',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
