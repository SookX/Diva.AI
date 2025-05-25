import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

   @override
    Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        // leading: Text('data'),
        actions: [
          IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.account_circle_sharp, color: Color(0xFF3C3F63), size: 45),
            ),
            onPressed: () {
              
            },
          ),
        ],
      );
  }
}