import 'package:flutter/material.dart';

import '../profilescreen.dart';

class UserInfoSettings extends StatefulWidget {
  final Map<String, dynamic>? profileData;

  const UserInfoSettings({Key? key, this.profileData}) : super(key: key);

  @override
  _UserInfoSettingsState createState() => _UserInfoSettingsState();
}

class _UserInfoSettingsState extends State<UserInfoSettings> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late String _profession;
  late String _password;
  bool _passwordConfirmed = false;

  @override
  void initState() {
    super.initState();
    _name = widget.profileData?['username'] ?? '';
    _email = widget.profileData?['email'] ?? '';
    _profession = widget.profileData?['profession'] ?? '';
    _password = widget.profileData?['password'] ?? '';
  }

  void _saveExperience() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (!_passwordConfirmed) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Password'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please confirm your password to save changes.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),

              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _formKey.currentState!.save();
                  // Implement your save logic here
                  print('Name: $_name');
                  print('Email: $_email');
                  print('Profession: $_profession');
                  // Avoid printing passwords in a real application
                  print('Password: $_password');
                  setState(() {
                    _passwordConfirmed = true;
                  });
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
                  );
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );
    } else {
      _formKey.currentState!.save();
      // Implement your save logic here
      print('Name: $_name');
      print('Email: $_email');
      print('Profession: $_profession');
      // Avoid printing passwords in a real application
      print('Password: $_password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info Settings'),
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                initialValue: _name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                initialValue: _email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add email validation if needed
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Profession'),
                initialValue: _profession,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your profession';
                  }
                  return null;
                },
                onSaved: (value) {
                  _profession = value!;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter your password to confirm your identity',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                initialValue: _password,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  // Add password validation if needed
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: TextButton(
                  onPressed: _saveExperience,
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: Text('Save',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: UserInfoSettings(
      // Pass the profile data here
      profileData: {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'profession': 'Software Developer',
        'password': '', // You might want to avoid passing the password if it shouldn't be prefilled
      },
    ),
  ));
}
