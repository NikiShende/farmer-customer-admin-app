import 'package:flutter/material.dart';

class AdminDash extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String profileImageUrl;

  const AdminDash({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: profileImageUrl.isNotEmpty
                  ? NetworkImage(profileImageUrl)
                  : AssetImage('assets/images/default_profile.png') as ImageProvider,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome, $name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Email: $email', style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text('Phone: $phone', style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),
            // Add admin-specific options/buttons here
            ElevatedButton(
              onPressed: () {
                // Example admin action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Admin action triggered!')),
                );
              },
              child: Text('Manage Users'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Log out and navigate back to login screen
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
