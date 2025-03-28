import 'package:wemove_intern_project_01/base_api/base_api_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//Logic Login
class LoginServices {
  final BaseApiServices apiServices;

  LoginServices(this.apiServices);

  //Post Login
  Future<Map<String, dynamic>> postLogin({
    required String username,
    required String password,
  }) async {
    const endpoint = 'v1/customer/accounts/login';
    final body = {
      'identifier': username,
      'password': password,
    };

    try {
      final headers = await apiServices.getHeaders();
      final response = await http.post(
        Uri.parse('${apiServices.baseUrl}$endpoint'),
        headers: headers,
        body: jsonEncode(body),
        // encoding: Encoding.getByName('utf-8'),
      );

      print("Raw API response: ${response.body}"); // for Debugging

      //Success
      if (response.statusCode < 600) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print("Server error: ${response.statusCode} - ${response.body}");
        return {
          "success": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      print("Exception in postLogin: $e");
      return {"success": false, "message": "An error occurred: $e"};
    }
  }

  //
}
