import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../services/educationservice.dart';
import '../profilescreen.dart';

class Addeducation extends StatefulWidget {
  Addeducation({Key? key}) : super(key: key);

  @override
  _AddeducationState createState() => _AddeducationState();
}

class _AddeducationState extends State<Addeducation> {
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController studyController = TextEditingController();
  final TextEditingController dateBeganController = TextEditingController();
  final TextEditingController dateEndedController = TextEditingController();
  bool inProgress = false;
  String selectedDegree = 'Bachelor'; // Default value

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
      dateFormat: "dd-MMMM-yyyy",
      locale: DateTimePickerLocale.en_us,
      looping: true,
    );

    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  Future<void> _saveEducation() async {
    final Map<String, dynamic> educationData = {
      'institution': institutionController.text,
      'degree': selectedDegree,
      'field_of_study': studyController.text,
      'start_date': dateBeganController.text,
      'end_date': inProgress ? null : dateEndedController.text,
      'still_learning': inProgress,
    };

    try {
      final result = await EducationService.addEducation(educationData: educationData);
      if (result['success']) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['error'])),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.white, // Set the AppBar color to white
        title: const Text(
        'Add Education',
        style: TextStyle(color: Colors.black), // Set the title text color
    ),
    leading: IconButton(
    icon: const Icon(
    Icons.cancel, // Use the cancel icon
    color: Colors.black, // Set the icon color to black
    ),
    onPressed: () {
    Navigator.pop(context); // Go back when the cancel button is pressed
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
    child: SingleChildScrollView(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.start, // Align elements at the top
    children: [
    const SizedBox(height: 20), // Removed the top margin

    // Institution Text Field
    TextField(
    controller: institutionController,
    decoration: const InputDecoration(
    suffixIcon: Icon(
    Icons.check,
    color: Colors.grey,
    ),
    labelText: 'Institution',
    labelStyle: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black, // Changed text color to black
    ),
    ),
    ),
    const SizedBox(height: 20), // Added space between fields

    // Study Text Field
    TextField(
    controller: studyController,
    decoration: const InputDecoration(
    suffixIcon: Icon(
    Icons.check,
    color: Colors.grey,
    ),
    labelText: 'Study',
    labelStyle: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black, // Changed text color to black
    ),
    ),
    ),
    const SizedBox(height: 20), // Added space between fields

    // Degree Dropdown
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Expanded(
    child: DropdownButton<String>(
    value: selectedDegree,
    onChanged: (String? newValue) {
    setState(() {
    selectedDegree = newValue!;
    });
    },
    items: <String>['Bachelor', 'Master', 'Doctorate']
        .map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(
    value,
    style: const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black, // Changed text color to black
    ),
    ),
    );
    }).toList(),
    ),
    ),
    ],
    ),
    const SizedBox(height: 20), // Added space between fields

    // Date Began Text Field
    TextField(
    onTap: () => _selectDate(context, dateBeganController),
    controller: dateBeganController,
    readOnly: true,
    decoration: const InputDecoration(
    suffixIcon: Icon(
    Icons.calendar_today,
    color: Colors.grey,
    ),
    labelText: 'Date Began',
    labelStyle: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black, // Changed text color to black
    ),
    ),
    ),
    const SizedBox(height: 20), // Added space between fields

    // Date Ended Text Field
    TextField(
    onTap: () => inProgress ? null : _selectDate(context, dateEndedController),
    controller: dateEndedController,
    readOnly: inProgress,
    enabled: !inProgress,
    decoration: const InputDecoration(
    suffixIcon: Icon(
    Icons.calendar_today,
    color: Colors.grey,
    ),
    labelText: 'Date Ended',
    labelStyle: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black, // Changed text color to black
    ),
    ),
    ),
    const SizedBox(height: 20), // Added space between fields

    // In Progress Checkbox
    Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    Checkbox(
    value: inProgress,
    onChanged: (bool? value) {
    setState(() {
    inProgress = value!;
    if (value!) {
    dateEndedController.clear(); // Clear date ended when in progress
    }
    });
    },
    ),
    const Text(
    'In Progress',
    style: TextStyle(
    fontWeight: FontWeight.bold,
      color: Colors.black, // Changed text color to black
    ),
    ),
    ],
    ),
      const SizedBox(height: 100), // Added space for the bottom buttons
    ],
    ),
    ),
    ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width, // Full width
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(
              height: 2, // Set the height of the divider
              color: Colors.grey, // Set the color of the divider
            ),
            const SizedBox(height: 12),
            SizedBox(  // Wrap ElevatedButton with SizedBox to set its width
              width: double.infinity,  // Make button full width
              child: ElevatedButton(
                onPressed: _saveEducation, // Call _saveEducation function
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue color
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black), // White text color
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Fixed position
    );
  }
}

