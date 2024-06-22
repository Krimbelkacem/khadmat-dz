import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'signin.dart';
import 'nav/navigation.dart';
import 'pages/news.dart';
import 'services/authmanager.dart'; // Import your AuthManager class

// Import Firebase packages
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Initialize Firebase

  // Set system overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'inter',
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: AuthManager().isLoggedIn(), // Use AuthManager to check authentication
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(child: Text('Error: ${snapshot.error}')),
              );
            } else {
              return snapshot.data! ? const Nav() : const LoginScreen();
            }
          }
        },
      ),
    );
  }
}
