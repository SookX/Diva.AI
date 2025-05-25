import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      body: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [

          SizedBox(height: 20.h,),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SurchBar(),
          ),
          
          SizedBox(height: 20.h,),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: MovieCard(
              imageUrl: 'https://res.cloudinary.com/djm6yhqvx/image/upload/v1742478610/qspf0rk9sa4ge0ykbaoc.jpg',
              name: "Inception",
              yearLengthRating: "2010 - 2h 28m - 8.8",
              types: ["Action", "Sci-Fi", "Thriller"],
              description: "A thief who steals corporate secrets through dream-sharing tech is given an impossible task.",
            ),
          ),
        ],
      )
    );
  }
}


class SurchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const SurchBar({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF101825),
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

class MovieCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String yearLengthRating;
  final List<String> types;
  final String description;

  const MovieCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.yearLengthRating,
    required this.types,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF101825),
      margin: EdgeInsets.all(12.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                imageUrl,
                width: 100.w,
                height: 150.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    '$yearLengthRating★',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Wrap(
                    spacing: 6.w,
                    runSpacing: 4.h,
                    children: types.map((type) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Color(0xFF211C44),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Color(0xFF4A2D86), width: 2.0), 
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Color(0xFFD9B2F4),
                        ),
                      ),
                    )).toList(),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[700],),
                  ),

                  SizedBox(height: 12.h),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _styledButton(
                          "Watch Trailer",
                          Color(0xFF211C44),
                          Color(0xFFD9B2F4),
                        ),
                      ),

                      SizedBox(width: 8.w),

                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Color(0xFF211C44),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: Color(0xFF4A2D86), width: 2.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_outline,
                                color: Color(0xFFD9B2F4),
                                size: 18.sp,
                              ),
                              SizedBox(width: 6.w),
                              Flexible(
                                child: Text(
                                  "Add to Favourite",
                                  style: TextStyle(
                                    fontSize: 12.5.sp,
                                    color: Color(0xFFD9B2F4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _styledButton(String text, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Color(0xFF4A2D86), width: 2.0),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.5.sp,
          color: textColor,
        ),
      ),
    );
  }



}