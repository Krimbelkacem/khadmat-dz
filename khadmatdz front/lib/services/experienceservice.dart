import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/apiconfig.dart';

class ExperienceService {
  static const String baseUrl = Config.baseUrl;

  static Future<Map<String, dynamic>> addExperience({
    required String userId,
    required Map<String, dynamic> experienceData,
  }) async {
    final url = Uri.parse('$baseUrl/user/addexperience?user_id=$userId');
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(experienceData),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return {'success': true, 'message': responseData['message']};
      } else {
        return {'success': false, 'error': responseData['error']};
      }
    } catch (e) {
      return {
        'success': false,
        'error':
        'Failed to connect to the server. Please check your internet connection.'
      };
    }
  }

  static Future<Map<String, dynamic>> updateExperience({
    required String userId,
    required String experienceId,
    required Map<String, dynamic> updatedExperienceData,
  }) async {
    final url =
    Uri.parse('$baseUrl/experiences/$experienceId?user_id=$userId');
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(updatedExperienceData),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'message': responseData['message']};
      } else {
        return {'success': false, 'error': responseData['error']};
      }
    } catch (e) {
      return {
        'success': false,
        'error':
        'Failed to connect to the server. Please check your internet connection.'
      };
    }
  }

  static Future<Map<String, dynamic>> deleteExperience({
    required String userId,
    required String startDate,

  }) async {
    print(userId);
    print(startDate);
    final url =
    Uri.parse('$baseUrl/user/deleteexperience/$startDate?user_id=$userId');

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.delete(
        url,
        headers: headers,
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'message': responseData['message']};
      } else {
        return {'success': false, 'error': responseData['error']};
      }
    } catch (e) {
      return {
        'success': false,
        'error':
        'Failed to connect to the server. Please check your internet connection.'
      };
    }
  }
}
