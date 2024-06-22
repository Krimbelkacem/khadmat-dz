import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/apiconfig.dart';
import 'authmanager.dart';

class EducationService {
  static const String baseUrl = Config.baseUrl; // Replace with your API base URL

  static Future<Map<String, dynamic>> addEducation({
    required Map<String, dynamic> educationData,
  }) async {
    final sessionId = await AuthManager().getSessionId();

    if (sessionId == null) {
      throw Exception('Session ID is null');
    }

    const String apiUrl = '$baseUrl/user/education';

    final http.Response response = await http.post(
      Uri.parse('$apiUrl?token=$sessionId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(educationData),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {'success': true, 'message': responseData['message']};
    } else {
      return {'success': false, 'error': responseData['error']};
    }
  }

  static Future<List<Map<String, dynamic>>> getEducations() async {
    final sessionId = await AuthManager().getSessionId();

    if (sessionId == null) {
      throw Exception('Session ID is null');
    }

    const String apiUrl = '$baseUrl/user/educations';

    final response = await http.get(
      Uri.parse('$apiUrl?token=$sessionId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      List<dynamic> data = jsonDecode(response.body)['educations'];
      List<Map<String, dynamic>> educations = [];
      data.forEach((element) {
        educations.add(Map<String, dynamic>.from(element));
      });
      return educations;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load educations');
    }
  }
}
