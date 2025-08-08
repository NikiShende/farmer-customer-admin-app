import 'package:flutter/material.dart';
import 'package:flutter_application_2/customer_cart.dart';
import 'package:flutter_application_2/customer_home.dart';
import 'package:flutter_application_2/customer_order.dart';
import 'package:flutter_application_2/customer_profile.dart';
import 'package:flutter_application_2/selection.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // home: CustomerDash(),
  ));
}

class CustomerDash extends StatefulWidget {


   final String name;
  final String email;
  final String phone;
  final String profileImageUrl;

  const CustomerDash({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  _CustomerDashState createState() => _CustomerDashState();
}

class _CustomerDashState extends State<CustomerDash> {
  int _currentIndex = 0;
List<Map<String, dynamic>> _cartItems = [];
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
     CustomerHome(onAddToCart: _addToCart),
      CustomerCart(_cartItems),
      CustomerOrder(),
      Customer_Profile(
        name: widget.name,
        email: widget.email,
        phone: widget.phone,
        profileImageUrl: widget.profileImageUrl,
      ),
    ];
  }

  void _addToCart(Map<String, dynamic> product) {
  setState(() {
    final existingIndex = _cartItems.indexWhere((item) => item['name'] == product['name']);
    if (existingIndex != -1) {
      _cartItems[existingIndex]['quantity'] += 1;
    } else {
      _cartItems.add({
        'name': product['name'],
        'price': product['price'],
        'image': product['image'],
        'quantity': 1,
      });
    }
  });
}

  void _onDrawerItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Dashboard'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Welcome!',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => _onDrawerItemTap(0),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Cart'),
              onTap: () => _onDrawerItemTap(1),
            ),
            ListTile(
              leading: Icon(Icons.receipt_long),
              title: Text('My Orders'),
              onTap: () => _onDrawerItemTap(2),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () => _onDrawerItemTap(3),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>Selection(),
                    ),
                  );
                // You can handle logout here, maybe navigate to login screen
              },
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'My Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

