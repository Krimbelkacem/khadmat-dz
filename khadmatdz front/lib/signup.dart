import 'package:flutter/material.dart';
import 'signin.dart';
import 'services/userService.dart'; // Import SignUpService
import './components/socialbuttongroup.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final SignUpService signUpService = SignUpService();
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: '937882510003-l1a9tqk3a81a7ivvkgs6j0rtdpkocu6f.apps.googleusercontent.com',
);

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TextEditingController objects for each input field
    TextEditingController fullNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff004445), // Updated to coweful blue
                  Color(0xff3AAFA9), // Updated to coweful blue
                ],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Create Your\nAccount',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      // Full Name TextField
                      controller: fullNameController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.check, color: Colors.grey),
                        label: Text(
                          'Full Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff004445),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        // You can store the value in a variable or use it directly
                      },
                    ),
                    TextField(
                      // Email TextField
                      controller: emailController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.check, color: Colors.grey),
                        label: Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff004445),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        // You can store the value in a variable or use it directly
                      },
                    ),
                    TextField(
                      // Password TextField
                      controller: passwordController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                        label: Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff004445),
                          ),
                        ),
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        // You can store the value in a variable or use it directly
                      },
                    ),
                    // Confirm Password TextField
                    const SizedBox(height: 10),
                    const SizedBox(height: 70),
                    GestureDetector(
                      onTap: () {
                        // Store the values entered by the user
                        String fullName = fullNameController.text;
                        String email = emailController.text;
                        String password = passwordController.text;

                        // Call signUp method of SignUpService when user taps the SIGN UP button
                        signUpService.signUp(
                          fullName,
                          email,
                          password,
                        ).then((_) {
                          // Navigate to the next screen or show a success message
                        }).catchError((error) {
                          // Handle error, show error message to the user
                        });
                      },
                      child: Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff004445), // Updated to coweful blue
                              Color(0xff3AAFA9), // Updated to coweful blue
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100,),
                  ],
                ),
              ),
            ),
          ),
          // Positioned at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: Column(
                children: [
                  SocialButtonGroup(
                    onGooglePressed: () async {
                      await signInWithGoogle();
                    },
                    onLinkedInPressed: () {
                      // Handle LinkedIn button press
                    },
                  ),
                  const SizedBox(height: 100,),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Sign in",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      final UserCredential authResult = await _auth.signInWithCredential(authCredential);
      final User user = authResult.user!;
      print('user email = ${user.email}');
    } else {
      // Handle sign-in cancellation
    }
  } catch (e) {
    // Handle sign-in errors
    print('Error signing in with Google: $e');
  }
}
