import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/apiconfig.dart';


class SkillService {


  Future<List> getAllSkills() async {
    final response = await http.get(Uri.parse('${Config.baseUrl}/skills/getall'));

    if (response.statusCode == 200) {
      final List<dynamic> skillsJson = json.decode(response.body)['skills'];
      final List skillsList = skillsJson.map((skill) {
        return skill['name'];
      }).toList();

      // Print fetched skill names
      print('Fetched skills: $skillsList');

      return skillsList;
    } else {
      throw Exception('Failed to load skills');
    }
  }




  Future<void> addSkills(String userId, List<String> skills) async {
    final url = Uri.parse('${Config.baseUrl}/skills/add_skills?user_id=$userId');
    final response = await http.post(
      url,
      body: jsonEncode({'skills': skills}), // Send all selected skills
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Skills added successfully
      print('Skills added successfully');
    } else {
      // Error adding skills
      print('Failed to add skills: ${response.body}');
      throw Exception('Failed to add skills');
    }
  }




  Future<void> deleteSkillByName(String userId, String skillName) async {
    final url = Uri.parse('${Config.baseUrl}/skills/delete_skill?user_id=$userId');
    final response = await http.post(
      url,
      body: jsonEncode({'skill_name': skillName}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Skill deleted successfully
      print('Skill deleted successfully');
    } else {
      // Error deleting skill
      print('Failed to delete skill: ${response.body}');
    }
  }

}
