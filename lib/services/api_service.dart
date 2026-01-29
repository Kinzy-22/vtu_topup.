import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.113:8000/api';

  static Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
      );

      print('Register API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('name', data['user']['name'] ?? 'User');
        await prefs.setString('email', data['user']['email'] ?? '');
        await prefs.setString(
          'balance',
          data['user']['balance']?.toString() ?? '₦0',
        );
        return true;
      } else {
        print('Error: Registration failed - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error in register: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {"name": name, "email": email, "password": password},
      );

      print('SignUp API Response: ${response.statusCode} - ${response.body}');
      return json.decode(response.body);
    } catch (e) {
      print('Error in signUp: $e');
      return {'error': 'Request failed: $e'};
    }
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'email': email, 'password': password},
      );

      print('Login API Response: ${response.statusCode} - ${response.body}');

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('name', data['user']['name'] ?? 'User');
        await prefs.setString('email', data['user']['email'] ?? '');
        await prefs.setString(
          'balance',
          data['user']['balance']?.toString() ?? '₦0',
        );

        // ✅ Save user ID
        await prefs.setInt('user_id', data['user']['id']);
      }
      return data;
    } catch (e) {
      print('Error in login: $e');
      return {'error': 'Request failed: $e'};
    }
  }

  static Future<Map<String, dynamic>> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/logout"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Logout API Response: ${response.statusCode} - ${response.body}');
      return json.decode(response.body);
    } catch (e) {
      print('Error in logout: $e');
      return {'error': 'Request failed: $e'};
    }
  }

  static Future<Map<String, dynamic>> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print('Error: No token found in SharedPreferences');
      return {'status': false, 'message': 'No token found'};
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('User API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = data['user'];

        await prefs.setString('name', user['name'] ?? 'User');
        await prefs.setString('email', user['email'] ?? '');
        await prefs.setString('balance', user['balance']?.toString() ?? '₦0');

        return {'status': true, 'user': user};
      } else {
        print('Error: Failed to fetch user data - ${response.body}');
        return {'status': false, 'message': 'Failed to fetch user data'};
      }
    } catch (e) {
      print('Error in getUser: $e');
      return {'status': false, 'message': 'Request failed: $e'};
    }
  }

  /// Fund wallet API call
  static Future<bool> fundWallet(
    int amount, {
    required String paymentMethod,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print('No token found');
        return false;
      } else {
        print(token);
      }

      final url = Uri.parse('$baseUrl/fund-wallet');
      final body = {
        'amount': amount.toString(),
        'payment_method': paymentMethod,
        'card_number': cardNumber ?? '',
        'expiry_date': expiryDate ?? '',
        'cvv': cvv ?? '',
      };

      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['message']);
        print(data['success']);
        return data;
      } else {
        print("Funding failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error funding wallet: $e");
      return false;
    }
  }
}
