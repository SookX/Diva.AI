import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:client/home/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/user/login/');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': emailController.text,
      'password': passwordController.text,
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

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.login(accessToken, refreshToken);

        print('Login successful!');
        print(response.body);
        _showNotification("Login successful!", true);
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushNamed(context, '/');
        });


      } else {
        print('Login failed: ${response.statusCode} ${response.body}');
        _showNotification("Login failed. Please check your credentials.", false);
      }
    } catch (e) {
      print('Error occurred: $e');
      _showNotification("$e", false);
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        _showNotification("Google sign-in cancelled.", false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        _showNotification("Failed to retrieve Google ID token.", false);
        return;
      }

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/user/google-login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final accessToken = data['access'];
        final refreshToken = data['refresh'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('refresh_token', refreshToken);

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.login(accessToken, refreshToken);


        _showNotification("Google login successful!", true);
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushNamed(context, '/');
        });
      } else {
        _showNotification("Backend login failed. ${response.statusCode}", false);
      }
    } catch (e) {
      print("Google login error: $e");
      _showNotification("Google login error: $e", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030016),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            
              SizedBox(height: 130.h,),
            
              Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.sp,
                ),
              ),
              SizedBox(height: 50.h),

              _buildTextField(
                controller: emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.h),

              _buildTextField(
                controller: passwordController,
                label: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 30.h),

              SizedBox(
                width: double.infinity, 
                height: 60.h, 
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF33296C),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h,),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xFF121023),
                      thickness: 1,
                      endIndent: 20, // space before "or"
                    ),
                  ),
                  const Text(
                    'or',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color(0xFF121023),
                      thickness: 1,
                      indent: 20, // space after "or"
                    ),
                  ),
                ],
              ),
                
              SizedBox(height: 20.h,),

              _socialButton(
                label: "Continue with Google",
                logoUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/2048px-Google_%22G%22_logo.svg.png",
                onPressed: _loginWithGoogle,
              ),
              SizedBox(height: 16.h),
              _socialButton(
                label: "Continue with Facebook",
                logoUrl: "https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_(2019).png",
                onPressed: () {
      
                },
              ),

              SizedBox(height: 40.h,),

              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'Register',
                      style: TextStyle(
                        color: Color(0xFF33296C),
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, '/register');
                        },
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Color.fromARGB(255, 19, 17, 40),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }

  Widget _socialButton({
    required String label,
    required String logoUrl,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 19, 17, 40),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                logoUrl,
                height: 23.h,
                width: 23.h,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              flex: 4,
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotification(String message, bool success) {
    Flushbar(
      message: message,
      icon: Icon(
        success ? Icons.check_circle : Icons.error,
        size: 28.0,
        color: success ? Colors.green : Colors.red,
      ),
      duration: Duration(seconds: 2),
      leftBarIndicatorColor: success ? Colors.green : Colors.red,
      margin: EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(8),
      backgroundGradient: LinearGradient(
        colors: success
            ? [Colors.green.shade700, Colors.greenAccent]
            : [Colors.red.shade700, Colors.redAccent],
      ),
      flushbarPosition: FlushbarPosition.TOP,
      animationDuration: Duration(milliseconds: 500),
    ).show(context);
  }

}
