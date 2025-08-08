// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000'; // Replace with your IP for real devices

  // 🔐 GET request with token
  static Future<http.Response> get(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken'); // ✅ match key with what you used in login

    if (token == null || token.isEmpty) {
      print('❌ No token found in SharedPreferences');
      return http.Response(jsonEncode({'message': 'Unauthorized'}), 401);
    }

    final url = Uri.parse('$baseUrl$endpoint');
    print('🔐 Sending GET request to: $url');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('⬅️ Response ${response.statusCode}: ${response.body}');
    return response;
  }

  // 🟢 Login Function
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String userType,
  }) async {
    final url = Uri.parse('$baseUrl/api/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'userType': userType,
        }),
      );

      print('Login response: ${response.body}');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return {
          'success': true,
          'data': decoded,
        };
      } else {
        final decoded = jsonDecode(response.body);
        return {
          'success': false,
          'message': decoded['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Network error',
      };
    }
  }
}
