import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pwa_sales2go_flutter/src/features/product/domain/repositories/backoffice_auth_data.dart';

class AuthService {
  final String baseUrl = "https://backoffice.pharospayments.com/api/v2";

  Future<bool> authenticateUser(String email, String password) async {
    final Uri url = Uri.parse('$baseUrl/users/authenticate');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print("pharos backoffice data:");
        print(responseData.toString());
        // Update Singleton with API key, terminal ID, and merchant ID
        BackofficeAuthData().updateFromResponse(responseData);

        print("Login Success - API Key: ${BackofficeAuthData().apiKey}");
        return true;
      } else {
        print("Login Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }
}
