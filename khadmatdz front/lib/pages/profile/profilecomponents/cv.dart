import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/apiconfig.dart';
import '../../../services/userService.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CVSection extends StatefulWidget {
  final String? cvFile;

  const CVSection({Key? key, this.cvFile}) : super(key: key);

  Future<String?> getUserIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    return userId;
  }

  @override
  _CVSectionState createState() => _CVSectionState();
}

class _CVSectionState extends State<CVSection> {
  String? _selectedFileName;

  @override
  Widget build(BuildContext context) {
    return cvSectionContainer(context);
  }

  Widget cvSectionContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'cv',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _pickFile,
              ),

              if (widget.cvFile != null && widget.cvFile!.isNotEmpty)
                Row(
                  children: [
                    Expanded(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => downloadCV(context),
                          child: const Text(
                            'Download CV',
                            style: TextStyle(
                              fontSize: 16,
                              color: CupertinoColors.inactiveGray,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 50),
                    const Icon(
                      CupertinoIcons.cloud_download,
                      size: 30,
                      color: CupertinoColors.inactiveGray,
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10), // Add some space between the title and the next content
          if (widget.cvFile == null || widget.cvFile!.isEmpty) // Adjusted condition to display message when cvFile is null or empty
            const Text(
              'No CV available',
              style: TextStyle(
                fontSize: 16,
                color: CupertinoColors.inactiveGray,
              ),
            ),
        ],
      ),
    );
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFileName = result.files.single.name;
      });
      _showFileNameDialog(result.files.single.bytes!); // Pass the picked file bytes to the dialog method
    }
  }

  void downloadCV(BuildContext context) async {
    if (widget.cvFile != null) {
      final url = '${Config.baseUrl}/user/cv/${widget.cvFile}';

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open CV')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CV file not available')),
      );
    }
  }

  void _saveFile(List<int> bytes) async {
    String? userId = await widget.getUserIdFromSharedPreferences(); // Retrieve user ID asynchronously
    String fileName = _selectedFileName ?? 'cv_file'; // Use a default file name if the selected file name is null

    try {
      // Write the bytes to a temporary file
      late File tempFile;

      if (Platform.isAndroid) {
        final directory = await getExternalStorageDirectory();
        tempFile = File('${directory!.path}/$fileName');
      } else if (Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        tempFile = File('${directory.path}/$fileName');
      } else {
        throw UnsupportedError('Unsupported platform'); // Handle unsupported platforms
      }

      await tempFile.writeAsBytes(bytes);

      String? filename = await CVService.uploadCV(userId!, tempFile);

      if (filename != null) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CV uploaded successfully!')),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload CV')),
        );
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while processing the file')),
      );
    }
  }


  void _showFileNameDialog(List<int> bytes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selected File'),
          content: Text(_selectedFileName ?? 'No file selected'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveFile(bytes); // Call the save file method with the picked file bytes
                Navigator.of(context).pop(); // Close the dialog after saving
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
