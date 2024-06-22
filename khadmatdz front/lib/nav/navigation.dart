import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import '../pages/activities/addproposal.dart';
import '../pages/home/home_screen.dart';
import '../pages/profile/profilescreen.dart';
import '../components/bottomnav.dart';
import '../components/appdrawer.dart';
import '../services/authmanager.dart'; // Import AuthManager
import '../models/usermodel.dart';
import '../services/userservice.dart';
import '../signin.dart';

class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  _NavState createState() => _NavState();
}
class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  bool _isClient = false; // Added flag to track if the user is a client

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final Map<String, dynamic> fetchedProfileData =
      await ProfileService().getProfile();
      bool isClient = fetchedProfileData['isClient'] ?? true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isClient', isClient);
      setState(() {
        _isClient = isClient; // Update the state based on the fetched profile data
      });
    } catch (e) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
      print('Error fetching profile: $e');
    }
  }

  void checkLoginStatus() async {
    bool isLoggedIn = await AuthManager().isLoggedIn();
    if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomeScreen(),
          AddProposal(),
          ProfileScreen(),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,

        type: BottomNavigationBarType.fixed,
        items: _isClient // Dynamically modify the bottom navigation items based on the user's client status
            ? [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'add', // Label is empty for the middle icon

          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ]
            : [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedLabelStyle: TextStyle(color: Color(0xff3AAFA9)),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        selectedIconTheme: IconThemeData(color: Color(0xff3AAFA9)),
        unselectedIconTheme: IconThemeData(color: Colors.grey),
      ),
    );
  }
}
