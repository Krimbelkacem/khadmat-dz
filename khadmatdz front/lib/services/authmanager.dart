import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  // Singleton pattern: ensuring only one instance of AuthManager exists
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;
  AuthManager._internal();

  // Method to check if the user is logged in
  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('session_id');
    return sessionId != null;
  }

  // Method to retrieve the session ID from local storage
  Future<String?> getSessionId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_id');
  }

  // Method to save the session ID to local storage
  Future<void> saveSessionId(String sessionId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_id', sessionId);
  }

  // Method to clear the session ID from local storage (sign out)
  Future<void> clearSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_id');
  }
}
