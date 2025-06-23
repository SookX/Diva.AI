import 'dart:io';
import 'package:client/home/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:another_flushbar/flushbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool isEditingUsername = false;
  bool isChangingPassword = false;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController(); 
  final TextEditingController _usernameController = TextEditingController();

  final List<String> types = ["type1", "type2"];

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    await Provider.of<UserProvider>(context, listen: false).fetchUserProfile();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      // send to the backend
    }
  }

  Future<void> changeName() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) return;

    final newUsername = _usernameController.text.trim();

    if (newUsername.isEmpty) return;

    final url = Uri.parse('http://10.0.2.2:8000/api/user/');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'new_username': newUsername}),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      Provider.of<UserProvider>(context, listen: false).fetchUserProfile();
    } else {
      print("Failed to update username: ${response.body}");
    }
  }

  Future<void> changePassword() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) return;

    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty) return;

    final url = Uri.parse('http://10.0.2.2:8000/api/user/');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      _showNotification("Password changed successfully", true);
      setState(() {
        isChangingPassword = false;
        _oldPasswordController.clear();
        _newPasswordController.clear();
      });
    } else {
      _showNotification("Failed to change password", false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 8, 27),
      body: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 40.h,),

          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 65,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!) as ImageProvider
                      : const NetworkImage(
                          'https://res.cloudinary.com/djm6yhqvx/image/upload/v1735230618/qspf0rk9sa4ge0ykbaoc.jpg',
                        ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 31, 28, 71),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Center(
            child: isEditingUsername
                ? SizedBox(
                    width: 250.w,
                    child: TextField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Enter username',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                      ),
                      onSubmitted: (value) {
                        setState(() {
                          isEditingUsername = false;
                          changeName();
                        });
                      },
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        isEditingUsername = true;
                        _usernameController.text = userProvider.username ?? '';
                      });
                    },
                    child: Text(
                      userProvider.username ?? 'N/A',
                      style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
          ),

          Center(
            child: Text(
                "${userProvider.email ?? 'N/A'}",
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
          ),


          SizedBox(height: 30.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 24, 21, 53),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                ),
                onPressed: () {
                  logout(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 10.w),
                    Text(
                      'Log Out',
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),


          SizedBox(height: 10.h,),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 700),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final offsetAnimation = Tween<Offset>(
                  begin: const Offset(0.0, 0.0),
                  end: Offset.zero,
                ).animate(animation);
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(position: offsetAnimation, child: child),
                );
              },
              child: isChangingPassword
                  ? Column(
                      key: ValueKey('changePasswordForm'),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _oldPasswordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Old Password',
                            labelStyle: TextStyle(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white54),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: _newPasswordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'New Password',
                            labelStyle: TextStyle(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white54),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 24, 21, 53),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                              ),
                              onPressed: changePassword,
                              child: Text(
                                'Save',
                                style: TextStyle(fontSize: 16.sp, color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                              ),
                              onPressed: () {
                                setState(() {
                                  isChangingPassword = false;
                                  _oldPasswordController.clear();
                                  _newPasswordController.clear();
                                });
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(fontSize: 14.sp, color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  : SizedBox(
                      key: ValueKey('changePasswordButton'),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 24, 21, 53),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                        ),
                        onPressed: () {
                          setState(() {
                            isChangingPassword = true;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.lock_outline, color: Colors.white),
                            SizedBox(width: 10.w),
                            Text(
                              'Change Password',
                              style: TextStyle(fontSize: 16.sp, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),


          SizedBox(height: 30.h,),

          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Favorite Genres",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),  
            ),
          ),

          SizedBox(height: 15.h,),
          
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Wrap(
              spacing: 6.w,
              runSpacing: 4.h,
              children: types.map((type) => Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Color(0xFF211C44),
                  borderRadius: BorderRadius.circular(12.r),

                ),
                child: Text(
                  type,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
              )).toList(),
            ),
          ),

          SizedBox(height: 40,),


          MyList(),
          ],

      ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await Provider.of<UserProvider>(context, listen: false).logout();
    Navigator.of(context).pushReplacementNamed('/login');
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

class MyList extends StatelessWidget {
  MyList({super.key});

  final List<Map<String, String>> suggestions = [
    {
      'title': 'Prisoners',
      'image': 'https://res.cloudinary.com/djm6yhqvx/image/upload/v1742478610/qspf0rk9sa4ge0ykbaoc.jpg',
      'rating': '8.1'
    },
    {
      'title': 'Zodiac',
      'image': 'https://res.cloudinary.com/djm6yhqvx/image/upload/v1735230618/qspf0rk9sa4ge0ykbaoc.jpg',
      'rating': '7.7'
    },
    {
      'title': 'Se7en',
      'image': 'https://res.cloudinary.com/djm6yhqvx/image/upload/v1735230618/qspf0rk9sa4ge0ykbaoc.jpg',
      'rating': '8.6'
    },
    {
      'title': 'Shutter Island',
      'image': 'https://res.cloudinary.com/djm6yhqvx/image/upload/v1735230618/qspf0rk9sa4ge0ykbaoc.jpg',
      'rating': '8.3'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "Watchlist",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold
            ), 
          ),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            children: suggestions.map((movie) {
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            movie['image']!,
                            width: 100.w,
                            height: 150.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    
                  ],
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

}