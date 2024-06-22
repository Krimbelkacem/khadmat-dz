import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/skillsService.dart';
import 'addSkills.dart'; // Import Cupertino package

class Skills extends StatefulWidget {
  final List<String> skills; // Define skills as a parameter
  final List<String> userSkills; // Define user skills as a parameter



  const Skills({Key? key, required this.skills, required this.userSkills}) : super(key: key);

  @override
  _SkillsState createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  bool isEditMode = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('User Skills: ${widget.userSkills}');
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Skills',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Visibility(
                    visible: isEditMode,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddSkills(skills: widget.skills, reloadCall: null,), // Pass the reload callback
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isEditMode = !isEditMode;
                      });
                    },
                    icon: Icon(isEditMode ? Icons.done : Icons.edit),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          if (widget.userSkills.isNotEmpty)
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: widget.userSkills.map((skill) {
                return UserSkillCard(
                  skillName: skill,
                  isEditMode: isEditMode,
                  onDelete: () {
                    // Callback function to handle skill deletion
                    setState(() {
                      widget.userSkills.remove(skill); // Remove the deleted skill from the list
                    });
                  },
                );
              }).toList(),
            ),
          if (widget.userSkills.isEmpty)
            const Text(
              'No skills added',
              style: TextStyle(color: Colors.grey),
            ),
        ],
      ),
    );
  }
}

class UserSkillCard extends StatelessWidget {
  final String skillName;
  final bool isEditMode;
  final VoidCallback onDelete; // Callback function to handle skill deletion

  const UserSkillCard({
    Key? key,
    required this.skillName,
    required this.isEditMode,
    required this.onDelete, // Receive the callback function
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  skillName,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
          if (isEditMode)
            IconButton(
              onPressed: () {
                // Call deleteSkill function from SkillService
                _getUserId().then((userId) {
                  SkillService().deleteSkillByName(userId!, skillName).then((_) {
                    // Call the onDelete callback function after deletion
                    onDelete();
                  }).catchError((error) {
                    // Handle error
                    print('Error deleting skill: $error');
                  });
                });
              },
              iconSize: 14.0,
              icon: const Icon(Icons.close),
            ),
        ],
      ),
    );
  }

  Future<String?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
}
