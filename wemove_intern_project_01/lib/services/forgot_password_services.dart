import 'package:wemove_intern_project_01/base_api/base_api_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordServices {
  final BaseApiServices apiServices;

  ForgotPasswordServices(this.apiServices);

  // Post ForgotPassword
  Future<Map<String, dynamic>> postForgotPassword({
    required String username,
  }) async {
    const endpoint = 'v1/customer/accounts/forgot';
    final body = {
      'emailAddress': username,
    };

    try {
      final headers = await apiServices.getHeaders();
      final response = await http.post(
        Uri.parse('${apiServices.baseUrl}$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );

      print("Raw API response: ${response.body}"); // Debugging

      if (response.statusCode < 600) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey("tempId")) {
          return {
            "success": true,
            "tempId": responseData["tempId"],
            "message": responseData["message"] ?? "OTP Sent"
          };
        }
        return responseData;
      } else {
        print("Server error: ${response.statusCode} - ${response.body}");
        return {
          "success": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      print("Exception in postForgotPassword: $e");
      return {"success": false, "message": "An error occurred: $e"};
    }
  }
}
