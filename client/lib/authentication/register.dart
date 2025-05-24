import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  Future<void> _register() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/user/register/');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'username': 'testuser',
      'email': 'test@example.com',
      'password': 'testpassword123',
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Registration successful: ${response.body}');
      } else {
        print('Registration failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: ElevatedButton(
          onPressed: _register,
          child: const Text('Register with Hardcoded Data'),
        ),
      ),
    );
  }
}
