import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ConstantManager{

  static const primaryClr = Color(0xFF23074d);
  static const secondaryClr = Color(0xFFcc5333);

  static const whiteLogoPath = 'assets/logo/logo_white.png';
  static const blackLogoPath = 'assets/logo/logo_black.png';

  static const maleChefAvatar = 'https://firebasestorage.googleapis.com/v0/b/recipe-app-fyp.appspot.com/o/profile_images%2Fmale_chef.jpg?alt=media&token=b42534b1-6f64-472c-b6ff-0cdf05c18d9c';
  static const femaleChefAvatar = 'https://firebasestorage.googleapis.com/v0/b/recipe-app-fyp.appspot.com/o/profile_images%2Ffemale_chef.jpg?alt=media&token=88dbca17-74eb-4167-8add-08892a3b5c75';

  static var ktextStyle = GoogleFonts.ubuntu();
  static var htextStyle = GoogleFonts.lobsterTwo();

  static BoxDecoration getBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(25.0)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 3,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    );
  }

  static void screenNavigation(context, route) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => route),
    );
  }

  static void screenNavWithClear(context, route) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => route,
      ),
          (route) => false,
    );
  }

  static showtoast(msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.white,
      textColor: Colors.grey.shade900,
    );
  }

  static snackBar(String? message, context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: Duration(seconds: 3),
      ),
    );
  }

  static String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }


  static const RAW_DATA = [
    {
      'recipe_name': 'Chicken Tikka Pizza',
      'imgUrl': 'https://pbs.twimg.com/media/E00HBeqXMAEEmLT.jpg',
      'likes': 256,
      'dislikes': 185,
      'user_name': 'arsalan_rehman',
      'user_img': 'assets/images/male_profile_avatar.jpg',
    },
    {
      'recipe_name': 'Creamy Chessy Burger',
      'imgUrl':
      'https://images.saymedia-content.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTc0Mzc4NTY2MjIwNjUzOTI4/best-burger-restaurant-names.jpg',
      'likes': 256,
      'dislikes': 185,
      'user_name': 'arsalan_rehman',
      'user_img': 'assets/images/male_profile_avatar.jpg'
    },
    {
      'recipe_name': 'Masala Biryani',
      'imgUrl':
      'https://i.pinimg.com/originals/2d/47/55/2d4755077b1c7d3d583e0b36bc772185.jpg',
      'likes': 256,
      'dislikes': 185,
      'user_name': 'rohab_khalid',
      'user_img': 'assets/images/female_profile_avatar.jpg'
    },
    {
      'recipe_name': 'Italiano Pasta',
      'imgUrl': 'https://i.ytimg.com/vi/JEeO_hagtVM/maxresdefault.jpg',
      'likes': 256,
      'dislikes': 185,
      'user_name': 'arsalan_rehman',
      'user_img': 'assets/images/male_profile_avatar.jpg'
    },
    {
      'recipe_name': 'Beef Shawarma',
      'imgUrl':
      'https://hips.hearstapps.com/vidthumb/images/190130-chicken-shwarma-horizontal-1551285400.png',
      'likes': 256,
      'dislikes': 185,
      'user_name': 'rohab_khalid',
      'user_img': 'assets/images/female_profile_avatar.jpg'
    },
    {
      'recipe_name': 'Chicken Tikka Pizza',
      'imgUrl': 'https://pbs.twimg.com/media/E00HBeqXMAEEmLT.jpg',
      'likes': 256,
      'dislikes': 185,
      'user_name': 'arsalan_rehman',
      'user_img': 'assets/images/male_profile_avatar.jpg',
    },
    {
      'recipe_name': 'Creamy Chessy Burger',
      'imgUrl':
      'https://images.saymedia-content.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTc0Mzc4NTY2MjIwNjUzOTI4/best-burger-restaurant-names.jpg',
      'likes': 256,
      'dislikes': 185,
      'user_name': 'arsalan_rehman',
      'user_img': 'assets/images/male_profile_avatar.jpg'
    },
    {
      'recipe_name': 'Masala Biryani',
      'imgUrl':
      'https://i.pinimg.com/originals/2d/47/55/2d4755077b1c7d3d583e0b36bc772185.jpg',
      'likes': 256,
      'dislikes': 185,
      'user_name': 'rohab_khalid',
      'user_img': 'assets/images/female_profile_avatar.jpg'
    },
    {
      'recipe_name': 'Italiano Pasta',
      'imgUrl': 'https://i.ytimg.com/vi/JEeO_hagtVM/maxresdefault.jpg',
      'likes': 256,
      'dislikes': 185,
      'user_name': 'arsalan_rehman',
      'user_img': 'assets/images/male_profile_avatar.jpg'
    },
    {
      'recipe_name': 'Beef Shawarma',
      'imgUrl':
      'https://hips.hearstapps.com/vidthumb/images/190130-chicken-shwarma-horizontal-1551285400.png',
      'likes': 256,
      'dislikes': 185,
      'user_name': 'rohab_khalid',
      'user_img': 'assets/images/female_profile_avatar.jpg'
    },
  ];
}

