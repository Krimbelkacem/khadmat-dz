import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Picker Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePicture(),
    );
  }
}

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Example'),
      ),
      body: Center(
        child: _imageData == null
            ? const Text('No image selected.')
            : Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: Image.memory(_imageData!),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: getImage,
            tooltip: 'Pick Image',
            child: Icon(Icons.add_a_photo),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: getImageFromCamera,
            tooltip: 'Capture Image',
            child: Icon(Icons.camera),
          ),
          SizedBox(width: 10),
          Visibility(
            visible: _imageData != null,
            child: FloatingActionButton(
              onPressed: saveImage,
              tooltip: 'Save Image',
              child: Icon(Icons.save),
            ),
          ),
        ],
      ),
    );
  }

  Future getImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List? imageData = await image.readAsBytes();
      if (imageData != null) {
        setState(() {
          _imageData = imageData;
        });
      }
    }
  }

  Future getImageFromCamera() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final Uint8List? imageData = await image.readAsBytes();
      if (imageData != null) {
        setState(() {
          _imageData = imageData;
        });
      }
    }
  }

  void saveImage() {
    // Add your save image logic here
  }
}
