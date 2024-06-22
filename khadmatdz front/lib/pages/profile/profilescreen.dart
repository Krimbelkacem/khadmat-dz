import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khadmatdz/pages/profile/profilecomponents/languages.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'profilecomponents/biography.dart';
import 'profilecomponents/education.dart';
import 'profilecomponents/experience.dart';
import 'profilecomponents/skills.dart';
import 'profilecomponents/cv.dart';
import '../../components/uploadpicture.dart';
import '../../config/apiconfig.dart';
import '../../services/educationservice.dart';
import '../../services/userService.dart';
import '../../services/skillsService.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'profilecomponents/skills.dart';
import 'profilecomponents/usersettings.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();







}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profileData;
  List<Map<String, dynamic>> educations = [];
  String? filePath;
  List<Map<String, dynamic>> skills = [];
  @override
  void initState() {
    super.initState();
    fetchProfileData();
    fetchEducations();
    loadSkills();
  }

  Future<void> loadSkills() async {
    // Create an instance of SkillService
    SkillService skillService = SkillService();

    try {
      // Call the getAllSkills method to retrieve skills
      List<dynamic> fetchedSkillsDynamic = await skillService.getAllSkills();

      // Convert dynamic list to list of strings
      List<String> fetchedSkills = fetchedSkillsDynamic.map((skill) => skill.toString()).toList();

      // Update the state with the fetched skills
      setState(() {
        skills = fetchedSkills.cast<Map<String, dynamic>>();
      });
    } catch (e) {
      // Handle any errors that occur during the API call
      print('Error loading skills: $e');
    }
  }


  Future<void> fetchProfileData() async {
    try {
      final Map<String, dynamic> fetchedProfileData =
      await ProfileService().getProfile();
      setState(() {
        profileData = fetchedProfileData;
      });
    } catch (e) {
      print('Error fetching profile data: $e');
      // Handle error
    }
  }

  Future<void> fetchEducations() async {
    try {
      final List<Map<String, dynamic>> fetchedEducations =
      await EducationService.getEducations();
      setState(() {
        educations = fetchedEducations;
      });
    } catch (e) {
      print('Error fetching educations: $e');
      // Handle error
    }
  }

  Future<String?> getFilePath(String fileName) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    return '$path/$fileName';
  }

  Future<void> downloadFile() async {
    String url = "${Config.baseUrl}/user/cv";
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final id = await FlutterDownloader.enqueue(
        url: url,
        savedDir: (await getExternalStorageDirectory())!.path,
        fileName: "cv.pdf",
        showNotification: true,
        openFileFromNotification: true,
      );
      FlutterDownloader.open(taskId: id!);
    } else {
      print("Permission denied");
    }
  }




  @override
  Widget build(BuildContext context) {
    print('Building ProfileScreen');
    print('profileData: $profileData');
    print('educations: $educations');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile header
              Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade400, // Adjust border color as needed
                                width: 0, // Adjust border width as needed
                              ),
                            ),
                            child: profileData?['picture'] != null
                                ? Image.network(
                              "${Config.baseUrl}/user/profile_picture/${profileData?['picture'] ?? ''}",
                              fit: BoxFit.cover,
                            )
                                : Image.asset(
                              'images/defaultpicture.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ProfilePicture()),
                              );
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueGrey, // Set the color of the circle
                              ),
                              child: const Icon(
                                LineAwesomeIcons.alternate_pencil,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileData?['username'] ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Junior Product Designer",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              profileData?['email'] ?? '', // Display email here
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 5,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UserInfoSettings(profileData: profileData)),
                              );
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )

                ],
              ),

              const SizedBox(height: 10),
              // Profile completion cards

              const SizedBox(height: 35),
              // Profile components
              Container(
                color: Colors.grey.shade200,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      profileData?['cv_file'] != null
                          ? CVSection(cvFile: profileData?['cv_file'])
                          : const Text('No CV available'),

                      const SizedBox(height: 20),
                      Biography(biography: profileData?['biography'] ?? 'No biography available'),
                      const SizedBox(height: 20),
                      Education(educations: educations),
                      const SizedBox(height: 20),
                      Experience(experiences: (profileData?['experiences'] ?? []).cast<Map<String, dynamic>>()),
                      Skills(
                        skills: skills.isNotEmpty ? skills.cast<String>() : [],
                        userSkills: List<String>.from(profileData?['skills'] ?? []),
                      ),


                      const SizedBox(height: 20),
                      Languages(languages: List<String>.from(profileData?['languages'] ?? [])),

                      // Add other profile components here
                    ],
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }


}
