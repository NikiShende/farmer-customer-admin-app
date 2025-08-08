import 'package:flutter/material.dart';
import 'package:flutter_application_2/submit_produce.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' // ✅ Needed for File
;
class Addproduct extends StatefulWidget {
  const Addproduct({super.key});

  @override
  State<Addproduct> createState() => _AddproductState();
  
}

class _AddproductState extends State<Addproduct> {
  String selectedType = 'Fruit';
  String selectedQuantity = '1';
  String expectedPrice = '';
  File? _imageFile;

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
  Future<void> submitProduct({
  required String type,
  required String quantity,
  required String expectedPrice,
  required File? imageFile,
  required String farmerName,
}) async {
  var uri = Uri.parse('http://192.168.188.121:3000/api/addproduct'); // Replace with actual IP

  var request = http.MultipartRequest('POST', uri);
  request.fields['product_type'] = type;
  request.fields['quantity_kg'] = quantity;
  request.fields['expected_price_per_kg'] = expectedPrice;
  request.fields['farmer_name'] = farmerName;

  if (imageFile != null) {
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
  }

  var response = await request.send();

  if (response.statusCode == 201) {
    print('Product submitted successfully');
  } else {
    print('Failed to submit product');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text('Product Details'),
        backgroundColor: const Color.fromARGB(255, 75, 183, 58)

      ),
      body: SafeArea(
        child: SingleChildScrollView( // ✅ To avoid overflow
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20,),
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Submit Produce Details',
                        style:
                            TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                
                      Text('Type'),
                      DropdownButton<String>(
                        value: selectedType,
                        isExpanded: true,
                        items: ['Fruit', 'Vegetable'].map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedType = value!;
                          });
                        },
                      ),
                
                      SizedBox(height: 10),
                
                      Text('Quantity (kg)'),
                      DropdownButton<String>(
                        value: selectedQuantity,
                        isExpanded: true,
                        items: ['1', '5', '10', '20', '50'].map((qty) {
                          return DropdownMenuItem(
                            value: qty,
                            child: Text('$qty kg'),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedQuantity = value!;
                          });
                        },
                      ),
                
                      SizedBox(height: 15),
                
                      Text('Expected Price per kg'),
                      SizedBox(height: 5),
                      TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          expectedPrice = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter price (₹)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                
                      SizedBox(height: 10),
                
                      ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Upload Image'),
                      ),
                
                      if (_imageFile != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            'Selected: ${_imageFile!.path.split('/').last}',
                            style:
                                TextStyle(fontSize: 14, color: Colors.green[700]),
                          ),
                        ),
                
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                             if (expectedPrice.isNotEmpty) {
                          submitProduct(
                            type: selectedType,
                            quantity: selectedQuantity,
                            expectedPrice: expectedPrice,
                            imageFile: _imageFile,
                            farmerName: "Nikita", // Or use widget.name if passed from previous screen
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please fill all required fields')),
                          );
                        }
                          },
                          child: Text('Submit'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
