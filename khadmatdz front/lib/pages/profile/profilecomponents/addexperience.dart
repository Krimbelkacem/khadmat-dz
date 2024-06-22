import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../services/experienceservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../profilescreen.dart';
class AddExperience extends StatefulWidget {
  const AddExperience({Key? key}) : super(key: key);

  @override
  _AddExperienceState createState() => _AddExperienceState();
}

class _AddExperienceState extends State<AddExperience> {
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController professionController = TextEditingController(); // New field for profession
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  bool stillWorking = false;

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

  Future<void> _saveExperience() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? ''; // Get user ID from shared preferences

    final Map<String, dynamic> experienceData = {
      'institution': institutionController.text,
      'position': positionController.text,
      'profession': professionController.text,
      'start_date': startController.text,
      'end_date': stillWorking ? null : endController.text,
      'still_working': stillWorking,
    };

    try {
      final result = await ExperienceService.addExperience(
        userId: userId, // Pass user ID to addExperience method
        experienceData: experienceData,
      );
      if (result['success']) {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['error'])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Add Experience',
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: positionController,
                decoration: const InputDecoration(
                  suffixIcon: Icon(
                    Icons.check,
                    color: Colors.grey,
                  ),
                  labelText: 'Position',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: professionController, // Added TextField for profession
                decoration: const InputDecoration(
                  suffixIcon: Icon(
                    Icons.check,
                    color: Colors.grey,
                  ),
                  labelText: 'Profession',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                onTap: () => _selectDate(context, startController),
                controller: startController,
                readOnly: true,
                decoration: const InputDecoration(
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                  ),
                  labelText: 'Start Date',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                onTap: () => stillWorking ? null : _selectDate(context, endController),
                controller: endController,
                readOnly: stillWorking,
                enabled: !stillWorking,
                decoration: const InputDecoration(
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                  ),
                  labelText: 'End Date',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: stillWorking,
                    onChanged: (bool? value) {
                      setState(() {
                        stillWorking = value!;
                        if (value!) {
                          endController.clear();
                        }
                      });
                    },
                  ),
                  const Text(
                    'Still Working',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
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
                onPressed: _saveExperience,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
}
