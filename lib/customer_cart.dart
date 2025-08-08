import 'package:flutter/material.dart';
import 'package:flutter_application_2/customer_order.dart';
import 'package:flutter_application_2/order_summary.dart';
import 'package:flutter_application_2/customer_profile.dart';

class CustomerCart extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  
  const CustomerCart(this.cartItems, {Key? key}) : super(key: key);

  @override
  _CustomerCartState createState() => _CustomerCartState();
}

class _CustomerCartState extends State<CustomerCart> {
  late List<Map<String, dynamic>> products;

@override
void initState() {
  super.initState();
   products = List<Map<String, dynamic>>.from(widget.cartItems);

}


  void _incrementQuantity(int index) {
    setState(() {
      products[index]['quantity'] += 1;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (products[index]['quantity'] > 1) {
        products[index]['quantity'] -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Cart title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 60,
              width: 350,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 197, 192, 192),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'My Cart',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(right: 210),
            child: Text(
              'Your orders',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),

          // List of products
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: const Color.fromARGB(255, 197, 192, 192),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        // Product image
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
                              product['image'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),

                        // Product details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Quantity with +/- buttons
                              Row(
                                children: [
                            SizedBox(
                            height: 36,
                            width: 36,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Icon(Icons.remove_circle_outline, size: 20),
                              onPressed: () => _decrementQuantity(index),
                            ),
                          ),


                                  SizedBox(width: 5,),
                                  Text(
                                    '${product['quantity']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(width: 10,),
                                  SizedBox(
                                    height: 25,
                                    width: 36,
                        

                                    child: IconButton(
                                       padding: EdgeInsets.zero,
                                       constraints: BoxConstraints(),
                                      icon: const Icon(Icons.add_circle_outline,size: 20,),
                                      onPressed: () => _incrementQuantity(index),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),
                              Text(
                                'Price: ₹${product['price']}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.green),
                              ),


                              // Inside ListView.builder, add after price Text widget

              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderSummaryScreen(
                            orderedProducts: [products[index]], // single product in list
                          ),
                        ),
                      );
                    },
                    child: Text("Buy Now"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 147, 140, 129),
                    ),
                  ),
                ],
              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              
            ),
          ),
           Container(
                    height: 50,
                    width: 300,
                     child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 17, 90, 19),
                           
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11.0),)
                           ),
          
          
                           child: Text('Place Order',style: TextStyle( color:const Color.fromRGBO(255, 255, 255, 1),fontSize: 19,fontWeight: FontWeight.bold,letterSpacing: 2.0),),
                      
                      onPressed: ()
                     {
                        
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderSummaryScreen(
                              orderedProducts: products, // your cart list
                            ),
                          ),
                        );
                     },),
                   ),
        ],
      ),
    );
  }
}
