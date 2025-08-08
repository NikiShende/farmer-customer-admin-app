
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/product_desc.dart';

class CustomerHome extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddToCart;
  const CustomerHome({Key? key, required this.onAddToCart}) : super(key: key);

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _products = [];
  bool _isSearching = false;
  bool _isLoading = false;

  Future<List<dynamic>> fetchProducts() async {
    final url = Uri.parse('http://192.168.188.121:3000/api/product');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> fetchSearchedProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _isSearching = true;
    });

    try {
      final response = await http.get(
          Uri.parse('http://192.168.188.121:3000/api/search?q=$query'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _products = data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Search failed")),
        );
      }
    } catch (e) {
      print("Error: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Top Scrollable Part
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for products...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        fetchSearchedProducts(value.trim());
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Banner Image
                  Container(
                    height: 180,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/fruit.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Browse Products',
                            style: TextStyle(fontSize: 17)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('View all',
                            style:
                                TextStyle(fontSize: 16, color: Colors.blue)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Product Grid
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: _isSearching
                        ? _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : _products.isEmpty
                                ? Center(child: Text("No products found"))
                                : buildProductGrid(_products)
                        : FutureBuilder<List<dynamic>>(
                            future: fetchProducts(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error loading products'));
                              } else {
                                return buildProductGrid(snapshot.data!);
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductGrid(List<dynamic> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(7),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductDesc(product: product,)),
            );
          },
          child: Card(
            color: Colors.grey[100],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
             child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Image.network(
        product['image'],
        height: 110,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product['name'],
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 4),
          Text("₹${product['price']}"),
          SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.star, size: 14, color: Colors.amber),
              SizedBox(width: 4),
              Text("${product['rating']} (${product['reviews']})"),
            ],
          ),
          SizedBox(height: 6),
          ElevatedButton(
            onPressed: () {
              widget.onAddToCart(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${product['name']} added to cart")),
              );
            },
            child: Text('Add to Cart'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 30),
            ),
          ),
        ],
      ),
    ),
  ],
),

          ),
          



        );
      },
    );
  }
}
