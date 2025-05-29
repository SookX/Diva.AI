import 'package:client/home/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF030016),
      appBar: AppBar(title: Text("Profile")),
      body: Center(
        child: Column(
          children: [
            
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                logout(context);
              },
            ),

            SizedBox(height: 100,),
            
            Text("User Profile", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await Provider.of<UserProvider>(context, listen: false).logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
