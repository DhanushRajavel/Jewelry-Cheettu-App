import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://smsjewellers.com/api';
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'poster_check': 'HTRF35Poster90io@#Xcv100RF',
    'locale': 'en',
  };

  // Common method to handle POST requests
  static Future<Map<String, dynamic>> _postRequest({
    required String endPoint,
    Map<String, String>? headers,
    Map<String, String>? body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {..._defaultHeaders, if (headers != null) ...headers},
        body: body,
      );
      return _handleResponse(response);
    } catch (e) {
      return {'error': 'Exception caught: $e'};
    }
  }

  // Common method to handle GET requests
  static Future<Map<String, dynamic>?> _getRequest({
    required String endPoint,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {..._defaultHeaders, if (headers != null) ...headers},
      );
      return _handleResponse(response);
    } catch (e) {
      return {'error': 'Exception caught: $e'};
    }
  }

  // Method to handle responses
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return {
        'error': 'Failed with status code: ${response.statusCode}, reason: ${response.reasonPhrase}',
      };
    }
  }

  // Login User
  static Future<Map<String, dynamic>> loginUser({
    required String mobile,
    required String password,
  }) {
    return _postRequest(
      endPoint: '/p1-user-login',
      body: {
        'sms_mobile_no': mobile,
        'p1_password': password,
        'p1_user_token': '23423423432',
      },
    );
  }

  // Register User
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String mobile,
    required String authorization,
    required String endPoint,
    String? password,
    String countryCode = '91',
    String type = 'help',
  }) {
    return _postRequest(
      endPoint: endPoint,
      headers: {'Authorization': 'Bearer $authorization'},
      body: {
        'name': name,
        'email': email,
        'password': password ?? '',
        'mobile': mobile,
        'country_code': countryCode,
        'type': type,
      },
    );
  }

  // Get User Data
  static Future<Map<String, dynamic>?> userDataGetMethod({
    required String authorizationToken,
    required String endPoint,
  }) {
    return _getRequest(
      endPoint: endPoint,
      headers: {'Authorization': 'Bearer $authorizationToken'},
    );
  }

  // Generic Post Method for User Data
  static Future<Map<String, dynamic>> userDataPostMethod({
    required String authorization,
    required String endPoint,
  }) {
    return _postRequest(
      endPoint: endPoint,
      headers: {'Authorization': 'Bearer $authorization'},
    );
  }

  // Join Plan
  static Future<Map<String, dynamic>> requestUser({
    required String name,
    required String email,
    required String planId,
    required String mobile,
    required String authorizationToken,
  }) {
    return _postRequest(
      endPoint: '/p1-join-plan',
      headers: {'Authorization': 'Bearer $authorizationToken'},
      body: {
        'name': name,
        'email': email,
        'plan_id': planId,
        'mobile': mobile,
      },
    );
  }

  // Get Plan Details
  static Future<Map<String, dynamic>> planDetails({
    required String authorization,
    required String endPoint,
    String? planId,
  }) {
    return _postRequest(
      endPoint: endPoint,
      headers: {'Authorization': 'Bearer $authorization'},
      body: {'p1_scheme_id': planId ?? ''},
    );
  }

  // Update User Profile
  static Future<Map<String, dynamic>> updateUserProfile({
    required String name,
    required String email,
    required String mobile,
    required String? address,
    required String authorization,
  }) {
    return _postRequest(
      endPoint: '/p1-profile-update',
      headers: {'Authorization': 'Bearer $authorization'},
      body: {
        'p1_name': name,
        'p1_email': email,
        'p1_mobile': mobile,
        'p1_address': address ?? '',
      },
    );
  }

  // Confirm Payment with optional image
  static Future<Map<String, dynamic>> confirmPayment({
    required String authorization,
    required String endPoint,
    String? planId,
    File? image,
  }) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$_baseUrl$endPoint'));
      request.headers.addAll({
        ..._defaultHeaders,
        'Authorization': 'Bearer $authorization',
      });
      if (planId != null) request.fields['membership_no'] = planId;
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('p1_photo', image.path));
      }

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      return _handleResponse(responseBody);
    } catch (e) {
      return {'error': 'Exception caught: $e'};
    }
  }
}
