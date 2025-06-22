import 'package:flutter/material.dart';

class SurchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const SurchBar({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 10, 2, 34),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Color(0xFFACBBC0)),
          hintText: 'Search for a movie...',
          hintStyle: TextStyle(
            color: Color(0xFFACBBC0)
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

