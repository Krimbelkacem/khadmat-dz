import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../config/apiconfig.dart';
import '../pages/profile/profilescreen.dart';
import 'uploadpicture.dart'; // Assuming this is the correct import for the profile picture widget
import '../services/userservice.dart'; // Assuming this is the correct import for your profile service
import '../signin.dart';

class CustomListTile {
  final IconData icon;
  final String title;
  CustomListTile({
    required this.icon,
    required this.title,
  });
}
List<CustomListTile> customListTiles = [
  CustomListTile(
    icon: Icons.insights,
    title: "Activity",
  ),
  CustomListTile(
    icon: Icons.location_on_outlined,
    title: "Location",
  ),
  CustomListTile(
    title: "Notifications",
    icon: CupertinoIcons.bell,
  ),
  CustomListTile(
    title: "Logout",
    icon: CupertinoIcons.arrow_right_arrow_left,
  ),
  CustomListTile( // New item added
    title: "Employer",
    icon: LineAwesomeIcons.user,
  ),
];

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late Future<Map<String, dynamic>> _profileDataFuture;

  @override
  void initState() {
    super.initState();
    _profileDataFuture = ProfileService().getProfile() as Future<Map<String, dynamic>>; // Call getProfile method
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('khadmatDZ'),
      ),
      child: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _profileDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final Map<String, dynamic>? profileData = snapshot.data;
              if (profileData == null || profileData.isEmpty) {
                // Handle case where profile data is null or empty
                return const Center(child: Text('No profile data available'));
              }

              final String username = profileData['username'] ?? 'Username';
              final String email = profileData['email'] ?? 'user@example.com';
              final String? profilePicture = profileData['picture'];

              return Container(
                color: Colors.white,
                child: ListView(
                  children: <Widget>[
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFFFFFF),
                            Color(0xFFFFFFFF),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                                        child: profilePicture != null
                                            ? Image.network(
                                          '${Config.baseUrl}/user/profile_picture/$profilePicture',
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
                                            MaterialPageRoute(builder: (context) => ProfilePicture()),
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
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      username,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      email,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Text(
                                      "Software Developer",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    // Add custom list tiles here
                    for (var tile in customListTiles)
                      ListTile(
                        title: Text(tile.title),
                        leading: Icon(tile.icon),
                        onTap: () {
                          // Handle tile onTap if needed
                          if (tile.title == 'Logout') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          }
                        },
                      ),
                    ListTile(
                      title: const Text('Edit Profile'),
                      leading: Icon(Icons.edit),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePicture()),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
