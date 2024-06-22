import 'dart:convert';


import 'package:shared_preferences/shared_preferences.dart';
import '../config/apiconfig.dart';
import 'authmanager.dart';
import '../models/usermodel.dart';
import 'dart:convert';
import '../signin.dart';

import 'dart:io';
import 'package:http/http.dart' as http;

class SignUpService {
  Future<void> signUp(String username, String email, String password) async {
    final url = Uri.parse('${Config.baseUrl}${Config.signUp}');
    try {
      print('URL: $url');
      print('Username: $username');
      print('Email: $email');
      print('Password: $password');

      final response = await http.post(
        url,
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Successful sign up
        print('User signed up successfully');
      } else {
        // Handle error
        print('Error signing up: ${response.statusCode}');
        throw Exception('Failed to sign up');
      }
    } catch (e) {
      // Handle network errors
      print('Error signing up: $e');
      throw Exception('Failed to sign up');
    }
  }
}

class SignInService {
  Future<String> signIn(String email, String password) async {
    final url = Uri.parse('${Config.baseUrl}${Config.signIn}');
    try {
      print('URL: $url');
      print('Email: $email');
      print('Password: $password');

      final response = await http.post(
        url,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final sessionId = responseData['token'];

        // Ensure session ID is not null
        if (sessionId != null) {
          // Save the session ID securely in local storage using AuthManager
          await AuthManager().saveSessionId(sessionId);

          // Return the session ID
          return sessionId;
        } else {
          // Handle null session ID
          throw Exception('Session ID is null');
        }
      } else {
        // Handle error if response status code is not 200
        print('Error signing in: ${response.statusCode}');
        throw Exception('Failed to sign in: ${response.body}');
      }
    } catch (e) {
      // Handle network errors or parsing errors
      print('Error signing in: $e');
      throw Exception('Failed to sign in: $e');
    }
  }
}


class ProfileService {
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final sessionId = await AuthManager().getSessionId();

      if (sessionId == null) {
        throw Exception('Session ID is null');
      }

      final url = Uri.parse('${Config.baseUrl}${Config.profile}?token=$sessionId');

      print('URL: $url');
      print('Session ID: $sessionId');

      final response = await http.get(url);

      print('my Response Status Code: ${response.statusCode}');
      print('my Response Body: ${response.body}'); // Print response body

      if (response.statusCode == 200) {
        final responseBody = response.body;

        final decodedBody = json.decode(responseBody);
        final result = decodedBody['result'];

        if (result != null && result is Map<String, dynamic>) {
          // Save userId to local storage
          final userId = result['id'];
          print('userID $userId');
          await saveUserId(userId); // Assuming saveUserId is a method to save userId locally

          // Print received user profile data
          print('Received User Profile: $result');

          return result;
        } else {
          throw Exception('Invalid user profile data received');
        }
      } else {
        throw Exception('Failed to get user profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching profile data: $e');
      throw Exception('Failed to get user profile');
    }
  }
}
Future<void> saveUserId(String userId) async {
  // Get instance of SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  // Save userId to local storage
  await prefs.setString('userId', userId);
}

class deletecv{
  static Future<void> deleteCV(String userId) async {
    try {
      // Make a DELETE request to the backend server's delete_cv endpoint
      final response = await http.delete(
        Uri.parse('${Config.baseUrl}/delete_cv?user_id=$userId'),
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // CV deleted successfully
        print('CV deleted successfully');
      } else {
        // CV deletion failed
        print('Failed to delete CV: ${response.statusCode}');
        // You can handle errors or show appropriate messages here
      }
    } catch (e) {
      // Exception occurred while making the request
      print('Error deleting CV: $e');
      // You can handle exceptions or show appropriate messages here
    }
  }
}

class CVService {
  static Future<String?> getCV(String filePath) async {
    try {
      final response = await http.get(Uri.parse('${Config.baseUrl}/user/cv/$filePath'));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Failed to get CV: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting CV: $e');
      return null;
    }
  }
  static Future<String?> uploadCV(String userId, File file) async {
    try {
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Config.baseUrl}/user/upload_cv'),
      );

      // Attach the user ID as a query parameter
      request.fields['user_id'] = userId;

      // Attach the file
      request.files.add(
        http.MultipartFile(
          'file',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.path.split('/').last,
        ),
      );

      // Send the request
      var response = await request.send();

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response JSON
        var responseBody = await response.stream.bytesToString();
        var responseJson = json.decode(responseBody);

        // Check if the upload was successful
        if (responseJson['message'] != null) {
          // Return the filename
          return responseJson['filename'];
        } else {
          // Return the error message
          return responseJson['error'];
        }
      } else {
        // Return the error message
        return 'Failed to upload CV. Status code: ${response.statusCode}';
      }
    } catch (e) {
      // Return the error message
      return 'An error occurred: $e';
    }
  }
}


class LanguageService {
  static Future<void> addLanguage(String userId, String language) async {
    try {
      final url = Uri.parse('${Config.baseUrl}/user/addlanguage?user_id=$userId');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'language': language}),
      );

      if (response.statusCode == 201) {
        print('Language added successfully');
      } else {
        print('Failed to add language: ${response.body}');
      }
    } catch (e) {
      print('Error adding language: $e');
    }
  }

  static Future<void> deleteLanguage(String userId, String language) async {
    try {
      final url = Uri.parse('${Config.baseUrl}/user/language?user_id=$userId&language=$language');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Language $language deleted successfully');
      } else {
        print('Failed to delete language: ${response.body}');
      }
    } catch (e) {
      print('Error deleting language: $e');
    }
  }
}