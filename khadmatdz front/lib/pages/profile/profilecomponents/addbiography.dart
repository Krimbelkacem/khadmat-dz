import 'package:flutter/material.dart';
import '../../../services/biographyservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBiographyScreen extends StatelessWidget {
  const AddBiographyScreen({Key? key}) : super(key: key);



  Future<String?> getUserIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    return userId;
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController biographyController = TextEditingController(); // Controller for the TextField

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Biography'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: biographyController, // Assign the controller to the TextField
              maxLines: null,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                hintText: 'Enter your biography',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String biography = biographyController.text.trim(); // Get the entered biography text

                  try {
                    String? userId = await getUserIdFromSharedPreferences(); // Retrieve the user ID
                    if (userId != null) {
                      // Call the addBiography method from BiographyService with the retrieved user ID
                      String response = await BiographyService.addBiography(userId, biography);
                      print(response); // Print success message
                      Navigator.pop(context); // Navigate back to the previous screen
                    } else {
                      print('Error: User ID not found in shared preferences');
                      // Handle the case where the user ID is not found in shared preferences
                    }
                  } catch (e) {
                    print('Error: $e'); // Print error message
                    // Show error message using a snackbar or dialog
                  }
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Save'),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
