import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'addexperience.dart';
import '../../../services/experienceservice.dart';

class Experience extends StatefulWidget {
  final List<Map<String, dynamic>> experiences;

  const Experience({Key? key, required this.experiences}) : super(key: key);

  @override
  _ExperienceState createState() => _ExperienceState();
}

class _ExperienceState extends State<Experience> {
  bool isEditMode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Expertise',
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
                            builder: (context) => const AddExperience(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        // Toggle edit mode
                        isEditMode = !isEditMode;
                      });
                    },
                    icon: Icon(isEditMode ? Icons.done : Icons.edit),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          // Display each experience item
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.experiences.length,
            itemBuilder: (context, index) {
              var experience = widget.experiences[index];
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (experience['institution'] != null)
                      Text(
                        experience['institution'],
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 8.0),
                    if (experience['profession'] != null)
                      Text(
                        experience['profession'],
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                    Text(
                      experience['start_date'] != null
                          ? 'Start Date: ${experience['start_date']}'
                          : '',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    Text(
                      experience['still_working'] != null && experience['still_working']
                          ? 'In Progress'
                          : experience['end_date'] != null
                          ? 'End Date: ${experience['end_date']}'
                          : '',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                trailing: isEditMode
                    ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    // Get the user ID from SharedPreferences
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? userId = prefs.getString('userId') ?? '';

                    // Prompt the user with a confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm Delete"),
                          content: const Text("Are you sure you want to delete this experience?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                // Call experience service deleteExperience method with the user ID
                                ExperienceService.deleteExperience( userId: userId, startDate: experience['start_date']);
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
