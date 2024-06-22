import 'package:flutter/material.dart';
import 'nav/navigation.dart'; // Import the file where NewsFeedScreen is defined
import 'signup.dart';
import './components/socialbuttongroup.dart';
import 'services/userService.dart';
final SignInService _signInService = SignInService(); // Create an instance of SignInService


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TextEditingController objects for each input field
    TextEditingController passwordController = TextEditingController();
    TextEditingController emailController = TextEditingController();
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
          ),
          Positioned(
            top: 50, // Adjust top position as needed
            left: 50, // Adjust left position as needed
            child: Image.asset(
              '../images/logo.png', // Assuming your image is named 'logo.png' and located in the 'images' directory
              width: 400, // Adjust width as needed
              height: 100, // Adjust height as needed
              fit: BoxFit.contain, // Adjust fit as needed
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40), topRight: Radius.circular(40)),
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
                      controller: emailController,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.check, color: Colors.grey,),
                          label: Text('Gmail', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3AAFA9),
                          ),)
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.visibility_off, color: Colors.grey,),
                          label: Text('Password', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3AAFA9),
                          ),)
                      ),
                    ),
                    const SizedBox(height: 20,),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text('Forgot Password?', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xff281537),
                      ),),
                    ),
                    const SizedBox(height: 70,),
                    Container(
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
                      child: TextButton(
                        onPressed: () async {
                          // Call the signIn method from SignInService
                          try {

                            await _signInService.signIn(
                              emailController.text, // Assuming you have a TextEditingController for email
                              passwordController.text, // Assuming you have a TextEditingController for password
                            );
                            // Navigate to the NewsFeedScreen if sign-in is successful
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const Nav()),
                            );
                          } catch (e) {
                            // Handle sign-in errors
                            print('Error signing in: $e');
                            // Optionally, show an error message to the user
                          }
                        },
                        child: const Text(
                          'SIGN IN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100,),

                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Column(
                        children: [
                          SocialButtonGroup(
                            onGooglePressed: () {
                              // Handle Google button press
                            },
                            onLinkedInPressed: () {
                              // Handle LinkedIn button press
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100,),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the SignUpScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: const Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Don't have an account?", style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                            ),),
                            Text("Sign up", style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.black
                            ),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}