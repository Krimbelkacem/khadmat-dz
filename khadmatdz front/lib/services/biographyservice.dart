import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/apiconfig.dart';
class BiographyService {
  static const String baseUrl = Config.baseUrl;


  static Future<String> addBiography(String userId, String biography) async {
    final url = Uri.parse('$baseUrl/user/add_biography');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"user_id": userId, "biography": biography}),
    );
    if (response.statusCode == 200) {
      return 'Biography added successfully';
    } else {
      throw Exception('Failed to add biography: ${response.body}');
    }
  }

  static Future<String> updateBiography(String userId, String newBiography) async {
    final url = Uri.parse('$baseUrl/user/update_biography');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"user_id": userId, "biography": newBiography}),
    );
    if (response.statusCode == 200) {
      return 'Biography updated successfully';
    } else {
      throw Exception('Failed to update biography: ${response.body}');
    }
  }

  static Future<String> deleteBiography(String userId) async {
    final url = Uri.parse('$baseUrl/user/delete_biography');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"user_id": userId}),
    );
    if (response.statusCode == 200) {
      return 'Biography deleted successfully';
    } else {
      throw Exception('Failed to delete biography: ${response.body}');
    }
  }
}
