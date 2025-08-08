import 'package:flutter/material.dart';
import 'package:flutter_application_2/suppply_history.dart';
import 'package:flutter_application_2/payment_status.dart';
import 'submit_produce.dart'; 
import 'rejected.dart';

class FarmerDash extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String profileImageUrl;

  const FarmerDash({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  _FarmerDashState createState() => _FarmerDashState();
}

class _FarmerDashState extends State<FarmerDash> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      SubmitProduce(name: widget.name),
      const SupplyHistory(),  // NO farmerId param
      const PaymentStatusScreen(),
      // Rejected(farmerName: widget.name), // Uncomment if needed
    ];
  }

  void _onDrawerItemTap(int index) {
    setState(() => _currentIndex = index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Dashboard'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.name),
              accountEmail: Text(widget.email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: widget.profileImageUrl.isNotEmpty
                    ? NetworkImage(widget.profileImageUrl)
                    : const AssetImage("assets/images/default_avatar.png") as ImageProvider,
              ),
              decoration: const BoxDecoration(color: Colors.green),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home (Submit Produce)'),
              onTap: () => _onDrawerItemTap(0),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('View Supply History'),
              onTap: () => _onDrawerItemTap(1),
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Payment Status'),
              onTap: () => _onDrawerItemTap(2),
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Rejected'),
              onTap: () => _onDrawerItemTap(3),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // TODO: Add your logout logic here
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
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payments'),
          BottomNavigationBarItem(icon: Icon(Icons.cancel), label: 'Rejected'),
        ],
      ),
    );
  }
}
