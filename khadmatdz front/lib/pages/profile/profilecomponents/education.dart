import 'package:flutter/material.dart';
import 'addeduacation.dart';

class Education extends StatefulWidget {
  final List<Map<String, dynamic>> educations;

  const Education({Key? key, required this.educations}) : super(key: key);

  @override
  _EducationState createState() => _EducationState();
}

class _EducationState extends State<Education> {
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
                'Education',
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
                            builder: (context) => Addeducation(),
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
          // Display each education item
          for (var education in widget.educations) ...[
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    education['institution'],
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isEditMode)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          // Remove the education item from the list
                          widget.educations.remove(education);
                        });
                      },
                      icon: const Icon(Icons.delete),
                    ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    education['degree'],
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Start Date: ${education['start_date']}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    education['still_learning'] == true
                        ? 'In Progress'
                        : 'End Date: ${education['end_date']}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    'field of study: ${education['field_of_study']}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
        ],
      ),
    );
  }
}
