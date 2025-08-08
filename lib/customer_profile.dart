import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Customer_Profile extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String profileImageUrl;

  Customer_Profile({
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
  });


  @override
  _Customer_ProfileState createState() => _Customer_ProfileState();
}
class _Customer_ProfileState extends State<Customer_Profile> {
  String name = '';
  String email = '';
  String phone = '';
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    // If data is passed in constructor, use it; otherwise load from SharedPreferences
    if (widget.name != null &&
        widget.email != null &&
        widget.phone != null &&
        widget.profileImageUrl != null) {
      name = widget.name!;
      email = widget.email!;
      phone = widget.phone!;
      profileImageUrl = widget.profileImageUrl!;
    } else {
      loadUserData();
    }
  }
  

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('name') ?? 'No Name';
      email = prefs.getString('email') ?? 'No Email';
      phone = prefs.getString('phone') ?? 'No Phone';
      profileImageUrl = prefs.getString('profileImageUrl') ?? '';
    });
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Center(child: Text('Profile',style: TextStyle(fontSize:29,fontWeight: FontWeight.bold ),)),
        // backgroundColor: Colors.green,
        automaticallyImplyLeading: false, // no back arrow if you want
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 60,
             backgroundImage:
                  profileImageUrl.isNotEmpty ? NetworkImage(profileImageUrl) : null,
              child:
                  profileImageUrl.isEmpty ? Icon(Icons.person, size: 60) : null,
            ),
            const SizedBox(height: 20),

            // Name
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Email
            Row(
              children: [
                const Icon(Icons.email, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Phone
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  phone,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const Spacer(),

            // Edit Profile Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  // Add edit profile logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit Profile tapped')),
                  );
                },
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
