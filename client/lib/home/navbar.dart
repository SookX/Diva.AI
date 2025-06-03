import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<UserProvider>().isAuthenticated;

    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      actions: [
        GestureDetector(
          onTap: () {
            if (isAuthenticated) {
              Navigator.pushNamed(context, '/profile');
            } else {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              radius: 19,
              backgroundColor: Colors.transparent,
              backgroundImage: isAuthenticated
                  ? NetworkImage('https://res.cloudinary.com/djm6yhqvx/image/upload/v1735230618/qspf0rk9sa4ge0ykbaoc.jpg')
                  : null,
              child: !isAuthenticated
                  ? Icon(Icons.account_circle_sharp, color: Color(0xFF3C3F63), size: 45)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
