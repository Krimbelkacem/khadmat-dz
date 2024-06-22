import 'package:flutter/material.dart';
import '../profilescreen.dart';
import 'addbiography.dart';
import '../../../services/biographyservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Biography extends StatefulWidget {
  const Biography({
    Key? key,
    required this.biography,
  }) : super(key: key);

  final String biography;

  @override
  _BiographyState createState() => _BiographyState();
}

class _BiographyState extends State<Biography> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.biography);
  }

  Future<void> _updateBiography(String newBiography) async {
    final String? userId = await getUserIdFromSharedPreferences();
    if (userId != null) {



        try {
          String? userId = await getUserIdFromSharedPreferences(); // Retrieve the user ID
          if (userId != null) {
            // Call the addBiography method from BiographyService with the retrieved user ID
            String response = await BiographyService.addBiography(userId, newBiography);
            print(response); // Print success message
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );

          } else {
            print('Error: User ID not found in shared preferences');
            // Handle the case where the user ID is not found in shared preferences
          }
        } catch (e) {
          print('Error: $e'); // Print error message
          // Show error message using a snackbar or dialog
        }

    }
  }

  Future<String?> getUserIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    return userId;
  }

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
                'About',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [

                  IconButton(
                    onPressed: () {
                      if (_isEditing) {
                        // Save the changes
                        _updateBiography(_controller.text);
                      }
                      // Toggle edit mode
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    icon: Icon(_isEditing ? Icons.done : Icons.edit), // Toggle icon based on edit mode
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10), // Add some space between the 'About' text and the biography
          _isEditing
              ? TextField(
            controller: _controller,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (value) {
              // You can add additional logic here if needed
            },
          )
              : Text(
            widget.biography,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
