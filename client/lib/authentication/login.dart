import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  Future<void> _login() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/user/login/');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': 'themastarayt@gmail.com',
      'password': '123',
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        final accessToken = data['token']['access'];
        final refreshToken = data['token']['refresh'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('refresh_token', refreshToken);

        print(response.body);
      } else {
        print('Login failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _login, 
          child: const Text('Login'),
        ),
      ),
    );
  }
}
