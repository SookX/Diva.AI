import 'dart:ffi';

import 'package:client/home/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 8, 27),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 40.h,),

          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 65,
                  backgroundImage: NetworkImage('https://res.cloudinary.com/djm6yhqvx/image/upload/v1735230618/qspf0rk9sa4ge0ykbaoc.jpg'),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 31, 28, 71), 
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Center(
            child: Text(
              "${userProvider.username ?? 'N/A'}",
              style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
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
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.person_outline, color: Colors.white),
                    SizedBox(width: 10.w),
                    Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),


          SizedBox(height: 10.h),

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

          MyList()

        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await Provider.of<UserProvider>(context, listen: false).logout();
    Navigator.of(context).pushReplacementNamed('/login');
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

// return Scaffold(
//       backgroundColor: const Color(0xFF030016),
//       appBar: AppBar(title: const Text("Profile")),
//       body: Center(
//         child: _isLoading
//             ? const CircularProgressIndicator(color: Colors.white)
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.logout),
//                     onPressed: () => logout(context),
//                   ),
//                   const SizedBox(height: 40),
//                   const Text(
//                     "User Profile",
//                     style: TextStyle(color: Colors.white, fontSize: 24),
//                   ),
//                   const SizedBox(height: 20),
                  // Text(
                  //   "Username: ${userProvider.username ?? 'N/A'}",
                  //   style: const TextStyle(color: Colors.white, fontSize: 18),
                  // ),
                  // const SizedBox(height: 10),
                  // Text(
                  //   "Email: ${userProvider.email ?? 'N/A'}",
                  //   style: const TextStyle(color: Colors.white, fontSize: 18),
                  // ),
//                 ],
//               ),
//       ),
//     );