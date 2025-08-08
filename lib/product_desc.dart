import 'package:flutter/material.dart';
import 'package:flutter_application_2/place.dart';

class ProductDesc extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDesc({super.key, required this.product});

  @override
  State<ProductDesc> createState() => _ProductDescState();
}


class _ProductDescState extends State<ProductDesc> {
  late Map<String, dynamic> product;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }



  double _calculateTotal() {
  final price = double.tryParse(product['price'].toString()) ?? 0;
  final delPrice = double.tryParse(product['delprice'].toString()) ?? 0;
  final gst = double.tryParse(product['Gstp'].toString()) ?? 0;
  final discount = double.tryParse(product['Discount'].toString()) ?? 0;

  double subtotal = (price * quantity) + delPrice;
  double gstAmount = subtotal * (gst / 100);
  double discountAmount = subtotal * (discount / 100);

  return subtotal + gstAmount - discountAmount;
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Description'),
        backgroundColor: Colors.green,
      ),
     body: SingleChildScrollView(
  padding: const EdgeInsets.all(10),
  child: Column(
    children: [
      // Product Card
      Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product['image'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? 'Unknown',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          height: 35,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green[100],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  size: 24,
                                  color: Colors.red,
                                ),
                                onPressed: _decrementQuantity,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '$quantity',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  size: 24,
                                  color: Colors.black,
                                ),
                                onPressed: _incrementQuantity,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Price: ₹${product['price'] ?? 0}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 10),
      const Padding(
        padding: EdgeInsets.only(right: 180),
        child: Text('Invoice', style: TextStyle(fontSize: 22)),
      ),

      // Invoice Card
      Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text('Original Price: ₹${(int.tryParse(product['price'].toString()) ?? 0) * quantity}'),
            Text('Delivery Price: ₹${int.tryParse(product['delprice'].toString()) ?? 0}'),
            Text('GST: ${product['Gstp'] ?? 0}%'),
            Text('Discount: ${product['Discount'] ?? 0}%'),
            Text(
              'Total: ₹${_calculateTotal().toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),

            ],
          ),
        ),
      ),

      const SizedBox(height: 15),
      SizedBox(
        height: 50,
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 17, 90, 19),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(11.0)),
          ),
          child: const Text(
            'Proceed',
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontSize: 19,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Place()),
            );
          },
        ),
      ),
    ],
  ),
),

    );
  }
}
