import 'dart:convert';


import 'package:shared_preferences/shared_preferences.dart';
import '../config/apiconfig.dart';
import 'authmanager.dart';
import '../models/usermodel.dart';
import 'dart:convert';
import '../signin.dart';

import 'dart:io';
import 'package:http/http.dart' as http;

class ClientService {
  static const String baseUrl = Config.baseUrl;

  Future<void> addProposal(
      String userId,
      String title,
      String description,
      String budget,
      String timeline,
      File image,
      ) async {
    try {
      // Print parameter values
      print('User ID: $userId');
      print('Title: $title');
      print('Description: $description');
      print('Budget: $budget');
      print('Timeline: $timeline');
      print('Image path: ${image.path}');

      // Create multipart request for uploading image
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/user/add_proposal'));
      request.fields.addAll({
        'user_id': userId,
        'title': title,
        'description_text': description,
        'budget': budget,
        'timeline': timeline,
      });

      // Attach image file to the request
      var imageStream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile('description_image', imageStream, length, filename: image.path.split('/').last);
      request.files.add(multipartFile);

      print('Sending proposal request...');
      // Send request
      var response = await request.send();

      print('Received proposal response...');
      // Check if request was successful
      if (response.statusCode == 200) {
        print('Proposal added successfully');
      } else {
        throw Exception('Failed to add proposal: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error adding proposal: $e');
      throw Exception('Failed to add proposal: $e');
    }
  }

}
