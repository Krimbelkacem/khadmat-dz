import 'package:flutter/material.dart';
import '../../../services/userService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../profilescreen.dart';

class Languages extends StatefulWidget {
  final List<String> languages;

  const Languages({
    Key? key,
    required this.languages,
  }) : super(key: key);

  @override
  _LanguagesState createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  bool isEditMode = false;
  final TextEditingController _languageController = TextEditingController();
  late String userId; // Declare userId as a class field

  @override
  void initState() {
    super.initState();
    _initializeUserId(); // Initialize userId in initState
  }

  Future<void> _initializeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Languages',
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
                        // Show language selection dialog
                        _showLanguageSelectionDialog(context);
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
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.languages.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      widget.languages[index],
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    trailing: isEditMode
                        ? IconButton(
                      onPressed: () {
                        // Add logic to delete the language with confirmation
                        _showDeleteConfirmationDialog(context, index);
                      },
                      icon: const Icon(Icons.delete),
                    )
                        : null, // Hide delete icon if not in edit mode
                  ),
                  if (index != widget.languages.length - 1)
                    const Divider(), // Add divider except for the last item
                ],
              );
            },
          ),
          if (isEditMode) const SizedBox(height: 20),

        ],
      ),
    );
  }


  void _showLanguageSelectionDialog(BuildContext context) {
    List<String> topLanguages = [
      'English',
      'American English',
      'British English',
      'Canadian English',
      'Australian English',
      'South African English',
      'Spanish',
      'German',
      'Italian',
      'Japanese',
      'Chinese (Mandarin)'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SingleChildScrollView(
            child: Column(
              children: List.generate(
                topLanguages.length,
                    (index) => ListTile(
                  title: Text(topLanguages[index]),
                  onTap: () async {
                    // Add logic to select the language
                    String language = topLanguages[index];
                    await LanguageService.addLanguage(userId, language);
                    setState(() {
                      widget.languages.add(language);
                    });
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Add logic for the cancel action
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Language'),
          content: const Text('Are you sure you want to delete this language?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Delete the language
                String language = widget.languages[index];
                await LanguageService.deleteLanguage(userId, language);
                setState(() {
                  widget.languages.removeAt(index);
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _languageController.dispose();
    super.dispose();
  }
}
