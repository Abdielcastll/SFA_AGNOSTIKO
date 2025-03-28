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

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.isEmpty) {
          return false;
        }
        // Update Singleton with API key, terminal ID, and merchant ID
        BackofficeAuthData().updateFromResponse(responseData);

        return true;
      } else {
        print("Pharos login Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

  Future<bool> authenticateUserBySerialNumber(String serialNumber) async {
    final Uri url = Uri.https(
      'bankaool.pharospayments.com',
      '/api/v2/users/authenticate_by_serial',
      {'serial_number': "NEBC00040368"},
    );
    try {
      print("try serial");
      print(url);
      final response = await http.post(
        url,
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Im5lY3MgbWV0YSBhcHAiLCJjb21wYW55IjoibmVjcyIsImFkbWluIjp0cnVlLCJpYXQiOjE1MTYyMzkwMjJ9.SJjwjp1h5TlzmaXsF89H8iDqF6bjzOMbv1zNnXfRORI'
        },
      );
      print("try response:");
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        // Update Singleton with API key, terminal ID, and merchant ID
        BackofficeAuthData().updateFromResponse(responseData);

        return true;
      } else {
        print("Pharos login Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception pharos serial: $e");
      return false;
    }
  }
}
