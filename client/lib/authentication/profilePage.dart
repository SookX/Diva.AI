import 'package:client/home/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF030016),
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => logout(context),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "User Profile",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Username: ${userProvider.username ?? 'N/A'}",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Email: ${userProvider.email ?? 'N/A'}",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
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
