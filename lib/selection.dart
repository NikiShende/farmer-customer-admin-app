import 'package:flutter/material.dart';
import 'package:flutter_application_2/admindash.dart';
import 'package:flutter_application_2/customer_dash.dart';
import 'package:flutter_application_2/farmer_dash.dart';
import 'package:flutter_application_2/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/api_service.dart';

class Selection extends StatefulWidget {
  const Selection({super.key});

  @override
  State<Selection> createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  String selectedUserType = 'customer';

   Future<void> login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => isLoading = true);

    final result = await ApiService.login(
      email: email,
      password: password,
      userType: selectedUserType,
    );

    setState(() => isLoading = false);

    if (result['success'] == true) {
      final data = result['data'];
      final user = data[selectedUserType] ?? data['user'] ?? data;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', data['accessToken']);
      await prefs.setString('refreshToken', data['refreshToken']);

      // Optionally save user details
      await prefs.setString('name', user['name'] ?? '');
      await prefs.setString('email', user['email'] ?? '');

      Widget dashboard;
      if (selectedUserType == 'customer') {
        dashboard = CustomerDash(
          name: user['name'], email: user['email'], phone: user['phone'], profileImageUrl: '',
        );
      } else if (selectedUserType == 'farmer') {
        dashboard = FarmerDash(
          name: user['name'], email: user['email'], phone: user['phone'], profileImageUrl: '',
        );
      } else {
        dashboard = AdminDash(
          name: user['name'], email: user['email'], phone: user['phone'], profileImageUrl: '',
        );
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => dashboard));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Login failed')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("./assets/images/bg2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 150,
          width: 700,
          child: const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 110),
              child: Text(
                'WELCOME',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 140),
                DropdownButton<String>(
                  value: selectedUserType,
                  items: const [
                    DropdownMenuItem(value: 'customer', child: Text('Customer')),
                    DropdownMenuItem(value: 'farmer', child: Text('Farmer')),
                    // Uncomment if admin login is enabled
                    // DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedUserType = value!;
                    });
                  },
                ),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Phone/Email",
                    hintStyle:
                        const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.purple, width: 1),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle:
                        const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.purple, width: 1),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  height: 50,
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 17, 90, 19),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11.0),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            print('SIGN IN');
                            await login();
                          },
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      const Text(
                        'Don\'t have an account? ',
                        style: TextStyle(fontSize: 17),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register()));
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
