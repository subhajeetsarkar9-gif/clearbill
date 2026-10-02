import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userEmail = '';
  String _userName = '';
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  String get userEmail => _userEmail;
  String get userName => _userName;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    _userEmail = prefs.getString('user_email') ?? '';
    _userName = prefs.getString('user_name') ?? '';
    notifyListeners();
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = true;
      _userEmail = 'user@clearbill.com';
      _userName = 'Clear Bill User';

      await prefs.setBool('is_logged_in', true);
      await prefs.setString('user_email', _userEmail);
      await prefs.setString('user_name', _userName);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loginAsGuest() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = true;
    _userEmail = 'guest@clearbill.com';
    _userName = 'Guest User';

    await prefs.setBool('is_logged_in', true);
    await prefs.setString('user_email', _userEmail);
    await prefs.setString('user_name', _userName);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isLoggedIn = false;
    _userEmail = '';
    _userName = '';
    notifyListeners();
  }
}
