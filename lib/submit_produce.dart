import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubmitProduce extends StatefulWidget {
  final String name;

  const SubmitProduce({Key? key, required this.name}) : super(key: key);

  @override
  State<SubmitProduce> createState() => _SubmitProduceState();
}

class _SubmitProduceState extends State<SubmitProduce> {
  // Form fields
  String selectedType = 'Fruit';
  String selectedQuantity = '1';
  String expectedPrice = '';
  File? _imageFile;
  final picker = ImagePicker();

  // Submitted products list
  List<dynamic> farmerProducts = [];

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Fetch farmer products with token auth
  Future<void> fetchFarmerProducts() async {
  final prefs = await SharedPreferences.getInstance();
final token = prefs.getString('token');

if (token == null || token.isEmpty) {
  print('No token found in storage');
  // You might want to redirect user to login
  return;
}

    final url = Uri.parse('http://192.168.188.121:3000/api/getfarmerproducts');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          farmerProducts = json.decode(response.body);
        });
      } else {
        print('Failed to load products, status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  // Submit product to API
 Future<void> submitProduct() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';

  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://192.168.188.121:3000/api/addproduct'),
  );

  request.headers['Authorization'] = 'Bearer $token';
  request.fields['product_type'] = selectedType;
  request.fields['quantity_kg'] = selectedQuantity;
  request.fields['expected_price_per_kg'] = expectedPrice;

  if (_imageFile != null) {
    request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
  }

  var response = await request.send();

  if (response.statusCode == 201) {
    print('Product added successfully');

    // ✅ REFRESH product list after successful addition
    await fetchFarmerProducts();

    // ✅ Optionally show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product added successfully!')),
    );

  } else {
    print('Failed to add product with status: ${response.statusCode}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to add product')),
    );
  }
}


  @override
  void initState() {
    super.initState();
    fetchFarmerProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Produce'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Product',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Product Type dropdown
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: InputDecoration(labelText: 'Product Type'),
              items: ['Fruit', 'Vegetable', 'Grain', 'Other']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),

            SizedBox(height: 10),

            // Quantity dropdown
            DropdownButtonFormField<String>(
              value: selectedQuantity,
              decoration: InputDecoration(labelText: 'Quantity (Kg)'),
              items: ['1', '2', '3', '4', '5']
                  .map((qty) => DropdownMenuItem(value: qty, child: Text(qty)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedQuantity = value!;
                });
              },
            ),

            SizedBox(height: 10),

            // Expected Price input
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Expected Price Per Kg'),
              onChanged: (val) {
                expectedPrice = val;
              },
              initialValue: expectedPrice,
            ),

            SizedBox(height: 10),

            // Pick Image Button
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text(_imageFile == null ? 'Pick Image' : 'Change Image'),
                ),
                SizedBox(width: 10),
                _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : SizedBox.shrink(),
              ],
            ),

            SizedBox(height: 20),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitProduct,
                child: Text('Submit Product'),
                
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ),

            Divider(height: 40),

            Text(
              'Your Submitted Products',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            // List of submitted products in grid
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: farmerProducts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final product = farmerProducts[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        product['image_url'] != null
                            ? Image.network(
                                'http://192.168.188.121:3000/uploads/${product['image_url']}',
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image_not_supported, size: 100),
                        SizedBox(height: 10),
                        Text(
                          product['product_type'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${product['expected_price_per_kg']}/kg',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
