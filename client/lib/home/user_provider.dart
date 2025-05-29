import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _username;
  String? _email;

  bool get isAuthenticated => _isAuthenticated;
  String? get username => _username;
  String? get email => _email;

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    _isAuthenticated = token != null;
    if (_isAuthenticated) {
      await fetchUserProfile();
    }

    notifyListeners();
  }

  Future<void> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null) return;

    final url = Uri.parse('http://10.0.2.2:8000/api/user/'); 
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _username = data['username'];
      _email = data['email'];
    } else {
      _username = null;
      _email = null;
    }

    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');

    _isAuthenticated = false;
    _username = null;
    _email = null;

    notifyListeners();
  }

  Future<void> login(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);

    _isAuthenticated = true;
    await fetchUserProfile();

    notifyListeners();
  }
}
