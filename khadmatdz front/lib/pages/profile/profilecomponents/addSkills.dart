import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../profilescreen.dart';
import '/../../services/skillsService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddSkills extends StatefulWidget {
  final List<String> skills;

  const AddSkills({Key? key, required this.skills, required reloadCall}) : super(key: key);

  @override
  _AddSkillsState createState() => _AddSkillsState();
}

class _AddSkillsState extends State<AddSkills> {
  final TextEditingController searchController = TextEditingController();


  List<String> selectedSkills = [];
  final SkillService skillService = SkillService();

  @override
  Widget build(BuildContext context) {
    print("Skills count: ${widget.skills.length}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Search Education',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.cancel,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Search Text Field
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {}); // Trigger rebuild to apply filter
              },
              decoration: const InputDecoration(
                hintText: 'Search for a skill...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Display filtered list of skills
            Expanded(
              child: ListView.builder(
                itemCount: widget.skills.length,
                itemBuilder: (BuildContext context, int index) {
                  final skill = widget.skills[index];
                  // Apply search filter
                  if (searchController.text.isNotEmpty &&
                      !skill.toLowerCase().contains(
                          searchController.text.toLowerCase())) {
                    return Container(); // Return an empty container for hidden items
                  }
                  return ListTile(
                    title: Text(skill),
                    // Check if the skill is selected
                    trailing: selectedSkills.contains(skill)
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () {
                      setState(() {
                        if (selectedSkills.contains(skill)) {
                          selectedSkills.remove(skill);
                        } else {
                          selectedSkills.add(skill);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(
              height: 2,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press
                  if (selectedSkills.isNotEmpty) {
                    // Post selected skills
                    _postSelectedSkills(selectedSkills);
                  } else {
                    print('No skills selected.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _postSelectedSkills(List<String> skills) async {
    try {
      String? userId = await _getUserId();
      if (userId != null) {
        // Send all selected skills in one request using the service
        await skillService.addSkills(userId, skills);
        print('Skills added successfully');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ),
        );

      } else {
        print('User ID not found in SharedPreferences');
        // Handle the case where user ID is not found
      }
    } catch (e) {
      print('Failed to add skills: $e');
      // Handle error and show error message if needed
    }
  }

  Future<String?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
}
