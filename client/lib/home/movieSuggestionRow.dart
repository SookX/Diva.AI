import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MovieSuggestionRow extends StatelessWidget {
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
            "You Might Also Like",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
                        Positioned(
                          bottom: 6,
                          right: 6,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Color(0xFF211C44),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              movie['rating']!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Color(0xFFD9B2F4),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 6.h),
                    SizedBox(
                      width: 100.w,
                      child: Text(
                        movie['title']!,
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
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
