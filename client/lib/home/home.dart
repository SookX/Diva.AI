import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'navbar.dart';
import 'movieCard.dart';
import 'searchBar.dart';
import 'movieSuggestionRow.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF030016),
      appBar: Navbar(),
      body: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [

          SizedBox(height: 20.h,),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SurchBar(),
          ),
          
          SizedBox(height: 30.h,),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: MovieCard(
              imageUrl: 'https://res.cloudinary.com/djm6yhqvx/image/upload/v1735230618/qspf0rk9sa4ge0ykbaoc.jpg',
              name: "Inception",
              yearLengthRating: "2010 - 2h 28m - 8.8",
              types: ["Action", "Sci-Fi", "Thriller"],
              description: "A thief who steals corporate secrets.",
            ),
          ),

          SizedBox(height: 50.h,),

          MovieSuggestionRow(),

        ],
      )
    );
  }
}


